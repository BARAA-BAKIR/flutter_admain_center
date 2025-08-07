import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_student_bloc/center_add_student_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_student_screen.dart';
import 'package:flutter_admain_center/features/center_manager/widgets/filter_dialig_view.dart';
import 'package:flutter_admain_center/features/center_manager/widgets/transfer_student_dialog.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_student/profile_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/student_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // لاستخدام Timer في الـ Debounce

// 1. استيراد كل الملفات اللازمة
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // --- دوال التحكم بالواجهة التي كتبتها أنت (مع الحفاظ عليها) ---

  void _onScroll() {
    if (_isBottom) {
      context.read<StudentsBloc>().add(FetchMoreStudents());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  // دالة البحث مع Debounce لتجنب إرسال طلبات كثيرة
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // إرسال حدث البحث إلى البلوك
      context.read<StudentsBloc>().add(FetchStudents(searchQuery: query));
    });
  }

void _showFilterDialog() {
    final studentBloc = context.read<StudentsBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // مهم للسماح للنافذة بالتمدد
      builder: (_) => BlocProvider(
        create: (ctx) => FilterBloc(repository: studentBloc.centerManagerRepository)..add(LoadFilterData()),
        // ====================  هنا هو الإصلاح ====================
        // إزالة const من استدعاء FilterDialogView
        child: FilterDialogView(
          onApply: (halaqaId, levelId) {
            studentBloc.add(ApplyStudentsFilter(halaqaId: halaqaId, levelId: levelId));
          },
        ),
        // =======================================================
      ),
    );
  }
  // دالة لعرض قائمة الخيارات للطالب (تبقى كما هي للمستقبل)
  void _showStudentOptions(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        // استخدام ctx لتجنب التضارب
        return Wrap(
          children: <Widget>[
            // 1. عرض الملف الشخصي (يعمل)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('عرض الملف الشخصي'),
              onTap: () async {
                Navigator.pop(ctx); // أغلق النافذة أولاً
                final updatedStudent = await Navigator.of(
                  context,
                ).push<Student>(
                  MaterialPageRoute(
                     builder: (_) => BlocProvider(
                      create: (context) => ProfileBloc(
                        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
                      )..add(FetchProfileData(student.id)),
                      child: StudentProfileView(studentName: student.fullName),
                    ),
                  ),
                );
                if (updatedStudent != null && context.mounted) {
                    context.read<StudentsBloc>().add(
                    UpdateStudentInList(updatedStudent),
                  );     }
              },
            ),
            // تعديل البيانات
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل البيانات'),
              onTap: () async {
                Navigator.pop(ctx);
                // ننتظر نتيجة شاشة التعديل
                final updatedStudent = await Navigator.of(
                  context,
                ).push<Student>(
                  MaterialPageRoute(
                    // هنا يجب توفير EditStudentBloc للشاشة
                    builder: (_) => EditStudentScreen(student: student),
                  ),
                );
                // إذا عادت بيانات محدثة، نرسل حدثاً لتحديث الواجهة
                if (updatedStudent != null) {
                  context.read<StudentsBloc>().add(
                    UpdateStudentInList(updatedStudent),
                  );
                }
              },
            ),
            // ==========================================================

            // ====================  تفعيل خيار النقل ====================
            ListTile(
              leading: const Icon(Icons.sync_alt),
              title: const Text('نقل الطالب'),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder:
                      (_) => TransferStudentDialog(
                        studentId: student.id,
                        studentName: student.fullName,
                      ),
                );
              },
            ),
            // 4. حذف الطالب (يعمل)
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
              title: Text(
                'حذف الطالب',
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () {
                Navigator.pop(ctx); // أغلق النافذة
                // عرض رسالة تأكيد قبل الحذف
                showDialog(
                  context: context,
                  builder:
                      (dialogCtx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text(
                          'هل أنت متأكد من رغبتك في حذف الطالب ${student.fullName}؟',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('إلغاء'),
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                          TextButton(
                            child: const Text(
                              'حذف',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // إرسال حدث الحذف إلى البلوك
                              context.read<StudentsBloc>().add(
                                DeleteStudent(student.id),
                              );
                              Navigator.pop(dialogCtx);
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // --- بناء الواجهة الكاملة ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'إدارة الطلاب',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 2. تفعيل شريط البحث والفلترة بالكامل
          SearchAndFilterBar(
            onFilterTap: _showFilterDialog,
            onSearchChanged: _onSearchChanged,
          ),
          // 3. ربط القائمة بالبلوك لعرض البيانات الحية
          Expanded(
            child: BlocBuilder<StudentsBloc, StudentsState>(
              builder: (context, state) {
                switch (state.status) {
                  case StudentsStatus.failure:
                    return Center(
                      child: Text('فشل تحميل البيانات: ${state.errorMessage}'),
                    );

                  case StudentsStatus.success:
                    if (state.students.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد طلاب يطابقون هذا البحث.'),
                      );
                    }
                    // استخدام ListView.builder لعرض البيانات الحقيقية
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.hasReachedMax
                              ? state.students.length
                              : state.students.length + 1,
                      itemBuilder: (context, index) {
                        // عرض مؤشر التحميل في نهاية القائمة إذا لم نصل للنهاية
                        if (index >= state.students.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        // عرض بيانات الطالب الحقيقية
                        final student = state.students[index];
                        return ListItemTile(
                          title: student.fullName,
                          subtitle: student.halaqa?.name ?? 'بلا حلقة',
                          onMoreTap:
                              () => _showStudentOptions(context, student),
                        );
                      },
                    );

                  // عرض مؤشر التحميل أثناء جلب البيانات الأولية
                  case StudentsStatus.loading:
                  case StudentsStatus.initial:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      // زر الإضافة يبقى كما هو للمستقبل
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    // --- حقن البلوك الخاص بمدير المركز ---
                    create:
                        (context) => CenterAddStudentBloc(
                          centerManagerRepository:
                              context.read<CenterManagerRepository>(),
                        )..add(
                          FetchCenterInitialData(),
                        ), // طلب الحلقات والمراحل فوراً
                    child: const AddStudentScreen(), // لا نحتاج لتمرير أي شيء
                  ),
            ),
          );
          // تحديث القائمة عند العودة بنجاح
          if (result == true && mounted) {
            context.read<StudentsBloc>().add(const FetchStudents());
          }
        },
        label: const Text('إضافة طالب'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.teal_blue,
      ),
    );
  }
}

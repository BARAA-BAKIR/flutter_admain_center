import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_student_bloc/center_add_student_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/center_add_student_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_student_screen.dart';
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
      // نرسل حدثاً جديداً للبحث
      context.read<StudentsBloc>().add(FetchStudents(searchQuery: query));
    });
  }

  //  void _showFilterDialog() {
  //   // نقرأ الـ repository مباشرة من الـ context الحالي
  //   final repository = context.read<CenterManagerRepository>();
  //   final studentBloc = context.read<StudentsBloc>(); // نحتاجه لتطبيق الفلتر

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) => BlocProvider(
  //       // نمرر الـ repository الذي قرأناه لـ FilterBloc
  //       create: (ctx) => FilterBloc(repository: repository)..add(LoadFilterData()),
  //       child: FilterDialogView(
  //         onApply: (halaqaId, levelId) {
  //           // عند الضغط على "تطبيق"، نرسل حدثاً لـ StudentsBloc
  //           studentBloc.add(
  //             ApplyStudentsFilter(halaqaId: halaqaId, levelId: levelId),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // دالة لعرض قائمة الخيارات للطالب (تبقى كما هي للمستقبل)
  void _showStudentOptions(BuildContext context, StudentListItem student) {
    final centerManagerRepo = context.read<CenterManagerRepository>();
    final teacherRepo = context.read<TeacherRepository>();
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
                Navigator.pop(ctx);
                // ==================== هنا هو التصحيح ====================
                // لا ننتظر نتيجة هنا لأن شاشة العرض لا تعيد شيئاً
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => MultiRepositoryProvider(
                          providers: [
                            RepositoryProvider.value(value: centerManagerRepo),
                            RepositoryProvider.value(value: teacherRepo),
                          ],
                          child: BlocProvider(
                            create:
                                (context) => ProfileBloc(
                                  teacherRepository:
                                      context.read<TeacherRepository>(),
                                )..add(FetchProfileData(student.id)),
                            child: StudentProfileView(
                              studentName: student.fullName,
                            ),
                          ),
                        ),
                  ),
                );
                // =======================================================
              },
            ),
            // تعديل البيانات
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل البيانات'),
              onTap: () async {
                Navigator.pop(ctx); // أغلق النافذة السفلية أولاً
                print(
                  "▶️ [StudentsScreen] 'Edit' tapped. Preparing to navigate...",
                );

                try {
                  // 1. احصل على كلا الـ Repositories من السياق الحالي بأمان
                  final centerManagerRepo =
                      context.read<CenterManagerRepository>();
                  final teacherRepo = context.read<TeacherRepository>();
                  print("  ✅ Repositories read successfully.");

                  // 2. انتقل إلى شاشة التعديل
                  print("  ⏳ Navigating to EditStudentScreen...");
                  final updatedStudent = await Navigator.of(
                    context,
                  ).push<StudentDetails>(
                    MaterialPageRoute(
                      builder: (_) {
                        print(
                          "    ▶️ Building MaterialPageRoute for EditStudentScreen...",
                        );
                        // 3. استخدم MultiRepositoryProvider لتوفير كلا الاعتماديتين
                        return MultiRepositoryProvider(
                          providers: [
                            RepositoryProvider.value(value: centerManagerRepo),
                            RepositoryProvider.value(value: teacherRepo),
                          ],
                          child: EditStudentScreen(
                            studentId: student.id,
                            studentName: student.fullName,
                          ),
                        );
                      },
                    ),
                  );

                  print("✅ [StudentsScreen] Returned from EditStudentScreen.");

                  // هذا الجزء يتم بعد العودة من شاشة التعديل
                  if (updatedStudent != null && mounted) {
                    print("  🔄 Student data was updated. Refreshing list.");
                    context.read<StudentsBloc>().add(
                      UpdateStudentInList(updatedStudent),
                    );
                  } else {
                    print("  ℹ️ No update was made or returned.");
                  }
                } catch (e, stackTrace) {
                  // هذا الجزء سيمسك بأي خطأ يحدث أثناء عملية الانتقال
                  print(
                    "❌❌❌ [StudentsScreen] CRITICAL ERROR during navigation setup: $e",
                  );
                  print(stackTrace);
                }
              },
            ),
            // ==========================================================

            // ====================  تفعيل خيار النقل ====================
            ListTile(
              leading: const Icon(Icons.sync_alt),
              title: const Text('نقل الطالب'),
              onTap: () async {
                Navigator.pop(ctx);
                final updatedStudent = await showDialog<StudentDetails>(
                  context: context,
                  builder:
                      (_) => RepositoryProvider.value(
                        value: centerManagerRepo,
                        child: TransferStudentDialog(
                          studentId: student.id,
                          studentName: student.fullName,
                          // ==================== هنا هو التعديل ====================
                          currentHalaqaId: student.id, // نمرر ID الحلقة الحالية
                          // =======================================================
                        ),
                      ),
                );

                if (updatedStudent != null && mounted) {
                  context.read<StudentsBloc>().add(
                    UpdateStudentInList(updatedStudent),
                  );
                }
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
      body:  RefreshIndicator(
                      onRefresh: () async {
                        // عند السحب، أرسل حدث جلب البيانات من جديد
                        context.read<StudentsBloc>().add(const FetchStudents());
                      },
        child: Column(
          children: [
            // 2. تفعيل شريط البحث والفلترة بالكامل
            SearchAndFilterBar(
              onSearchChanged: _onSearchChanged,
              hintText: 'ابحث عن طالب بالاسم ...',
            ),
            // 3. ربط القائمة بالبلوك لعرض البيانات الحية
            Expanded(
              child: BlocBuilder<StudentsBloc, StudentsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case StudentsStatus.failure:
                      return Column(
                        children: [
                          Center(
                            child: Text('فشل تحميل البيانات: ${state.errorMessage}'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<StudentsBloc>().add(const FetchStudents()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('تحديث'),
                          ),
                        ],
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
                            subtitle: student.halaqaName ?? 'بلا حلقة',
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
      ),
      // زر الإضافة يبقى كما هو للمستقبل
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    // ✅ هنا يتم إنشاء البلوك وتوفيره
                    create:
                        (context) => CenterAddStudentBloc(
                          centerManagerRepository:
                              context.read<CenterManagerRepository>(),
                        )..add(FetchCenterInitialData()),
                    child:
                        const CenterAddStudentScreen(), // الشاشة الآن تجد البلوك فوقها
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
        backgroundColor: AppColors.light_blue,
      ),
    );
  }
}

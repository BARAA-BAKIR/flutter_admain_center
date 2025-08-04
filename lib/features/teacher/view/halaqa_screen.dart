// lib/features/teacher/view/halaqa_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/student_model.dart';
import 'package:flutter_admain_center/features/teacher/widgets/halaqa_screen/build_attendance.dart';
import 'package:flutter_admain_center/features/teacher/widgets/halaqa_screen/get_border_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// تأكد من صحة مسارات الاستيراد بناءً على اسم مشروعك
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/teacher/bloc/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/student_follow_up_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/student_profile_screen.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

class HalaqaScreen extends StatelessWidget {
  // 1. احذف teacherRepository من الكونستركتور.
  // الشاشة لم تعد بحاجة لاستقبال أي متغيرات.
  const HalaqaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. توفير الـ Bloc باستخدام RepositoryProvider من الـ context
    return BlocProvider(
      create:
          (context) => HalaqaBloc(
            // اقرأ الـ Repository الذي تم توفيره في main.dart
            teacherRepository: RepositoryProvider.of<TeacherRepository>(
              context,
            ),
          )..add(FetchHalaqaData()), // طلب البيانات فوراً

      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: _buildAppBar(),
        // --- هنا التعديل الكامل ---
        body: BlocListener<HalaqaBloc, HalaqaState>(
          listenWhen: (previous, current) {
            // استمع فقط عندما تتغير حالة isRefreshing من true إلى false
            return previous.isRefreshing == true &&
                current.isRefreshing == false;
          },
          // 1. الاستماع للأخطاء لعرض SnackBar
          listener: (context, state) {
            if (state.error == null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('تم التحديث بنجاح'),
                    backgroundColor: Colors.green.shade700, // لون أخضر للنجاح
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(
                      bottom: 50.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
            }
            // اعرض SnackBar فقط إذا كان هناك خطأ، وكانت هناك بيانات قديمة معروضة
            // هذا يمنع ظهور SnackBar عند الخطأ الأولي (عدم وجود كاش)
            if (state.error != null && state.halaqa != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('فشل تحديث البيانات: ${state.error}'),
                    backgroundColor: Colors.orange.shade800,
                    // --- هذا هو الإصلاح ---
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(
                      bottom: 50.0, // ارفع الـ SnackBar فوق الزر العائم
                      left: 16.0,
                      right: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
            }
          },
          // 2. بناء الواجهة بناءً على البيانات
          child: BlocBuilder<HalaqaBloc, HalaqaState>(
            builder: (context, state) {
              // --- منطق العرض المحسّن ---

              // الحالة 1: التحميل الأولي (لا توجد أي بيانات على الإطلاق)
              if (state.isLoading && state.halaqa == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // الحالة 2: خطأ أولي (لا يوجد كاش ولا يوجد إنترنت)
              // نعرض الخطأ فقط إذا لم تكن هناك أي بيانات على الإطلاق لعرضها
              if (state.error != null && state.halaqa == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('حدث خطأ: ${state.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => context.read<HalaqaBloc>().add(
                              FetchHalaqaData(),
                            ),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              // الحالة 3: لا توجد بيانات (نجح التحميل ولكن الحلقة فارغة أو غير موجودة)
              if (state.halaqa == null) {
                return const Center(
                  child: Text('لم يتم العثور على بيانات الحلقة.'),
                );
              }

              // الحالة 4 (الأهم): عرض البيانات الموجودة
              // سواء كانت من الكاش أو من تحديث ناجح
              return RefreshIndicator(
                onRefresh: () async {
                  // عند السحب، أرسل الحدث وانتظر اكتماله
                  context.read<HalaqaBloc>().add(FetchHalaqaData());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // إذا كان هناك خطأ في التحديث، اعرض رسالة تحذير في الأعلى
                    if (state.error != null)
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.orange.withOpacity(0.2),
                        child: Text(
                          'فشل آخر تحديث. البيانات المعروضة قد تكون قديمة.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                      ),
                    _buildHalaqaHeader(state.halaqa!),
                    const SizedBox(height: 24),
                    Text(
                      "الطلاب",
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.night_blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStudentList(context, state.halaqa!.students),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- AppBar بقي هنا ليكون خاصاً بهذه الشاشة ---
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image.asset('assets/image.png', height: 10,width: 10,),
          Text(
            'حلقتي', // تم تغيير العنوان ليعكس اسم الشاشة
            style: GoogleFonts.tajawal(
              color: AppColors.night_blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.steel_blue,
            size: 28,
          ),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.light_sky_blue,
            child: Icon(Icons.person, color: AppColors.steel_blue),
          ),
        ),
      ],
    );
  }

  Widget _buildHalaqaHeader(MyhalaqaModel halaqa) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // جلب من البلوك اسم الحلقة
          Text(
            'حلقة ${halaqa.namehalaqa}',
            style: GoogleFonts.tajawal(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.night_blue,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.group_outlined,
                color: AppColors.teal_blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${halaqa.countstudent} طالب',
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(BuildContext context, List<Student> students) {
    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'لا يوجد طلاب في هذه الحلقة بعد. اضغط على زر + لإضافة طالب جديد.',
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) => StudentCard(student: students[index]),
    );
  }
}

// --- ويدجت بطاقة الطالب) ---
class StudentCard extends StatelessWidget {
  final Student student;
 // final HalaqaBloc halaqaBloc;
  const StudentCard({
    super.key,
    required this.student,
   // required this.halaqaBloc,
  });

  @override
  Widget build(BuildContext context) {
    final status = student.attendanceStatus;
    final statusColor = getBorderColor(status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color:
              status == AttendanceStatus.pending
                  ? Colors.grey.shade300
                  : statusColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (الجزء العلوي من البطاقة يبقى كما هو)
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.light_sky_blue,
                  child: Text(
                    student.firstName.isNotEmpty
                        ? student.firstName.substring(0, 1)
                        : 'S',
                    style: GoogleFonts.tajawal(
                      color: AppColors.steel_blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${student.firstName} ${student.lastName}',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.night_blue,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),

            // --- الجزء السفلي من البطاقة (الأزرار التفاعلية) ---
            _buildActions(context),
          ],
        ),
      ),
    );
  }

 // --- هذه هي الدالة التي تم إصلاحها بالكامل ---
  Widget _buildActions(BuildContext context) {
    final status = student.attendanceStatus;

    // دالة مساعدة لفتح شاشة المتابعة وانتظار النتيجة
    Future<void> _navigateToFollowUp(bool isEditing) async {
      // نحصل على البلوك من الـ context الحالي
      final halaqaBloc = context.read<HalaqaBloc>();
      final halaqaId = halaqaBloc.state.halaqa?.idhalaqa ?? 0;

      // ننتظر النتيجة من شاشة المتابعة
      final bool? didSaveChanges = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => StudentFollowUpScreen(
            studentId: student.id,
            groupId: halaqaId,
            studentName: '${student.firstName} ${student.lastName}',
            isEditing: isEditing, // نمرر القيمة الصحيحة
          ),
        ),
      );

      // إذا عادت النتيجة true، نطلب تحديث البيانات
      if (didSaveChanges == true) {
        halaqaBloc.add(FetchHalaqaData());
      }
    }

    return Column(
      children: [
        // --- صف أزرار الحضور (لا تغيير هنا) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildAttendanceButton(
              'حاضر',
              Icons.check_circle_outline,
              AppColors.teal_blue,
              status == AttendanceStatus.present,
              () => context.read<HalaqaBloc>().add(MarkStudentAttendance(
                studentId: student.id,
                newStatus: AttendanceStatus.present,
              )),
            ),
            buildAttendanceButton(
              'غائب',
              Icons.cancel_outlined,
              Colors.red.shade600,
              status == AttendanceStatus.absent,
              () => context.read<HalaqaBloc>().add(MarkStudentAttendance(
                studentId: student.id,
                newStatus: AttendanceStatus.absent,
              )),
            ),
          ],
        ),

        // --- صف أزرار المتابعة/التعديل/العرض (تم إصلاح المنطق بالكامل) ---
        if (status == AttendanceStatus.present)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // =================================================================
                // --- هذا هو المنطق الصحيح لعرض الأزرار ---
                // =================================================================
                if (student.hasTodayFollowUp)
                  // الحالة 1: الطالب لديه متابعة اليوم -> نعرض زر "تعديل"
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text('تعديل المتابعة'),
                      onPressed: () => _navigateToFollowUp(true), // isEditing: true
                    ),
                  )
                else
                  // الحالة 2: الطالب ليس لديه متابعة اليوم -> نعرض زر "بدء المتابعة"
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.checklist_rtl_rounded),
                      label: const Text('بدء المتابعة'),
                      onPressed: () => _navigateToFollowUp(false), // isEditing: false
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.steel_blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                
                const SizedBox(width: 8),

                // زر العرض يظهر دائماً إذا كان الطالب حاضراً
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StudentProfileScreen(
                          studentId: student.id,
                          studentName: '${student.firstName} ${student.lastName}',
                        ),
                      ),
                    );
                  },
                  child: const Text('عرض'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/teacher/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_model.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';

import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/notifications_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/profile_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/student_follow_up_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/student_profile_screen.dart';
import 'package:flutter_admain_center/features/teacher/widgets/halaqa_screen/build_attendance.dart';
import 'package:flutter_admain_center/features/teacher/widgets/halaqa_screen/get_border_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HalaqaScreen extends StatelessWidget {
  const HalaqaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: BlocListener<HalaqaBloc, HalaqaState>(
        listenWhen: (previous, current) => previous.isRefreshing != current.isRefreshing && !current.isRefreshing,
        listener: (context, state) {
          if (state.error == null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text('تم التحديث بنجاح'),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              );
          } else if (state.halaqa != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('فشل تحديث البيانات: ${state.error}'),
                  backgroundColor: Colors.orange.shade800,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 50.0, left: 16.0, right: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              );
          }
        },
        child: BlocBuilder<HalaqaBloc, HalaqaState>(
          builder: (context, state) {
            // بما أن MainScreen تعالج التحميل الأولي، هنا نفترض أن البيانات موجودة
            if (state.halaqa == null) {
              // هذه الحالة تظهر فقط إذا فشل التحميل الأولي في MainScreen
              // أو إذا لم يتم العثور على حلقة لهذا المستخدم
              return const Center(child: Text('لم يتم العثور على بيانات الحلقة.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HalaqaBloc>().add(FetchHalaqaData());
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
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
                    style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                  ),
                  const SizedBox(height: 8),
                  _buildStudentList(context, state.halaqa!.students, state.halaqa!.idhalaqa),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    elevation: 1,
    title: Text('حلقتي', style: GoogleFonts.tajawal(color: AppColors.night_blue, fontWeight: FontWeight.bold)),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: AppColors.steel_blue, size: 28),
        onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsScreen()));},
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          backgroundColor: AppColors.light_sky_blue,
          child: IconButton(
            icon: const Icon(Icons.person, color: AppColors.steel_blue),
            onPressed: () {
              // ====================  هنا هو الإصلاح الكامل والنهائي ====================
              // 1. احصل على نسخة البلوك الحالية من السياق
              // بما أن HalaqaScreen هي ابنة لـ MainScreen، فإنها يمكنها الوصول للبلوكات التي تم توفيرها هناك
              final profileBloc = context.read<ProfileBloc>();

              // 2. انتقل إلى الشاشة الجديدة مع توفير البلوك لها
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: profileBloc,
                    child: const ProfileScreen(), // الآن ProfileScreen ستجد البلوك الذي تحتاجه
                  ),
                ),
              );
              // =====================================================================
            },
          ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حلقة ${halaqa.namehalaqa}', style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.group_outlined, color: AppColors.teal_blue, size: 20),
              const SizedBox(width: 8),
              Text('${halaqa.countstudent} طالب', style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(BuildContext context, List<Student> students, int halaqaId) {
    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'لا يوجد طلاب في هذه الحلقة بعد. اضغط على زر + لإضافة طالب جديد.',
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) => StudentCard(student: students[index], halaqaId: halaqaId),
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;
  final int halaqaId;
  const StudentCard({super.key, required this.student, required this.halaqaId});

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
        side: BorderSide(color: status == AttendanceStatus.pending ? Colors.grey.shade300 : statusColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.light_sky_blue,
                  child: Text(
                    student.firstName.isNotEmpty ? student.firstName.substring(0, 1) : 'S',
                    style: GoogleFonts.tajawal(color: AppColors.steel_blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${student.firstName} ${student.lastName}',
                    style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final status = student.attendanceStatus;

    Future<void> navigateToFollowUp(bool isEditing) async {
      final didSaveChanges = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => StudentFollowUpScreen(
            studentId: student.id,
            groupId: halaqaId,
            studentName: '${student.firstName} ${student.lastName}',
            isEditing: isEditing,
          ),
        ),
      );

      if (didSaveChanges == true && context.mounted) {
        // ====================  هنا هو الإصلاح ====================
        // بدلاً من إعادة تحميل كل البيانات، نرسل حدثاً لتحديث الطالب فقط
        // ولكن الحل الأبسط والأكثر ضماناً هو إعادة التحميل الكامل
        context.read<HalaqaBloc>().add(FetchHalaqaData());
        // =======================================================
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildAttendanceButton('حاضر', Icons.check_circle_outline, AppColors.teal_blue, status == AttendanceStatus.present,
                () => context.read<HalaqaBloc>().add(MarkStudentAttendance(studentId: student.id, newStatus: AttendanceStatus.present))),
            buildAttendanceButton('غائب', Icons.cancel_outlined, Colors.red.shade600, status == AttendanceStatus.absent,
                () => context.read<HalaqaBloc>().add(MarkStudentAttendance(studentId: student.id, newStatus: AttendanceStatus.absent))),
          ],
        ),
        if (status == AttendanceStatus.present)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (student.hasTodayFollowUp)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text('تعديل المتابعة'),
                      onPressed: () => navigateToFollowUp(true),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.checklist_rtl_rounded),
                      label: const Text('بدء المتابعة'),
                      onPressed: () => navigateToFollowUp(false),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.steel_blue, foregroundColor: Colors.white),
                    ),
                  ),
                const SizedBox(width: 8),
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

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_diatls_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teacher_profile_bloc/teacher_profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ

class TeacherProfileScreen extends StatelessWidget {
  final String teacherName;
  const TeacherProfileScreen({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي: $teacherName'),
        backgroundColor: AppColors.steel_blue,
      ),
      body: BlocBuilder<TeacherProfileBloc, TeacherProfileState>(
        builder: (context, state) {
          if (state.status == TeacherProfileStatus.loading || state.status == TeacherProfileStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TeacherProfileStatus.failure) {
            return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
          }
          if (state.teacherDetails == null) {
            return const Center(child: Text('لا توجد بيانات لعرضها.'));
          }

          final teacher = state.teacherDetails!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(teacher),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'المعلومات الشخصية',
                icon: Icons.person_pin_rounded,
                children: [
                  _buildInfoRow('الاسم الكامل', teacher.fullName),
                  _buildInfoRow('اسم الأب', teacher.fatherName),
                  _buildInfoRow('اسم الأم', teacher.motherName),
                   _buildInfoRow('تاريخ الميلاد', _formatDate(teacher.birthDate)),
                   _buildInfoRow('الجنس', teacher.gender),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'معلومات التواصل',
                icon: Icons.contact_mail_rounded,
                children: [
                  _buildInfoRow('رقم الهاتف', teacher.phoneNumber),
                  _buildInfoRow('البريد الإلكتروني', teacher.email),
                 _buildInfoRow('العنوان', teacher.address),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'المعلومات الوظيفية',
                icon: Icons.work_history_rounded,
                children: [
                  _buildInfoRow('المستوى التعليمي', teacher.educationLevel),
                  _buildInfoRow('تاريخ بدء العمل', _formatDate(teacher.startDate)),
                  _buildInfoRow('رقم الوثيقة', teacher.documentNumber),
                  _buildInfoRow('عدد الأجزاء المحفوظة', teacher.memorizedParts.toString()),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // دالة لتنسيق التاريخ
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy', 'ar').format(date);
    } catch (e) {
      return dateString; // إرجاع النص الأصلي إذا فشل التحويل
    }
  }

  // ويدجت لعرض رأس الصفحة
  Widget _buildProfileHeader(TeacherDetailsModel teacher) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.steel_blue.withOpacity(0.2),
              child: const Icon(Icons.person, size: 60, color: AppColors.steel_blue),
            ),
            const SizedBox(height: 16),
            Text(
              teacher.fullName,
              style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              teacher.email,
              style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لعرض قسم من المعلومات
  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.steel_blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }

  // ويدجت لعرض سطر معلومة (عنوان وقيمة)
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.tajawal(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

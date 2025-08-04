// lib/features/teacher/view/halaqa_info_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class HalaqaInfoScreen extends StatelessWidget {
  const HalaqaInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: استخدم Bloc لجلب بيانات الحلقة من الـ API
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('بيانات الحلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(
            title: 'اسم الحلقة',
            content: 'حلقة الصحابي عمر بن الخطاب',
            icon: Icons.bookmark,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'المسجد',
            content: 'مسجد الفرقان',
            icon: Icons.mosque,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'عدد الطلاب المسجلين',
            content: '20 طالباً',
            icon: Icons.group,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'الأوقات',
            content: 'من الأحد إلى الخميس - بعد صلاة العصر',
            icon: Icons.access_time_filled,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'وصف الحلقة',
            content: 'حلقة متخصصة في حفظ ومراجعة جزء عم وتبارك مع أحكام التجويد الأساسية.',
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.steel_blue, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.night_blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

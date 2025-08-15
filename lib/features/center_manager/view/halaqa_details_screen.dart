import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HalaqaDetailsScreen extends StatelessWidget {
  const HalaqaDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      //  استخدام AppBar عادي لإظهار زر الرجوع تلقائياً
      appBar: AppBar(
        title: Text('تفاصيل الحلقة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<HalaqaDetailsBloc, HalaqaDetailsState>(
        builder: (context, state) {
          if (state.status == HalaqaDetailsStatus.loading || state.status == HalaqaDetailsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HalaqaDetailsStatus.failure || state.halaqa == null) {
            return Center(child: Text(state.errorMessage ?? 'فشل تحميل البيانات'));
          }

          final halaqa = state.halaqa!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Header جميل لعرض اسم الحلقة
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [AppColors.steel_blue, AppColors.teal_blue.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bookmark, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Text(halaqa.name, style: GoogleFonts.tajawal(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // عرض البيانات في بطاقات منفصلة
              _buildInfoCard(title: 'عدد الطلاب المسجلين', value: '${halaqa.studentCount} طالب', icon: Icons.groups_outlined, color: Colors.indigo),
              const SizedBox(height: 16),
              _buildInfoCard(title: 'المشرف المسؤول', value: halaqa.teacherName ?? 'غير محدد', icon: Icons.school_outlined, color: Colors.orange),
              const SizedBox(height: 16),
              _buildInfoCard(title: 'المسجد', value: halaqa.mosqueName ?? 'غير محدد', icon: Icons.mosque_outlined, color: Colors.teal),
              const SizedBox(height: 16),
              _buildInfoCard(title: 'وصف الحلقة', value: halaqa.description ?? 'لا يوجد وصف', icon: Icons.description_outlined, color: Colors.blueGrey),
            ],
          );
        },
      ),
    );
  }

  // ويدجت مساعدة لعرض بطاقات المعلومات بشكل أنيق
  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(value, style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

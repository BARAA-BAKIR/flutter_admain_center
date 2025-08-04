// lib/features/teacher/view/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
// سنحتاج مكتبة للرسوم البيانية، fl_chart هي خيار ممتاز
// flutter pub add fl_chart

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
      create: (context) => DashboardBloc(
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      ),
      child: Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('لوحة التحكم', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
       body: BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state.syncStatus == SyncStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('تمت مزامنة كل البيانات بنجاح!'),
                backgroundColor: Colors.green,
              ));
            }
            if (state.syncStatus == SyncStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('فشل المزامنة: ${state.syncError}'),
                backgroundColor: Colors.red,
                 behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
              ));
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSyncCard(), // *** أضفنا كرت المزامنة هنا ***
              const SizedBox(height: 16),

          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildSectionTitle('بحاجة لمتابعة ⚠️'),
          _buildNeedsAttentionCard(),
          const SizedBox(height: 16),
          _buildSectionTitle('أفضل الطلاب هذا الأسبوع 🏆'),
          _buildTopStudentsCard(),
          const SizedBox(height: 16),
          _buildSectionTitle('إحصائيات الحضور (آخر 30 يوم)'),
          _buildAttendanceChartCard(),
        ],
      ),
    )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.night_blue),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('الحضور اليوم', '18', Icons.check_circle, AppColors.teal_blue),
            _buildSummaryItem('الغياب اليوم', '2', Icons.cancel, Colors.red.shade600),
            _buildSummaryItem('تم تقييمهم', '15', Icons.fact_check, AppColors.golden_orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
        Text(title, style: GoogleFonts.tajawal(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildNeedsAttentionCard() {
    // بيانات وهمية
    final students = ['عبدالرحمن خالد', 'سليمان العتيبي'];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: students.map((name) => ListTile(
            leading: const Icon(Icons.person_pin, color: Colors.orange),
            title: Text(name, style: GoogleFonts.tajawal()),
            subtitle: Text('التقدير السابق: ضعيف', style: GoogleFonts.tajawal()),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTopStudentsCard() {
    // بيانات وهمية
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTopStudentItem('محمد الصالح', 1),
            _buildTopStudentItem('فهد الأحمد', 2),
            _buildTopStudentItem('ياسر المحمد', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStudentItem(String name, int rank) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.light_sky_blue,
          child: Text(rank.toString(), style: const TextStyle(fontSize: 24, color: AppColors.steel_blue, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(name, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAttendanceChartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          // TODO: هنا يتم وضع ويدجت الرسم البياني مثل PieChart من مكتبة fl_chart
          child: Center(child: Text('Pie Chart Here')),
        ),
      ),
    );
  }
   Widget _buildSyncCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppColors.dark_teal_blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              'مزامنة البيانات مع السيرفر',
              style: GoogleFonts.tajawal(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'اضغط هنا لترحيل كل البيانات المحفوظة محلياً إلى السيرفر.',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state.syncStatus == SyncStatus.syncing) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                return ElevatedButton.icon(
                  onPressed: () {
                    context.read<DashboardBloc>().add(SyncAllDataRequested());
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: Text('بدء الترحيل', style: GoogleFonts.tajawal()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.golden_orange,
                    foregroundColor: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

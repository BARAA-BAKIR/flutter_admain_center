
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/info_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'مركزي',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.light_sky_blue,
        elevation: 0,
        actions: [
        ],
      ),
      // BlocBuilder يعيد بناء الواجهة بناءً على كل تغيير في الحالة
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          print(
            "🎨 [UI] 8. Rebuilding UI with state: status=${state.status}, summary_is_null=${state.summary == null}, error=${state.errorMessage}",
          );
          // 1. التعامل مع حالة التحميل
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. التعامل مع حالة الفشل
          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'فشل تحميل البيانات: ${state.errorMessage ?? "خطأ غير معروف"}',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<DashboardBloc>().add(
                          FetchDashboardSummary(),
                        ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          // 3. التعامل مع حالة النجاح
          // الشرط الأهم هنا هو `state.summary != null`
          if (state.status == DashboardStatus.success &&
              state.summary != null) {
            final summary = state.summary!;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(FetchDashboardSummary());
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'أهلاً بك، مدير مركز  ${summary.name_center} ',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.night_blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InfoCard(
                        title: 'الطلاب',
                        value: summary.studentCount.toString(),
                        icon: Icons.groups_rounded,
                        color: Colors.blue,
                      ),
                      InfoCard(
                        title: 'الأساتذة',
                        value: summary.teacherCount.toString(),
                        icon: Icons.school_rounded,
                        color: Colors.orange,
                      ),
                      InfoCard(
                        title: 'الحلقات',
                        value: summary.halaqaCount.toString(),
                        icon: Icons.bookmark_rounded,
                        color: Colors.teal,
                      ),
                      InfoCard(
                        title: 'طلبات معلقة',
                        value: summary.pendingRequests.toString(),
                        icon: Icons.pending_actions_rounded,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildAttendanceChart(
                    present: summary.presentPercentage,
                    absent: summary.absentPercentage,
                  ),
                ],
              ),
            );
          }
          // 4. الحالة الافتراضية إذا لم يتحقق أي شرط (وهذا هو ما كان يحدث معك)
          // إذا كان status == success ولكن summary == null، ستظهر هذه الرسالة.
          return const Center(child: Text('لا توجد بيانات لعرضها.'));
        },
      ),
    );
  }

  Widget _buildAttendanceChart({
    required double present,
    required double absent,
  }) {
    // ... (الكود هنا سليم ولا يحتاج تعديل)
    final total = present + absent;
    if (total == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(child: Text('لا توجد بيانات حضور لعرضها')),
        ),
      );
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'ملخص الحضور اليومي',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: AppColors.teal_blue,
                      value: present,
                      title: '${present.toStringAsFixed(0)}%',
                      radius: 60,
                      titleStyle: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red.shade300,
                      value: absent,
                      title: '${absent.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

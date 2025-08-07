// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:fl_chart/fl_chart.dart'; // لاستخدام الرسوم البيانية

// // استيراد الويدجتات المشتركة التي سننشئها
// // import 'package:flutter_admain_center/shared/widgets/info_card.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text('لوحة التحكم', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.grey.shade100,
//         elevation: 0,
//         actions: [
//           // أيقونة الإشعارات مع شارة (Badge)
//           IconButton(
//             icon: Badge(
//               label: Text('3'), // مثال: عدد الإشعارات الجديدة
//               child: Icon(Icons.notifications_rounded, color: AppColors.night_blue),
//             ),
//             onPressed: () {
//               // الانتقال إلى شاشة طلبات التسجيل والموافقات
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           // رسالة الترحيب
//           Text(
//             'أهلاً بعودتك، مدير المركز!',
//             style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.night_blue),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'هذه هي نظرتك الشاملة على أداء مركزك اليوم.',
//             style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
//           ),
//           const SizedBox(height: 24),

//           // قسم الإحصائيات الرئيسية
//           GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: const [
//               // سنستخدم ويدجت InfoCard هنا
//               InfoCard(title: 'إجمالي الطلاب', value: '1,250', icon: Icons.group_rounded, color: Colors.blue),
//               InfoCard(title: 'الأساتذة النشطون', value: '45', icon: Icons.school_rounded, color: Colors.orange),
//               InfoCard(title: 'الحلقات المكتملة', value: '18', icon: Icons.check_circle_rounded, color: Colors.green),
//               InfoCard(title: 'متوسط الحضور', value: '92%', icon: Icons.trending_up_rounded, color: Colors.purple),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // قسم الرسم البياني
//           _buildProgressChartCard(),

//           const SizedBox(height: 24),

//           // قسم الوصول السريع
//           _buildQuickActions(),
//         ],
//       ),
//     );
//   }

//   // ويدجت خاصة لعرض الرسم البياني داخل بطاقة
//   Widget _buildProgressChartCard() {
//     return Card(
//       elevation: 4,
//       shadowColor: Colors.black.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'تقدم الطلاب في الحفظ (آخر 7 أيام)',
//               style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 150,
//               // استخدام مكتبة fl_chart لإنشاء رسم بياني خطي جذاب
//               child: LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: false),
//                   titlesData: const FlTitlesData(show: false),
//                   borderData: FlBorderData(show: false),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: const [
//                         FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5),
//                         FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 6.5),
//                       ],
//                       isCurved: true,
//                       color: AppColors.teal_blue,
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                       dotData: const FlDotData(show: false),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         color: AppColors.teal_blue.withOpacity(0.2),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ويدجت خاصة لعرض أزرار الإجراءات السريعة
//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'إجراءات سريعة',
//           style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildActionChip(label: 'إضافة طالب', icon: Icons.person_add_alt_1_rounded, onTap: () {}),
//             _buildActionChip(label: 'إضافة أستاذ', icon: Icons.group_add_rounded, onTap: () {}),
//             _buildActionChip(label: 'إنشاء حلقة', icon: Icons.add_circle_outline_rounded, onTap: () {}),
//           ],
//         ),
//       ],
//     );
//   }

//   // ويدجت مساعدة لتصميم أزرار الإجراءات
//   Widget _buildActionChip({required String label, required IconData icon, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: AppColors.steel_blue, size: 28),
//             const SizedBox(height: 8),
//             Text(label, style: GoogleFonts.tajawal()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ويدجت مشتركة لعرض بطاقات الإحصائيات (يمكن وضعها في ملف منفصل)
// class InfoCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const InfoCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shadowColor: Colors.black.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: color.withOpacity(0.1),
//               child: Icon(icon, color: color),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   title,
//                   style: GoogleFonts.tajawal(color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
        title: Text('مركزي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading || state.status == DashboardStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == DashboardStatus.failure) {
            return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
          }
          if (state.status == DashboardStatus.success && state.summary != null) {
            final summary = state.summary!;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(FetchDashboardSummary());
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text('أهلاً بك، مدير المركز', style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InfoCard(title: 'الطلاب', value: summary.studentCount.toString(), icon: Icons.groups_rounded, color: Colors.blue),
                      InfoCard(title: 'الأساتذة', value: summary.teacherCount.toString(), icon: Icons.school_rounded, color: Colors.orange),
                      InfoCard(title: 'الحلقات', value: summary.halaqaCount.toString(), icon: Icons.bookmark_rounded, color: Colors.teal),
                      InfoCard(title: 'طلبات معلقة', value: summary.pendingRequests.toString(), icon: Icons.pending_actions_rounded, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildAttendanceChart(
                    present: summary.presentPercentage,
                    absent: summary.absentPercentage,
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('لا توجد بيانات لعرضها.'));
        },
      ),
    );
  }

  Widget _buildAttendanceChart({required double present, required double absent}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ملخص الحضور اليومي', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      titleStyle: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.red.shade300,
                      value: absent,
                      title: '${absent.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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

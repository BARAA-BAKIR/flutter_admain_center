import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/info_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart'; // سنستخدمها بكثرة هنا
// استيراد الويدجت المشتركة

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('اللوحة الرئيسية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // رسالة ترحيب
          Text(
            'نظرة شاملة على جميع المراكز',
            style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.night_blue),
          ),
          const SizedBox(height: 24),

          // إحصائيات على مستوى النظام كله
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              InfoCard(title: 'إجمالي المراكز', value: '12', icon: Icons.business_rounded, color: Colors.teal),
              InfoCard(title: 'إجمالي الطلاب', value: '15,430', icon: Icons.groups_2_rounded, color: Colors.blue),
              InfoCard(title: 'إجمالي الأساتذة', value: '550', icon: Icons.account_balance_rounded, color: Colors.orange),
              InfoCard(title: 'طلبات معلقة', value: '4', icon: Icons.pending_actions_rounded, color: Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // قسم مقارنة أداء المراكز (الأهم)
          _buildCentersPerformanceChart(),

          const SizedBox(height: 24),

          // قسم المراكز الأكثر نشاطاً
          _buildTopPerformingCenters(),
        ],
      ),
    );
  }

  // ويدجت لعرض الرسم البياني لمقارنة المراكز
  Widget _buildCentersPerformanceChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مقارنة عدد الطلاب بين المراكز',
              style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              // استخدام رسم بياني شريطي (Bar Chart) للمقارنة
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          // أسماء المراكز
                          const style = TextStyle(fontSize: 10);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'مركز الشمال'; break;
                            case 1: text = 'مركز الجنوب'; break;
                            case 2: text = 'مركز الشرق'; break;
                            case 3: text = 'مركز الغرب'; break;
                            default: text = ''; break;
                          }
                          return SideTitleWidget(meta: meta, space: 4,
                          child: Text(text, style: style));
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) => const FlLine(color: Colors.black12, strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    // بيانات كل مركز
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1200, color: Colors.blue, width: 15)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 950, color: Colors.orange, width: 15)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1500, color: Colors.teal, width: 15)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1100, color: Colors.purple, width: 15)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لعرض قائمة بالمراكز الأفضل أداءً
  Widget _buildTopPerformingCenters() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المراكز الأكثر نشاطاً',
              style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue),
            ),
            const SizedBox(height: 8),
            // استخدام ListTile لعرض كل مركز
            _buildCenterTile('مركز الشرق', 'المدير: أ. خالد الأحمد', '1500 طالب'),
            const Divider(),
            _buildCenterTile('مركز الشمال', 'المدير: أ. سارة العلي', '1200 طالب'),
            const Divider(),
            _buildCenterTile('مركز الغرب', 'المدير: أ. عبدالله المحمد', '1100 طالب'),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterTile(String centerName, String managerName, String studentCount) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.business_rounded)),
      title: Text(centerName, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      subtitle: Text(managerName),
      trailing: Text(studentCount, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: AppColors.teal_blue)),
      onTap: () { /* TODO: Navigate to center details screen */ },
    );
  }
}

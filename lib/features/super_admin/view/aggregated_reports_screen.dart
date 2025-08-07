import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/report_option_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class AggregatedReportsScreen extends StatelessWidget {
  const AggregatedReportsScreen({super.key});

  void _showAggregatedReportOptions(BuildContext context, String reportType) {
    // TODO: Show a detailed filter screen where the Super Admin can select:
    // 1. Date range.
    // 2. Specific centers to include (or all centers).
    // 3. Other relevant filters.
    // Then generate the report.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('جاري إنشاء تقرير مجمع: $reportType...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('التقارير المجمعة', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'تقارير على مستوى جميع المراكز',
              style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue),
            ),
            const SizedBox(height: 8),
            Text(
              'قارن الأداء وقم بتصدير بيانات شاملة للنظام بأكمله.',
              style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),

            // استخدام نفس الويدجت المشترك
            ReportOptionCard(
              title: 'تقرير مقارنة المراكز',
              description: 'مقارنة أعداد الطلاب، الحلقات، والتقدم بين المراكز.',
              icon: Icons.compare_arrows_rounded,
              onTap: () => _showAggregatedReportOptions(context, 'مقارنة المراكز'),
            ),
            ReportOptionCard(
              title: 'تقرير الطلاب الشامل',
              description: 'تصدير قائمة بجميع الطلاب في النظام مع فلاتر متقدمة.',
              icon: Icons.people_alt_rounded,
              onTap: () => _showAggregatedReportOptions(context, 'الطلاب الشامل'),
            ),
            ReportOptionCard(
              title: 'تقرير الحضور الشامل',
              description: 'نسب الحضور والغياب على مستوى جميع المراكز.',
              icon: Icons.event_note_rounded,
              onTap: () => _showAggregatedReportOptions(context, 'الحضور الشامل'),
            ),
          ],
        ),
      ),
    );
  }
}

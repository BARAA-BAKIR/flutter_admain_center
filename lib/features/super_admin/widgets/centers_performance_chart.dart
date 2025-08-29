import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CentersPerformanceChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  const CentersPerformanceChart({super.key, required this.chartData});
  @override
  Widget build(BuildContext context) {
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
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (chartData.isEmpty)
              const Center(
                child: Text('لا توجد بيانات كافية لعرض الرسم البياني.'),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: (chartData.length * 60.0) + 50,
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            // ✅ ---  التصحيح النهائي هنا ---
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final index = value.toInt();
                              if (index >= chartData.length) {
                                return const SizedBox.shrink();
                              }

                              // الطريقة الصحيحة الآن هي تمرير 'meta' بالكامل
                              return SideTitleWidget(
                                meta: meta, // تمرير الكائن meta
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    chartData[index]['center_name'] ?? '',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine:
                            (value) => const FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                            ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(chartData.length, (index) {
                        final item = chartData[index];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  (item['student_count'] as int? ?? 0)
                                      .toDouble(),
                              color:
                                  Colors.green[index %
                                      Colors.primaries.length],
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_student/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// --- الويدجت الرئيسية (لا تغيير هنا) ---
class StudentProfileScreen extends StatelessWidget {
  final int studentId;
  final String studentName;
  const StudentProfileScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProfileBloc(
            teacherRepository: RepositoryProvider.of<TeacherRepository>(
              context,
            ),
          )..add(FetchProfileData(studentId)),
      child: StudentProfileView(studentName: studentName),
    );
  }
}

// --- ويدجت الواجهة الفعلية (تم إكمالها) ---
class StudentProfileView extends StatelessWidget {
  final String studentName;
  const StudentProfileView({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ملف الطالب: $studentName',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.steel_blue,
          foregroundColor: Colors.white,
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                // نعرض زر PDF فقط إذا نجح تحميل البيانات
                if (state.status == ProfileStatus.success &&
                    state.profile != null) {
                  return IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () => _createPdf(context, state.profile!),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.light_sky_blue,
            labelColor: AppColors.light_sky_blue,
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                icon: Icon(Icons.person, color: AppColors.light_sky_blue),
                text: 'الشخصية',
              ),
              Tab(
                icon: Icon(Icons.trending_up, color: AppColors.light_sky_blue),
                text: 'الأداء',
              ),
              Tab(
                icon: Icon(Icons.assignment, color: AppColors.light_sky_blue),
                text: 'الواجبات',
              ),
              Tab(
                icon: Icon(
                  Icons.event_available,
                  color: AppColors.light_sky_blue,
                ),
                text: 'الحضور',
              ),
            ],
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading ||
                state.status == ProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProfileStatus.failure ||
                state.profile == null) {
              return Center(
                child: Text(
                  'فشل تحميل البيانات: تاكد من اتصالك بالإنترنت أو إعادة المحاولة لاحقاً.',
                ),
              );
            }

            final profile = state.profile!;
            return TabBarView(
              children: [
                _buildPersonalInfoTab(profile.studentDetails),
                _buildPerformanceTab(profile.trackings, profile.stats),
                _buildDutiesTab(profile.duty),
                _buildAttendanceTab(profile.stats, profile.trackings),
              ],
            );
          },
        ),
      ),
    );
  }

  // =================================================================
  // --- بناء كل تاب على حدة (تم إكمالها بالكامل) ---
  // =================================================================

  Widget _buildPersonalInfoTab(studentProfile student) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'الاسم الكامل',
          '${student.firstName} ${student.lastName}',
        ),
        _buildInfoCard('اسم الأب', student.fatherName),
        _buildInfoCard('اسم الأم', student.motherName),
        _buildInfoCard('تاريخ الميلاد', student.birthDate),
        _buildInfoCard('الجنس', student.gender),
        _buildInfoCard('رقم الهاتف', student.phone),
        _buildInfoCard('الحالة الاجتماعية', student.social_status),
        _buildInfoCard('المستوى التعليمي', student.educationaLevel),
        _buildInfoCard('الحالة الصحية', student.healthStatus),
      ],
    );
  }

  Widget _buildPerformanceTab(
    List<DailyFollowUpModel> trackings,
    ProfileStats stats,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'إحصائيات هذا الشهر',
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'متوسط الحفظ',
                stats.monthlyMemorizationAvg.toStringAsFixed(1) + ' / 5',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'متوسط المراجعة',
                stats.monthlyReviewAvg.toStringAsFixed(1) + ' / 5',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'أداء الحفظ والمراجعة خلال الشهر',
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
        const SizedBox(height: 16),
        if (trackings.isEmpty)
          const Center(child: Text('لا توجد بيانات أداء لهذا الشهر لعرضها.'))
        else
          SizedBox(
            height: 250,
            child: LineChart(_buildLineChartData(trackings)),
          ),
      ],
    );
  }

  Widget _buildDutiesTab(DutyModel? duty) {
    if (duty == null) {
      return const Center(child: Text('لا يوجد واجب محدد حالياً.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard('الواجب من صفحة', duty.startPage.toString()),
        _buildInfoCard('الواجب إلى صفحة', duty.endPage.toString()),
        _buildInfoCard(
          'الأجزاء المطلوبة',
          duty.requiredParts.isEmpty ? 'غير محدد' : duty.requiredParts,
        ),
        _buildInfoCard(
          'آخر تحديث للواجب',
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab(
    ProfileStats stats,
    List<DailyFollowUpModel> trackings,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'إحصائيات الحضور لهذا الشهر',
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
        const SizedBox(height: 16),
        if (stats.presentCount == 0 && stats.absentCount == 0)
          const Center(child: Text('لا توجد سجلات حضور لهذا الشهر.'))
        else
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green.shade500,
                    value: stats.presentCount.toDouble(),
                    title: '${stats.presentCount}',
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red.shade500,
                    value: stats.absentCount.toDouble(),
                    title: '${stats.absentCount}',
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                centerSpaceRadius: 40,
              ),
            ),
          ),
        const SizedBox(height: 24),
        _buildLegendItem(Colors.green.shade500, 'أيام الحضور'),
        _buildLegendItem(Colors.red.shade500, 'أيام الغياب'),
        const Divider(height: 32),
        Text(
          'سجل الحضور التفصيلي',
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
        ...trackings
            .map(
              (record) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(
                    (record.attendance == true)
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        (record.attendance == true) ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    DateFormat(
                      'EEEE, yyyy-MM-dd',
                      'ar',
                    ).format(DateTime.parse(record.date)),
                  ),
                  trailing: Text(
                    (record.attendance == true) ? 'حاضر' : 'غائب',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  // =================================================================
  // --- دوال مساعدة (تم إكمالها) ---
  // =================================================================

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.tajawal(color: Colors.grey.shade600),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(width: 16, height: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.tajawal()),
        ],
      ),
    );
  }

  // --- دالة بناء الرسم البياني الخطي (تمت تعبئتها) ---
  LineChartData _buildLineChartData(List<DailyFollowUpModel> trackings) {
    final spotsMemorization =
        trackings.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.memorizationScore.toDouble(),
          );
        }).toList();

    final spotsReview =
        trackings.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.reviewScore.toDouble(),
          );
        }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine:
            (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 0.5),
      ),
      titlesData: FlTitlesData(
        // ... (يمكنك تخصيص العناوين هنا لعرض التواريخ)
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade400),
      ),
      minX: 0,
      maxX: (trackings.length - 1).toDouble(),
      minY: 0,
      maxY: 5, // أعلى تقييم هو 5
      lineBarsData: [
        LineChartBarData(
          spots: spotsMemorization,
          isCurved: true,
          color: AppColors.teal_blue,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.teal_blue.withOpacity(0.3),
          ),
        ),
        LineChartBarData(
          spots: spotsReview,
          isCurved: true,
          color: AppColors.golden_orange,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.golden_orange.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  // =================================================================
  // --- دالة PDF النهائية (تم إكمالها بالكامل) ---
  // =================================================================
  Future<void> _createPdf(
    BuildContext context,
    StudentProfileModel profile,
  ) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.tajawalRegular();
    final boldFont = await PdfGoogleFonts.tajawalBold();

    // دالة مساعدة لإنشاء صف في جدول
    pw.TableRow _buildTableRow(String title, String value) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(value, style: pw.TextStyle(font: font)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(title, style: pw.TextStyle(font: boldFont)),
          ),
        ],
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        header:
            (context) => pw.Header(
              level: 0,
              child: pw.Text(
                'تقرير أداء الطالب: ${profile.studentDetails.firstName} ${profile.studentDetails.lastName}',
                style: pw.TextStyle(font: boldFont, fontSize: 24),
              ),
            ),
        build:
            (pw.Context pdfContext) => [
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Text(
                  '1. المعلومات الشخصية',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(font: boldFont, fontSize: 18),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  _buildTableRow('اسم الأب', profile.studentDetails.fatherName),
                  _buildTableRow('اسم الأم', profile.studentDetails.motherName),
                  _buildTableRow(
                    'تاريخ الميلاد',
                    profile.studentDetails.birthDate,
                  ),
                  _buildTableRow('رقم الهاتف', profile.studentDetails.phone),
                  _buildTableRow('الجنس', profile.studentDetails.gender),
                  _buildTableRow(
                    'الحالة الاجتماعية',
                    profile.studentDetails.social_status,
                  ),
                  _buildTableRow(
                    'المستوى التعليمي',
                    profile.studentDetails.educationaLevel,
                  ),
                  _buildTableRow(
                    'الحالة الصحية',
                    profile.studentDetails.healthStatus,
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Text(
                  '2. إحصائيات هذا الشهر',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(font: boldFont, fontSize: 18),
                ),
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _buildTableRow(
                    'متوسط تقييم الحفظ',
                    '${profile.stats.monthlyMemorizationAvg.toStringAsFixed(1)} / 100',
                  ),
                  _buildTableRow(
                    'متوسط تقييم المراجعة',
                    '${profile.stats.monthlyReviewAvg.toStringAsFixed(1)} / 100',
                  ),
                  _buildTableRow(
                    'أيام الحضور',
                    profile.stats.presentCount.toString(),
                  ),
                  _buildTableRow(
                    'أيام الغياب',
                    profile.stats.absentCount.toString(),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Text(
                  '3. الواجب الحالي',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(font: boldFont, fontSize: 18),
                ),
              ),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  _buildTableRow(
                    'من صفحة',
                    profile.duty?.startPage.toString() ?? 'N/A',
                  ),
                  _buildTableRow(
                    'إلى صفحة',
                    profile.duty?.endPage.toString() ?? 'N/A',
                  ),
                  _buildTableRow(
                    'الأجزاء المطلوبة',
                    profile.duty?.requiredParts ?? 'N/A',
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Text(
                  '4. سجل الحضور',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(font: boldFont, fontSize: 18),
                ),
              ),

              if (profile.trackings.isEmpty)
                pw.Text(
                  'لا توجد سجلات حضور لهذا الشهر.',
                  style: pw.TextStyle(font: font, fontSize: 16),
                )
              else
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    for (var record in profile.trackings)
                      _buildTableRow(
                        DateFormat(
                          'EEEE, yyyy-MM-dd',
                          'ar',
                        ).format(DateTime.parse(record.date)),
                        (record.attendance == 1) ? 'حاضر' : 'غائب',
                      ),
                  ],
                ),
            ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}

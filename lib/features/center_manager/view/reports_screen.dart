// import 'dart:io';

// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/report_option_card.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// // import 'package:excel/excel.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'dart:io';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {

//   // دالة مثال لإنشاء ومشاركة ملف Excel
//   Future<void> _generateAndShareExcelReport() async {
//     // 1. إنشاء ملف Excel
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['بيانات الطلاب'];

//     // 2. إضافة العناوين (Headers)
//     List<String> headers = ["الرقم", "اسم الطالب", "اسم الحلقة", "آخر تقييم"];
//     sheetObject.appendRow(headers.cast<CellValue?>());

//     // 3. إضافة بيانات وهمية (سيتم استبدالها ببيانات من الـ API)
//     for (int i = 1; i <= 50; i++) {
//       sheetObject.appendRow([i as CellValue?, "الطالب رقم $i" as CellValue?, "حلقة الصحابة" as CellValue?, "ممتاز" as CellValue?]);
//     }

//     // 4. حفظ الملف مؤقتاً على الجهاز
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx';

//     // حفظ بيانات Excel كبايتات
//     final fileBytes = excel.save();
//     if (fileBytes != null) {
//       File(filePath)
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes);

//       // 5. مشاركة الملف باستخدام share_plus
//       final xfile = XFile(filePath);
//       // ignore: deprecated_member_use
//       await Share.shareXFiles([xfile], text: 'تقرير الطلاب');
//     }
//   }

//   // دالة لعرض خيارات التقرير المحدد
//   void _showReportOptions(String reportType) {
//     // هنا يمكنك فتح شاشة جديدة أو BottomSheet لتحديد الفلاتر (التاريخ، الحلقة، ...)
//     // ثم استدعاء دالة الإنشاء والتصدير
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('جاري إنشاء تقرير: $reportType...')),
//     );
//     // كمثال، سنقوم بإنشاء تقرير الطلاب مباشرة
//     if (reportType == 'بيانات الطلاب') {
//       _generateAndShareExcelReport();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text('التقارير', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.grey.shade100,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text(
//               'اختر نوع التقرير المطلوب',
//               style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.night_blue),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'يمكنك تخصيص كل تقرير وتصديره كملف Excel.',
//               style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
//             ),
//             const SizedBox(height: 24),

//             // استخدام الويدجت المخصص لعرض خيارات التقارير
//             ReportOptionCard(
//               title: 'تقرير بيانات الطلاب',
//               description: 'قائمة كاملة ببيانات الطلاب وحلقاتهم.',
//               icon: Icons.description_rounded,
//               onTap: () => _showReportOptions('بيانات الطلاب'),
//             ),
//             ReportOptionCard(
//               title: 'تقرير الحضور والغياب',
//               description: 'سجل الحضور والغياب خلال فترة محددة.',
//               icon: Icons.event_available_rounded,
//               onTap: () => _showReportOptions('الحضور والغياب'),
//             ),
//             ReportOptionCard(
//               title: 'تقرير تقدم الحفظ',
//               description: 'متابعة أداء الطلاب في الحفظ والمراجعة.',
//               icon: Icons.trending_up_rounded,
//               onTap: () => _showReportOptions('تقدم الحفظ'),
//             ),
//             ReportOptionCard(
//               title: 'تقرير أداء الأساتذة',
//               description: 'تقييم أداء الأساتذة ونسب إنجاز حلقاتهم.',
//               icon: Icons.assessment_rounded,
//               onTap: () => _showReportOptions('أداء الأساتذة'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/report_option_card.dart';
import 'package:flutter_admain_center/features/center_manager/widgets/report_filter_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. استيراد الملفات اللازمة للربط
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/reports_bloc/reports_bloc.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. توفير البلوك للشاشة باستخدام BlocProvider
    //    هذا يضمن أن الشاشة وجميع مكوناتها الفرعية يمكنها الوصول إلى ReportsBloc.
    return BlocProvider(
      create:
          (context) => ReportsBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          ),
      // 3.
      // استخدام BlocListener للاستماع إلى التغيرات في الحالة وعرض رسائل للمستخدم
      //    هذا لا يعيد بناء الواجهة، بل يقوم بتنفيذ إجراءات مثل عرض SnackBar.
      child: BlocListener<ReportsBloc, ReportsState>(
        listener: (context, state) {
          final message = state.message;
          if (message != null &&
              state.status != ReportGenerationStatus.loading) {
            // إظهار رسالة فقط عند النجاح أو الفشل، وليس أثناء التحميل
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor:
                      state.status == ReportGenerationStatus.failure
                          ? Colors.redAccent
                          : Colors.green,
                ),
              );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'التقارير',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            // 4. استخدام BlocBuilder لإعادة بناء الواجهة بناءً على الحالة
            //    هذا يسمح لنا بعرض مؤشر التحميل عندما تكون العملية قيد التنفيذ.
            child: BlocBuilder<ReportsBloc, ReportsState>(
              builder: (context, state) {
                // إذا كان التطبيق يقوم بإنشاء تقرير، أظهر واجهة التحميل
                if (state.status == ReportGenerationStatus.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          state.message ??
                              'جاري إنشاء التقرير...', // عرض الرسالة الديناميكية من البلوك
                          style: GoogleFonts.tajawal(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                // في الحالات الأخرى (initial, success, failure)، اعرض الخيارات
                return ListView(
                  children: [
                    Text(
                      'اختر نوع التقرير المطلوب',
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.night_blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ReportOptionCard(
                      title: 'تقرير بيانات الطلاب',
                      description: 'قائمة كاملة ببيانات الطلاب وحلقاتهم.',
                      icon: Icons.description_rounded,
                      onTap: () {
                        // 5. إرسال الحدث إلى البلوك لبدء عملية إنشاء التقرير
                        //    الواجهة الآن لا تعرف شيئاً عن كيفية إنشاء التقرير، هي فقط ترسل أمراً.
                        context.read<ReportsBloc>().add(
                          GenerateStudentsReport(),
                        );
                      },
                    ),
                    // يمكنك إضافة المزيد من خيارات التقارير هنا بنفس الطريقة
                    ReportOptionCard(
                      title: 'تقرير الحضور والغياب',
                      description: 'سجل الحضور والغياب خلال فترة محددة.',
                      icon: Icons.event_available_rounded,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => ReportFilterDialog(
                                needsDateRange: true,
                                needsHalaqa: true,
                                onApply: (startDate, endDate, halaqaId) {
                                  // ====================  هنا هو الإصلاح ====================
                                  if (startDate != null && endDate != null) {
                                    context.read<ReportsBloc>().add(
                                      GenerateAttendanceReport(
                                        startDate:
                                            startDate, // الآن هي DateTime وليست DateTime?
                                        endDate:
                                            endDate, // الآن هي DateTime وليست DateTime?
                                        halaqaId: halaqaId,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'الرجاء تحديد نطاق التاريخ أولاً',
                                        ),
                                      ),
                                    );
                                  }
                                  // =======================================================
                                },
                              ),
                        );
                      },
                    ),
                    ReportOptionCard(
                      title: 'تقرير الحضور والغياب',
                      description: 'سجل الحضور والغياب خلال فترة محددة.',
                      icon: Icons.event_available_rounded,
                      onTap: () {},
                    ),
                    ReportOptionCard(
                      title: 'تقرير تقدم الحفظ',
                      description: 'متابعة أداء الطلاب في الحفظ والمراجعة.',
                      icon: Icons.trending_up_rounded,
                      onTap: () {},
                    ),
                    ReportOptionCard(
                      title: 'تقرير أداء الأساتذة',
                      description: 'تقييم أداء الأساتذة ونسب إنجاز حلقاتهم.',
                      icon: Icons.assessment_rounded,
                      onTap: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

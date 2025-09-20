// // // // In features/super_admin/view/aggregated_reports_screen.dart

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_admain_center/core/constants/app_colors.dart';
// // // import 'package:flutter_admain_center/core/services/report_exporter.dart';
// // // import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// // // import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
// // // import 'package:flutter_admain_center/features/super_admin/widgets/report_data_table.dart';
// // // import 'package:flutter_admain_center/features/super_admin/widgets/report_filter_dialog.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:google_fonts/google_fonts.dart';

// // // class AggregatedReportsScreen extends StatelessWidget {
// // //   const AggregatedReportsScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // We provide the BLoC here, at the top of the screen's widget tree.
// // //     return BlocProvider(
// // //       create:
// // //           (context) => ReportsBloc(
// // //             superAdminRepository: context.read<SuperAdminRepository>(),
// // //           )..add(LoadReportFilters()), // Load centers list for the filter
// // //       child: const AggregatedReportsView(),
// // //     );
// // //   }
// // // }

// // // class AggregatedReportsView extends StatelessWidget {
// // //   const AggregatedReportsView({super.key});

// // //   // A helper function to show the filter dialog
// // //   void _showFilterDialog(BuildContext context, String reportType) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (_) {
// // //         // We need to provide the existing BLoC to the dialog
// // //         return BlocProvider.value(
// // //           value: BlocProvider.of<ReportsBloc>(context),
// // //           child: ReportFilterDialog(
// // //             reportType: reportType,
// // //             onApply: (filters) {
// // //               // Dispatch the correct event based on the report type
// // //               if (reportType == 'students') {
// // //                 context.read<ReportsBloc>().add(
// // //                   GenerateStudentReport(
// // //                     startDate: filters['startDate'],
// // //                     endDate: filters['endDate'],
// // //                   ),
// // //                 );
// // //               } else if (reportType == 'attendance') {
// // //                 context.read<ReportsBloc>().add(
// // //                   GenerateAttendanceReport(
// // //                     startDate: filters['startDate']!, // Required for attendance
// // //                     endDate: filters['endDate']!, // Required for attendance
// // //                     centerId: filters['centerId'],
// // //                   ),
// // //                 );
// // //               } else if (reportType == 'teachers') {
// // //                 context.read<ReportsBloc>().add(GenerateTeacherReport());
// // //               }
// // //             },
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocBuilder<ReportsBloc, ReportsState>(
// // //       builder: (context, state) {
// // //         return Scaffold(
// // //           backgroundColor: Colors.grey.shade100,
// // //           appBar: AppBar(
// // //             title: Text(
// // //               'التقارير المجمعة',
// // //               style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// // //             ),
// // //             backgroundColor: Colors.grey.shade100,
// // //             elevation: 0,
// // //             centerTitle: true,
// // //           ),
// // //           floatingActionButton:
// // //               (state.status == ReportStatus.success &&
// // //                       state.reportData.isNotEmpty)
// // //                   ? FloatingActionButton.extended(
// // //                     onPressed: () {
// // //                       // Call the export function with the current data
// // //                       exportToExcel(
// // //                         context,
// // //                         data: state.reportData,
// // //                         reportName:
// // //                             'SuperAdmin_Report', // You can make this dynamic
// // //                       );
// // //                     },
// // //                     label: const Text('تصدير إلى Excel'),
// // //                     icon: const Icon(Icons.download_for_offline_outlined),
// // //                     backgroundColor: Colors.green.shade700,
// // //                   )
// // //                   : null,
// // //           body: Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   'إنشاء تقرير شامل',
// // //                   style: GoogleFonts.tajawal(
// // //                     fontSize: 22,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: AppColors.night_blue,
// // //                   ),
// // //                 ),
// // //                 Text(
// // //                   'اختر نوع التقرير، قم بتطبيق الفلاتر، ثم قم بتصدير النتائج.',
// // //                   style: GoogleFonts.tajawal(
// // //                     fontSize: 15,
// // //                     color: Colors.grey.shade700,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //                 // Report selection buttons
// // //                 SingleChildScrollView(
// // //                   scrollDirection:Axis.horizontal,
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                     children: [
// // //                       _buildReportTypeChip(
// // //                         context,
// // //                         'بيانات الطلاب',
// // //                         Icons.people_alt_outlined,
// // //                         'students',
// // //                       ),
// // //                       _buildReportTypeChip(
// // //                         context,
// // //                         'سجل الحضور',
// // //                         Icons.event_note_outlined,
// // //                         'attendance',
// // //                       ),
// // //                       _buildReportTypeChip(
// // //                         context,
// // //                         'بيانات الأساتذة',
// // //                         Icons.school_outlined,
// // //                         'teachers',
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const Divider(height: 30, thickness: 1),
// // //                 // The area to display the results
// // //                 Expanded(
// // //                   child: BlocBuilder<ReportsBloc, ReportsState>(
// // //                     builder: (context, state) {
// // //                       if (state.status == ReportStatus.loading) {
// // //                         return Center(
// // //                           child: Column(
// // //                             mainAxisAlignment: MainAxisAlignment.center,
// // //                             children: [
// // //                               const CircularProgressIndicator(),
// // //                               const SizedBox(height: 16),
// // //                               Text(
// // //                                 state.loadingMessage ?? 'جاري التحميل...',
// // //                                 style: GoogleFonts.tajawal(),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         );
// // //                       }
// // //                       if (state.status == ReportStatus.failure) {
// // //                         return Center(
// // //                           child: Text(
// // //                             'حدث خطأ: ${state.errorMessage}',
// // //                             style: GoogleFonts.tajawal(color: Colors.red),
// // //                           ),
// // //                         );
// // //                       }
// // //                       if (state.status == ReportStatus.success &&
// // //                           state.reportData.isNotEmpty) {
// // //                         // Display the data table with the results
// // //                         return ReportDataTable(data: state.reportData);
// // //                       }
// // //                       // Initial state or success with no data
// // //                       return Center(
// // //                         child: Column(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             Icon(
// // //                               Icons.summarize_outlined,
// // //                               size: 80,
// // //                               color: Colors.grey.shade400,
// // //                             ),
// // //                             const SizedBox(height: 16),
// // //                             Text(
// // //                               'لم يتم إنشاء أي تقرير بعد',
// // //                               style: GoogleFonts.tajawal(
// // //                                 fontSize: 18,
// // //                                 color: Colors.grey.shade600,
// // //                               ),
// // //                             ),
// // //                             Text(
// // //                               'اختر أحد الأنواع في الأعلى لبدء إنشاء تقريرك',
// // //                               textAlign: TextAlign.center,
// // //                               style: GoogleFonts.tajawal(
// // //                                 color: Colors.grey.shade500,
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget _buildReportTypeChip(
// // //     BuildContext context,
// // //     String label,
// // //     IconData icon,
// // //     String reportType,
// // //   ) {
// // //     return ActionChip(
// // //       avatar: Icon(icon, color: AppColors.steel_blue),
// // //       label: Text(
// // //         label,
// // //         style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
// // //       ),
// // //       onPressed: () => _showFilterDialog(context, reportType),
// // //       backgroundColor: Colors.white,
// // //       elevation: 2,
// // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(20),
// // //         side: BorderSide(color: Colors.grey.shade300),
// // //       ),
// // //     );
// // //   }
// // // }
// // // In features/super_admin/view/aggregated_reports_screen.dart

// // import 'package:flutter/material.dart';
// // import 'package:flutter_admain_center/core/constants/app_colors.dart';
// // import 'package:flutter_admain_center/core/services/report_exporter.dart';
// // import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// // import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
// // import 'package:flutter_admain_center/features/super_admin/widgets/report_data_table.dart';
// // import 'package:flutter_admain_center/features/super_admin/widgets/report_filter_dialog.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class AggregatedReportsScreen extends StatelessWidget {
// //   const AggregatedReportsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create:
// //           (context) => ReportsBloc(
// //             superAdminRepository: context.read<SuperAdminRepository>(),
// //           )..add(LoadReportFilters()), // جلب بيانات الفلاتر عند فتح الشاشة
// //       child: const AggregatedReportsView(),
// //     );
// //   }
// // }

// // class AggregatedReportsView extends StatelessWidget {
// //   const AggregatedReportsView({super.key});

// //   void _showFilterDialog(BuildContext context, String reportType) {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         return BlocProvider.value(
// //           value: BlocProvider.of<ReportsBloc>(context),
// //           child: ReportFilterDialog(
// //             reportType: reportType,
// //             onApply: (filters) {
// //               final startDate = filters['startDate'] as DateTime?;
// //               final endDate = filters['endDate'] as DateTime?;

// //               if (reportType == 'teacher_productivity') {
// //                 if (startDate != null && endDate != null) {
// //                   // ✅ التحقق هنا
// //                   context.read<ReportsBloc>().add(
// //                     GenerateTeacherProductivityReport(
// //                       startDate: startDate,
// //                       endDate: endDate,
// //                       centerId: filters['centerId'],
// //                     ),
// //                   );
// //                 }
// //               } else if (reportType == 'general_attendance') {
// //                 if (startDate != null && endDate != null) {
// //                   // ✅ التحقق هنا
// //                   context.read<ReportsBloc>().add(
// //                     GenerateGeneralAttendanceReport(
// //                       startDate: startDate,
// //                       endDate: endDate,
// //                       centerId: filters['centerId'],
// //                     ),
// //                   );
// //                 }
// //               } else if (reportType == 'students_performance') {
// //                 context.read<ReportsBloc>().add(
// //                   GenerateComprehensiveStudentReport(
// //                     startDate: startDate,
// //                     endDate: endDate,
// //                     centerId: filters['centerId'],
// //                     // halaqaId: filters['halaqaId'],
// //                   ),
// //                 );
// //               }
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<ReportsBloc, ReportsState>(
// //       builder: (context, state) {
// //         return Scaffold(
// //           backgroundColor: Colors.grey.shade100,
// //           appBar: AppBar(
// //             title: Text(
// //               'التقارير المجمعة',
// //               style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //             ),
// //             backgroundColor: Colors.grey.shade100,
// //             elevation: 0,
// //             centerTitle: true,
// //           ),
// //           floatingActionButton:
// //               (state.status == ReportStatus.success &&
// //                       state.reportData.isNotEmpty)
// //                   ? FloatingActionButton.extended(
// //                     onPressed: () {
// //                       // خاصية التصدير تعمل مع العنوان العربي الديناميكي
// //                       exportToExcel(
// //                         context,
// //                         data: state.reportData,
// //                         reportName: state.reportTitle ?? 'تقرير',
// //                       );
// //                     },
// //                     label: const Text('تصدير إلى Excel'),
// //                     icon: const Icon(Icons.download_for_offline_outlined),
// //                     backgroundColor: Colors.green.shade700,
// //                   )
// //                   : null,
// //           body: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'إنشاء تقرير شامل',
// //                   style: GoogleFonts.tajawal(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold,
// //                     color: AppColors.night_blue,
// //                   ),
// //                 ),
// //                 Text(
// //                   'اختر نوع التقرير، قم بتطبيق الفلاتر، ثم قم بتصدير النتائج.',
// //                   style: GoogleFonts.tajawal(
// //                     fontSize: 15,
// //                     color: Colors.grey.shade700,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 SingleChildScrollView(
// //                   scrollDirection: Axis.horizontal,
// //                   child: Row(
// //                     children: [
// //                       _buildReportTypeChip(
// //                         context,
// //                         'أداء الطلاب',
// //                         Icons.people_alt_outlined,
// //                         'students_performance',
// //                       ),
// //                       const SizedBox(width: 10),
// //                       _buildReportTypeChip(
// //                         context,
// //                         'إنجاز الأساتذة',
// //                         Icons.school_outlined,
// //                         'teacher_productivity',
// //                       ),
// //                       const SizedBox(width: 10),
// //                       _buildReportTypeChip(
// //                         context,
// //                         'الحضور العام',
// //                         Icons.event_note_outlined,
// //                         'general_attendance',
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const Divider(height: 30, thickness: 1),
// //                 Expanded(
// //                   child: BlocBuilder<ReportsBloc, ReportsState>(
// //                     builder: (context, state) {
// //                       if (state.status == ReportStatus.loading) {
// //                         return Center(
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               const CircularProgressIndicator(),
// //                               const SizedBox(height: 16),
// //                               Text(
// //                                 state.loadingMessage ?? 'جاري التحميل...',
// //                                 style: GoogleFonts.tajawal(),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }
// //                       if (state.status == ReportStatus.failure) {
// //                         return Center(
// //                           child: Text(
// //                             'حدث خطأ: ${state.errorMessage}',
// //                             style: GoogleFonts.tajawal(color: Colors.red),
// //                           ),
// //                         );
// //                       }
// //                       if (state.status == ReportStatus.success &&
// //                           state.reportData.isNotEmpty) {
// //                         return Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Padding(
// //                               padding: const EdgeInsets.only(bottom: 12.0),
// //                               child: Text(
// //                                 state.reportTitle ?? 'نتائج التقرير',
// //                                 style: GoogleFonts.tajawal(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: AppColors.night_blue,
// //                                 ),
// //                               ),
// //                             ),
// //                             Expanded(
// //                               child: ReportDataTable(data: state.reportData),
// //                             ),
// //                           ],
// //                         );
// //                       }
// //                       return Center(
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(
// //                               Icons.summarize_outlined,
// //                               size: 80,
// //                               color: Colors.grey.shade400,
// //                             ),
// //                             const SizedBox(height: 16),
// //                             Text(
// //                               'لم يتم إنشاء أي تقرير بعد',
// //                               style: GoogleFonts.tajawal(
// //                                 fontSize: 18,
// //                                 color: Colors.grey.shade600,
// //                               ),
// //                             ),
// //                             Text(
// //                               'اختر أحد الأنواع في الأعلى لبدء إنشاء تقريرك',
// //                               textAlign: TextAlign.center,
// //                               style: GoogleFonts.tajawal(
// //                                 color: Colors.grey.shade500,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildReportTypeChip(
// //     BuildContext context,
// //     String label,
// //     IconData icon,
// //     String reportType,
// //   ) {
// //     return ActionChip(
// //       avatar: Icon(icon, color: AppColors.steel_blue),
// //       label: Text(
// //         label,
// //         style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
// //       ),
// //       onPressed: () => _showFilterDialog(context, reportType),
// //       backgroundColor: Colors.white,
// //       elevation: 2,
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //         side: BorderSide(color: Colors.grey.shade300),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AggregatedReportsScreen extends StatefulWidget {
//   const AggregatedReportsScreen({super.key});

//   @override
//   State<AggregatedReportsScreen> createState() => _AggregatedReportsScreenState();
// }

// class _AggregatedReportsScreenState extends State<AggregatedReportsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // تحميل البيانات الأساسية (المراكز والحلقات) عند بدء الشاشة
//     context.read<ReportsBloc>().add(LoadCentersAndHalaqas());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'التقارير المجمعة',
//           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue[600],
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocConsumer<ReportsBloc, ReportsState>(
//           listener: (context, state) {
//             if (state is ReportsError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     state.message,
//                     style: GoogleFonts.tajawal(),
//                   ),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             } else if (state is ReportsSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'تم إنشاء التقرير بنجاح',
//                     style: GoogleFonts.tajawal(),
//                   ),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ✅ عنوان القسم
//                 Text(
//                   'اختر نوع التقرير المطلوب:',
//                   style: GoogleFonts.tajawal(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // ✅ شبكة التقارير المتاحة
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 1.2,
//                     children: [
//                       // تقرير أداء الطلاب الشامل
//                       _buildReportCard(
//                         title: 'تقرير أداء الطلاب الشامل',
//                         description: 'تقرير شامل عن أداء الطلاب مع إحصائيات الحفظ والمراجعة والحضور',
//                         icon: Icons.school,
//                         color: Colors.blue,
//                         reportType: 'students_performance',
//                         isLoading: state is ReportsLoading && state.reportType == 'students_performance',
//                       ),

//                       // تقرير إنجاز الأساتذة
//                       _buildReportCard(
//                         title: 'تقرير إنجاز الأساتذة',
//                         description: 'تقرير عن إنجاز وأداء الأساتذة في المراكز والحلقات',
//                         icon: Icons.person,
//                         color: Colors.green,
//                         reportType: 'teacher_productivity',
//                         isLoading: state is ReportsLoading && state.reportType == 'teacher_productivity',
//                       ),

//                       // تقرير الحضور العام
//                       _buildReportCard(
//                         title: 'تقرير الحضور العام',
//                         description: 'تقرير شامل عن حضور الطلاب في المراكز والحلقات',
//                         icon: Icons.event_available,
//                         color: Colors.orange,
//                         reportType: 'general_attendance',
//                         isLoading: state is ReportsLoading && state.reportType == 'general_attendance',
//                       ),

//                       // ✅ التقرير الجديد: حضور والتزام الأساتذة
//                       _buildReportCard(
//                         title: 'تقرير حضور والتزام الأساتذة',
//                         description: 'تقرير مفصل عن حضور والتزام الأساتذة بأيام العمل المحددة',
//                         icon: Icons.assignment_ind,
//                         color: Colors.purple,
//                         reportType: 'teacher_attendance',
//                         isLoading: state is ReportsLoading && state.reportType == 'teacher_attendance',
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ✅ معلومات إضافية
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'ملاحظات هامة:',
//                         style: GoogleFonts.tajawal(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         '• جميع التقارير تدعم الفلترة حسب المركز\n'
//                         '• بعض التقارير تتطلب تحديد فترة زمنية\n'
//                         '• يمكن تصدير التقارير بصيغة Excel\n'
//                         '• التقارير تعرض البيانات بأسماء عربية واضحة',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ✅ بناء بطاقة التقرير
//   Widget _buildReportCard({
//     required String title,
//     required String description,
//     required IconData icon,
//     required Color color,
//     required String reportType,
//     required bool isLoading,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: isLoading ? null : () => _showFilterDialog(context, reportType),
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 color.withOpacity(0.1),
//                 color.withOpacity(0.05),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // أيقونة التقرير
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: 32,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // عنوان التقرير
//               Text(
//                 title,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 8),

//               // وصف التقرير
//               Text(
//                 description,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 11,
//                   color: Colors.grey[600],
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 12),

//               // حالة التحميل أو زر العرض
//               if (isLoading)
//                 SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(color),
//                   ),
//                 )
//               else
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'عرض التقرير',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ✅ عرض مربع حوار الفلترة
//   void _showFilterDialog(BuildContext context, String reportType) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return BlocProvider.value(
//           value: BlocProvider.of<ReportsBloc>(context),
//           child: ReportFilterDialog(
//             reportType: reportType,
//             onApply: (filters) {
//               // استخراج المتغيرات من الخريطة
//               final startDate = filters['startDate'] as DateTime?;
//               final endDate = filters['endDate'] as DateTime?;
//               final centerId = filters['centerId'] as int?;
//               final halaqaId = filters['halaqaId'] as int?;

//               // إرسال الحدث المناسب بناءً على نوع التقرير
//               switch (reportType) {
//                 case 'students_performance':
//                   context.read<ReportsBloc>().add(
//                         GenerateComprehensiveStudentReport(
//                           startDate: startDate,
//                           endDate: endDate,
//                           centerId: centerId,
//                           halaqaId: halaqaId,
//                         ),
//                       );
//                   break;

//                 case 'teacher_productivity':
//                   if (startDate != null && endDate != null) {
//                     context.read<ReportsBloc>().add(
//                           GenerateTeacherProductivityReport(
//                             startDate: startDate,
//                             endDate: endDate,
//                             centerId: centerId,
//                           ),
//                         );
//                   } else {
//                     _showErrorMessage('الرجاء تحديد تاريخ البداية والنهاية لهذا التقرير.');
//                   }
//                   break;

//                 case 'general_attendance':
//                   if (startDate != null && endDate != null) {
//                     context.read<ReportsBloc>().add(
//                           GenerateGeneralAttendanceReport(
//                             startDate: startDate,
//                             endDate: endDate,
//                             centerId: centerId,
//                           ),
//                         );
//                   } else {
//                     _showErrorMessage('الرجاء تحديد تاريخ البداية والنهاية لهذا التقرير.');
//                   }
//                   break;

//                 // ✅ التقرير الجديد
//                 case 'teacher_attendance':
//                   if (startDate != null && endDate != null) {
//                     context.read<ReportsBloc>().add(
//                           GenerateTeacherAttendanceReport(
//                             startDate: startDate,
//                             endDate: endDate,
//                             centerId: centerId,
//                             halaqaId: halaqaId,
//                           ),
//                         );
//                   } else {
//                     _showErrorMessage('الرجاء تحديد تاريخ البداية والنهاية لهذا التقرير.');
//                   }
//                   break;
//               }
//             },
//           ),
//         );
//       },
//     );
//   }

//   // ✅ عرض رسالة خطأ
//   void _showErrorMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: GoogleFonts.tajawal(),
//         ),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

// في ملف aggregated_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/services/report_exporter.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/report_data_table.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/report_filter_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AggregatedReportsScreen extends StatelessWidget {
  const AggregatedReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsBloc(
        superAdminRepository: context.read<SuperAdminRepository>(),
      )..add(LoadReportFilters()),
      child: const AggregatedReportsView(),
    );
  }
}

class AggregatedReportsView extends StatelessWidget {
  const AggregatedReportsView({super.key});

  void _showFilterDialog(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<ReportsBloc>(context),
          child: ReportFilterDialog(
            reportType: reportType,
            onApply: (filters) {
              final startDate = filters['startDate'] as DateTime?;
              final endDate = filters['endDate'] as DateTime?;
              final centerId = filters['centerId'] as int?;

              switch (reportType) {
                case 'students_performance':
                  context.read<ReportsBloc>().add(
                    GenerateComprehensiveStudentReport(
                      startDate: startDate,
                      endDate: endDate,
                      centerId: centerId,
                    ),
                  );
                  break;

                case 'teacher_productivity':
                  if (startDate != null && endDate != null) {
                    context.read<ReportsBloc>().add(
                      GenerateTeacherProductivityReport(
                        startDate: startDate,
                        endDate: endDate,
                        centerId: centerId,
                      ),
                    );
                  } else {
                    _showErrorMessage(context, 'الرجاء تحديد تاريخ البداية والنهاية لهذا التقرير.');
                  }
                  break;

                case 'general_attendance':
                  if (startDate != null && endDate != null) {
                    context.read<ReportsBloc>().add(
                      GenerateGeneralAttendanceReport(
                        startDate: startDate,
                        endDate: endDate,
                        centerId: centerId,
                      ),
                    );
                  } else {
                    _showErrorMessage(context, 'الرجاء تحديد تاريخ البداية والنهاية لهذا التقرير.');
                  }
                  break;
              }
            },
          ),
        );
      },
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.tajawal()),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'التقارير المجمعة',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
            centerTitle: true,
          ),
          floatingActionButton: (state.status == ReportStatus.success && state.reportData.isNotEmpty)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    exportToExcel(
                      context,
                      data: state.reportData,
                      reportName: state.reportTitle ?? 'تقرير',
                    );
                  },
                  label: const Text('تصدير إلى Excel'),
                  icon: const Icon(Icons.download_for_offline_outlined),
                  backgroundColor: Colors.green.shade700,
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إنشاء تقرير شامل',
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.night_blue,
                  ),
                ),
                Text(
                  'اختر نوع التقرير، قم بتطبيق الفلاتر، ثم قم بتصدير النتائج.',
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                
                // أزرار اختيار التقارير
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildReportTypeChip(
                        context,
                        'تقرير أداء الطلاب',
                        Icons.people_alt_outlined,
                        'students_performance',
                        state.status == ReportStatus.loading,
                      ),
                      _buildReportTypeChip(
                        context,
                        'تقرير إنجاز الأساتذة',
                        Icons.school_outlined,
                        'teacher_productivity',
                        state.status == ReportStatus.loading,
                      ),
                      _buildReportTypeChip(
                        context,
                        'تقرير الحضور العام',
                        Icons.event_note_outlined,
                        'general_attendance',
                        state.status == ReportStatus.loading,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                
                // منطقة عرض النتائج
                Expanded(
                  child: BlocBuilder<ReportsBloc, ReportsState>(
                    builder: (context, state) {
                      if (state.status == ReportStatus.loading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                state.loadingMessage ?? 'جاري التحميل...',
                                style: GoogleFonts.tajawal(),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (state.status == ReportStatus.failure) {
                        return Center(
                          child: Text(
                            'حدث خطأ: ${state.errorMessage}',
                            style: GoogleFonts.tajawal(color: Colors.red),
                          ),
                        );
                      }
                      
                      if (state.status == ReportStatus.success && state.reportData.isNotEmpty) {
                        return ReportDataTable(data: state.reportData);
                      }
                      
                      // الحالة الأولية أو نجاح بدون بيانات
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.summarize_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لم يتم إنشاء أي تقرير بعد',
                              style: GoogleFonts.tajawal(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'اختر أحد الأنواع في الأعلى لبدء إنشاء تقريرك',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportTypeChip(
    BuildContext context,
    String label,
    IconData icon,
    String reportType,
    bool isLoading,
  ) {
    return ActionChip(
      avatar: Icon(icon, color: AppColors.steel_blue),
      label: Text(
        label,
        style: GoogleFonts.tajawal(fontWeight: FontWeight.w600),
      ),
      onPressed: isLoading ? null : () => _showFilterDialog(context, reportType),
      backgroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}

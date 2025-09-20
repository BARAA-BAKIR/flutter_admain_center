// // // In: lib/features/super_admin/widgets/report_filter_dialog.dart

// // import 'package:flutter/material.dart';
// // import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart';

// // class ReportFilterDialog extends StatefulWidget {
// //   final String reportType;
// //   final Function(Map<String, dynamic> filters) onApply;

// //   const ReportFilterDialog({
// //     super.key,
// //     required this.reportType,
// //     required this.onApply,
// //   });

// //   @override
// //   State<ReportFilterDialog> createState() => _ReportFilterDialogState();
// // }

// // class _ReportFilterDialogState extends State<ReportFilterDialog> {
// //   DateTime? _startDate;
// //   DateTime? _endDate;
// //   int? _selectedCenterId;

// //   @override
// //   Widget build(BuildContext context) {
// //     // --- ✅ 1. تصحيح الشروط لتطابق أسماء التقارير الفعلية ---
// //     bool needsDate = widget.reportType == 'teacher_productivity' || widget.reportType == 'general_attendance' || widget.reportType == 'students_performance';
// //     bool isDateOptional = widget.reportType == 'students_performance';
// //     bool needsCenter = true; // كل التقارير يمكن فلترتها حسب المركز

// //     return AlertDialog(
// //       title: Text('تخصيص التقرير', style: GoogleFonts.tajawal()),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (needsDate) ...[
// //               Text(
// //                 isDateOptional ? 'حدد نطاق التاريخ (اختياري)' : 'حدد نطاق التاريخ (مطلوب)',
// //                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 8),
// //               Row(
// //                 children: [
// //                   Expanded(child: _buildDatePicker(context, 'من تاريخ', _startDate, (date) => setState(() => _startDate = date))),
// //                   const SizedBox(width: 8),
// //                   Expanded(child: _buildDatePicker(context, 'إلى تاريخ', _endDate, (date) => setState(() => _endDate = date))),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //             ],
// //             if (needsCenter) ...[
// //               Text('فلترة حسب المركز (اختياري)', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
// //               const SizedBox(height: 8),
// //               BlocBuilder<ReportsBloc, ReportsState>(
// //                 builder: (context, state) {
// //                   return DropdownButtonFormField<int?>( // السماح بقيمة null
// //                     hint: const Text('كل المراكز'),
// //                     value: _selectedCenterId,
// //                     items: [
// //                       const DropdownMenuItem<int?>(
// //                         value: null,
// //                         child: Text('كل المراكز'),
// //                       ),
// //                       ...state.centers.map((center) {
// //                         return DropdownMenuItem<int>(value: center['id'], child: Text(center['name']));
// //                       }),
// //                     ],
// //                     onChanged: (value) => setState(() => _selectedCenterId = value),
// //                     decoration: const InputDecoration(border: OutlineInputBorder()),
// //                   );
// //                 },
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
// //         ElevatedButton(
// //           onPressed: () {
// //             // --- ✅ 2. استخدام المتغير isDateOptional للتحقق ---
// //             final bool isDateRequired = !isDateOptional;

// //             if (isDateRequired && (_startDate == null || _endDate == null)) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(
// //                   content: Text('الرجاء تحديد تاريخ البدء وتاريخ الانتهاء لهذا التقرير.'),
// //                   backgroundColor: Colors.red,
// //                 ),
// //               );
// //               return;
// //             }

// //             widget.onApply({
// //               'startDate': _startDate,
// //               'endDate': _endDate,
// //               'centerId': _selectedCenterId,
// //             });
// //             Navigator.of(context).pop();
// //           },
// //           child: const Text('عرض التقرير'), // تغيير النص ليكون أكثر وضوحاً
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDatePicker(BuildContext context, String label, DateTime? date, Function(DateTime) onDateSelected) {
// //     return ElevatedButton.icon(
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black87,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           side: BorderSide(color: Colors.grey.shade400),
// //         ),
// //         elevation: 0,
// //       ),
// //       icon: const Icon(Icons.calendar_today_outlined, size: 18),
// //       label: Text(
// //         date == null ? label : DateFormat('yyyy-MM-dd').format(date),
// //         style: GoogleFonts.tajawal(fontSize: 12),
// //       ),
// //       onPressed: () async {
// //         final pickedDate = await showDatePicker(
// //           context: context,
// //           initialDate: DateTime.now(),
// //           firstDate: DateTime(2020),
// //           lastDate: DateTime.now(),
// //         );
// //         if (pickedDate != null) {
// //           onDateSelected(pickedDate);
// //         }
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class ReportFilterDialog extends StatefulWidget {
//   final String reportType;
//   final Function(Map<String, dynamic> filters) onApply;

//   const ReportFilterDialog({
//     super.key,
//     required this.reportType,
//     required this.onApply,
//   });

//   @override
//   State<ReportFilterDialog> createState() => _ReportFilterDialogState();
// }

// class _ReportFilterDialogState extends State<ReportFilterDialog> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   int? _selectedCenterId;
//   int? _selectedHalaqaId;

//   @override
//   Widget build(BuildContext context) {
//     // ✅ تحديد متطلبات كل نوع تقرير بناءً على الأنواع الجديدة
//     bool needsDate = _isDateRequired();
//     bool isDateOptional = _isDateOptional();
//     bool needsCenter = true; // كل التقارير يمكن فلترتها حسب المركز
//     bool needsHalaqa = _isHalaqaFilterAvailable();

//     return AlertDialog(
//       title: Text(_getReportTitle(), style: GoogleFonts.tajawal()),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ قسم التواريخ
//             if (needsDate) ...[
//               Text(
//                 isDateOptional ? 'حدد نطاق التاريخ (اختياري)' : 'حدد نطاق التاريخ (مطلوب)',
//                 style: GoogleFonts.tajawal(
//                   fontWeight: FontWeight.bold,
//                   color: isDateOptional ? Colors.grey[600] : Colors.red[700],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDatePicker(
//                       context,
//                       'من تاريخ',
//                       _startDate,
//                       (date) => setState(() => _startDate = date)
//                     )
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: _buildDatePicker(
//                       context,
//                       'إلى تاريخ',
//                       _endDate,
//                       (date) => setState(() => _endDate = date)
//                     )
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],

//             // ✅ قسم المركز
//             if (needsCenter) ...[
//               Text(
//                 'فلترة حسب المركز (اختياري)',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)
//               ),
//               const SizedBox(height: 8),
//               BlocBuilder<ReportsBloc, ReportsState>(
//                 builder: (context, state) {
//                   return DropdownButtonFormField<int?>(
//                     hint: const Text('كل المراكز'),
//                     value: _selectedCenterId,
//                     items: [
//                       const DropdownMenuItem<int?>(
//                         value: null,
//                         child: Text('كل المراكز'),
//                       ),
//                       ...state.centers.map((center) {
//                         return DropdownMenuItem<int>(
//                           value: center['id'],
//                           child: Text(center['name'])
//                         );
//                       }),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedCenterId = value;
//                         // إعادة تعيين الحلقة عند تغيير المركز
//                         _selectedHalaqaId = null;
//                       });
//                     },
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],

//             // ✅ قسم الحلقة (للتقارير التي تدعمها)
//             if (needsHalaqa) ...[
//               Text(
//                 'فلترة حسب الحلقة (اختياري)',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)
//               ),
//               const SizedBox(height: 8),
//               BlocBuilder<ReportsBloc, ReportsState>(
//                 builder: (context, state) {
//                   // فلترة الحلقات بناءً على المركز المحدد
//                   final filteredHalaqas = _selectedCenterId != null
//                       ? state.halaqas.where((halaqa) => halaqa['center_id'] == _selectedCenterId).toList()
//                       : state.halaqas;

//                   return DropdownButtonFormField<int?>(
//                     hint: const Text('كل الحلقات'),
//                     value: _selectedHalaqaId,
//                     items: [
//                       const DropdownMenuItem<int?>(
//                         value: null,
//                         child: Text('كل الحلقات'),
//                       ),
//                       ...filteredHalaqas.map((halaqa) {
//                         return DropdownMenuItem<int>(
//                           value: halaqa['id'],
//                           child: Text(halaqa['name'])
//                         );
//                       }),
//                     ],
//                     onChanged: (value) => setState(() => _selectedHalaqaId = value),
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],

//             // ✅ معلومات إضافية حول التقرير
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'معلومات التقرير:',
//                     style: GoogleFonts.tajawal(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _getReportDescription(),
//                     style: GoogleFonts.tajawal(
//                       fontSize: 12,
//                       color: Colors.blue[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text(
//             'إلغاء',
//             style: GoogleFonts.tajawal(),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // ✅ التحقق من صحة البيانات
//             if (_validateInputs()) {
//               widget.onApply({
//                 'startDate': _startDate,
//                 'endDate': _endDate,
//                 'centerId': _selectedCenterId,
//                 'halaqaId': _selectedHalaqaId,
//               });
//               Navigator.of(context).pop();
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue[600],
//             foregroundColor: Colors.white,
//           ),
//           child: Text(
//             'عرض التقرير',
//             style: GoogleFonts.tajawal(),
//           ),
//         ),
//       ],
//     );
//   }

//   // ✅ تحديد ما إذا كانت التواريخ مطلوبة
//   bool _isDateRequired() {
//     return [
//       'teacher_productivity',
//       'general_attendance',
//       'teacher_attendance', // التقرير الجديد
//     ].contains(widget.reportType);
//   }

//   // ✅ تحديد ما إذا كانت التواريخ اختيارية
//   bool _isDateOptional() {
//     return widget.reportType == 'students_performance';
//   }

//   // ✅ تحديد ما إذا كان فلتر الحلقة متاح
//   bool _isHalaqaFilterAvailable() {
//     return [
//       'students_performance',
//       'teacher_attendance', // التقرير الجديد يدعم فلترة الحلقة
//     ].contains(widget.reportType);
//   }

//   // ✅ الحصول على عنوان التقرير
//   String _getReportTitle() {
//     switch (widget.reportType) {
//       case 'students_performance':
//         return 'تخصيص تقرير أداء الطلاب الشامل';
//       case 'teacher_productivity':
//         return 'تخصيص تقرير إنجاز الأساتذة';
//       case 'general_attendance':
//         return 'تخصيص تقرير الحضور العام';
//       case 'teacher_attendance':
//         return 'تخصيص تقرير حضور والتزام الأساتذة';
//       default:
//         return 'تخصيص التقرير';
//     }
//   }

//   // ✅ الحصول على وصف التقرير
//   String _getReportDescription() {
//     switch (widget.reportType) {
//       case 'students_performance':
//         return 'يعرض أداء الطلاب الشامل مع إمكانية الفلترة حسب المركز والحلقة والفترة الزمنية.';
//       case 'teacher_productivity':
//         return 'يعرض إنجاز الأساتذة خلال فترة زمنية محددة مع إمكانية الفلترة حسب المركز.';
//       case 'general_attendance':
//         return 'يعرض حضور الطلاب خلال فترة زمنية محددة مع إمكانية الفلترة حسب المركز.';
//       case 'teacher_attendance':
//         return 'يعرض حضور والتزام الأساتذة بناءً على أيام العمل المحددة خلال فترة زمنية محددة.';
//       default:
//         return 'تقرير مخصص حسب الفلاتر المحددة.';
//     }
//   }

//   // ✅ التحقق من صحة المدخلات
//   bool _validateInputs() {
//     final bool isDateRequired = _isDateRequired() && !_isDateOptional();

//     if (isDateRequired && (_startDate == null || _endDate == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء لهذا التقرير.',
//             style: GoogleFonts.tajawal(),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'تاريخ البداية يجب أن يكون قبل تاريخ النهاية.',
//             style: GoogleFonts.tajawal(),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     return true;
//   }

//   // ✅ بناء منتقي التاريخ
//   Widget _buildDatePicker(
//     BuildContext context,
//     String label,
//     DateTime? date,
//     Function(DateTime) onDateSelected
//   ) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//           side: BorderSide(color: Colors.grey.shade400),
//         ),
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//       icon: const Icon(Icons.calendar_today_outlined, size: 18),
//       label: Text(
//         date == null ? label : DateFormat('yyyy-MM-dd').format(date),
//         style: GoogleFonts.tajawal(fontSize: 12),
//       ),
//       onPressed: () async {
//         final pickedDate = await showDatePicker(
//           context: context,
//           initialDate: date ?? DateTime.now(),
//           firstDate: DateTime(2020),
//           lastDate: DateTime.now().add(const Duration(days: 365)),
//           locale: const Locale('ar', 'SA'),
//         );
//         if (pickedDate != null) {
//           onDateSelected(pickedDate);
//         }
//       },
//     );
//   }
// }

// في ملف report_filter_dialog.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class ReportFilterDialog extends StatefulWidget {
//   final String reportType;
//   final Function(Map<String, dynamic> filters) onApply;

//   const ReportFilterDialog({
//     super.key,
//     required this.reportType,
//     required this.onApply,
//   });

//   @override
//   State<ReportFilterDialog> createState() => _ReportFilterDialogState();
// }

// class _ReportFilterDialogState extends State<ReportFilterDialog> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   int? _selectedCenterId;

//   @override
//   Widget build(BuildContext context) {
//     bool needsDate = _isDateRequired();
//     bool isDateOptional = _isDateOptional();
//     bool needsCenter = true;

//     return AlertDialog(
//       title: Text(_getReportTitle(), style: GoogleFonts.tajawal()),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (needsDate) ...[
//               Text(
//                 isDateOptional ? 'حدد نطاق التاريخ (اختياري)' : 'حدد نطاق التاريخ (مطلوب)',
//                 style: GoogleFonts.tajawal(
//                   fontWeight: FontWeight.bold,
//                   color: isDateOptional ? Colors.grey[600] : Colors.red[700],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDatePicker(
//                       context,
//                       'من تاريخ',
//                       _startDate,
//                       (date) => setState(() => _startDate = date)
//                     )
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: _buildDatePicker(
//                       context,
//                       'إلى تاريخ',
//                       _endDate,
//                       (date) => setState(() => _endDate = date)
//                     )
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],

//             if (needsCenter) ...[
//               Text(
//                 'فلترة حسب المركز (اختياري)',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)
//               ),
//               const SizedBox(height: 8),
//               BlocBuilder<ReportsBloc, ReportsState>(
//                 builder: (context, state) {
//                   return DropdownButtonFormField<int?>(
//                     hint: const Text('كل المراكز'),
//                     value: _selectedCenterId,
//                     items: [
//                       const DropdownMenuItem<int?>(
//                         value: null,
//                         child: Text('كل المراكز'),
//                       ),
//                       ...state.centers.map((center) {
//                         return DropdownMenuItem<int>(
//                           value: center['id'],
//                           child: Text(center['name'])
//                         );
//                       }),
//                     ],
//                     onChanged: (value) => setState(() => _selectedCenterId = value),
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],

//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'معلومات التقرير:',
//                     style: GoogleFonts.tajawal(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _getReportDescription(),
//                     style: GoogleFonts.tajawal(
//                       fontSize: 12,
//                       color: Colors.blue[700],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('إلغاء', style: GoogleFonts.tajawal()),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_validateInputs()) {
//               widget.onApply({
//                 'startDate': _startDate,
//                 'endDate': _endDate,
//                 'centerId': _selectedCenterId,
//               });
//               Navigator.of(context).pop();
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue[600],
//             foregroundColor: Colors.white,
//           ),
//           child: Text('عرض التقرير', style: GoogleFonts.tajawal()),
//         ),
//       ],
//     );
//   }

//   bool _isDateRequired() {
//     return ['teacher_productivity', 'general_attendance'].contains(widget.reportType);
//   }

//   bool _isDateOptional() {
//     return widget.reportType == 'students_performance';
//   }

//   String _getReportTitle() {
//     switch (widget.reportType) {
//       case 'students_performance':
//         return 'تخصيص تقرير أداء الطلاب الشامل';
//       case 'teacher_productivity':
//         return 'تخصيص تقرير إنجاز الأساتذة';
//       case 'general_attendance':
//         return 'تخصيص تقرير الحضور العام';
//       default:
//         return 'تخصيص التقرير';
//     }
//   }

//   String _getReportDescription() {
//     switch (widget.reportType) {
//       case 'students_performance':
//         return 'يعرض أداء الطلاب الشامل مع إمكانية الفلترة حسب المركز والفترة الزمنية.';
//       case 'teacher_productivity':
//         return 'يعرض إنجاز الأساتذة خلال فترة زمنية محددة مع إمكانية الفلترة حسب المركز.';
//       case 'general_attendance':
//         return 'يعرض حضور الطلاب خلال فترة زمنية محددة مع إمكانية الفلترة حسب المركز.';
//       default:
//         return 'تقرير مخصص حسب الفلاتر المحددة.';
//     }
//   }

//   bool _validateInputs() {
//     final bool isDateRequired = _isDateRequired() && !_isDateOptional();

//     if (isDateRequired && (_startDate == null || _endDate == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء لهذا التقرير.',
//             style: GoogleFonts.tajawal(),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'تاريخ البداية يجب أن يكون قبل تاريخ النهاية.',
//             style: GoogleFonts.tajawal(),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }

//     return true;
//   }

//   Widget _buildDatePicker(
//     BuildContext context,
//     String label,
//     DateTime? date,
//     Function(DateTime) onDateSelected
//   ) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//           side: BorderSide(color: Colors.grey.shade400),
//         ),
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//       icon: const Icon(Icons.calendar_today_outlined, size: 18),
//       label: Text(
//         date == null ? label : DateFormat('yyyy-MM-dd').format(date),
//         style: GoogleFonts.tajawal(fontSize: 12),
//       ),
//       onPressed: () async {
//         final pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2020),
//           lastDate: DateTime.now(),
//         );
//         if (pickedDate != null) {
//           onDateSelected(pickedDate);
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc/reports_bloc.dart';

class ReportFilterDialog extends StatefulWidget {
  final String reportType;
  final Function(Map<String, dynamic> filters) onApply;

  const ReportFilterDialog({
    super.key,
    required this.reportType,
    required this.onApply,
  });

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedCenterId;

  @override
  Widget build(BuildContext context) {
    bool isDateRequired = _isDateRequired();
    bool isDateOptional = _isDateOptional();
    bool showDateSection = isDateRequired || isDateOptional;

    return AlertDialog(
      title: Text(_getReportTitle(), style: GoogleFonts.tajawal()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم التواريخ
            if (showDateSection) ...[
              Text(
                isDateRequired
                    ? 'حدد نطاق التاريخ (مطلوب)'
                    : 'حدد نطاق التاريخ (اختياري)',
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: isDateRequired ? Colors.red[700] : Colors.blue[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      context,
                      'من تاريخ',
                      _startDate,
                      (date) => setState(() => _startDate = date),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDatePicker(
                      context,
                      'إلى تاريخ',
                      _endDate,
                      (date) => setState(() => _endDate = date),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // قسم المراكز
            Text(
              'فلترة حسب المركز (اختياري)',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ReportsBloc, ReportsState>(
              builder: (context, state) {
                return DropdownButtonFormField<int?>(
                  hint: const Text('كل المراكز'),
                  value: _selectedCenterId,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('كل المراكز'),
                    ),
                    ...state.centers.map((center) {
                      return DropdownMenuItem<int>(
                        value: center['id'],
                        child: Text(center['name']),
                      );
                    }),
                  ],
                  onChanged:
                      (value) => setState(() => _selectedCenterId = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // معلومات التقرير
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات التقرير:',
                    style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getReportDescription(),
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('إلغاء', style: GoogleFonts.tajawal()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateInputs()) {
              widget.onApply({
                'startDate': _startDate,
                'endDate': _endDate,
                'centerId': _selectedCenterId,
              });
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
          child: Text('عرض التقرير', style: GoogleFonts.tajawal()),
        ),
      ],
    );
  }

  bool _isDateRequired() {
    return widget.reportType == 'teacher_productivity' ||
        widget.reportType == 'general_attendance';
  }

  bool _isDateOptional() {
    return widget.reportType == 'students_performance';
  }

  String _getReportTitle() {
    switch (widget.reportType) {
      case 'students_performance':
        return 'تخصيص تقرير أداء الطلاب الشامل';
      case 'teacher_productivity':
        return 'تخصيص تقرير إنجاز الأساتذة';
      case 'general_attendance':
        return 'تخصيص تقرير الحضور العام';
      default:
        return 'تخصيص التقرير';
    }
  }

  String _getReportDescription() {
    switch (widget.reportType) {
      case 'students_performance':
        return 'يعرض أداء الطلاب الشامل. يمكن تحديد فترة زمنية لحساب الإحصائيات أو تركها فارغة لعرض كامل البيانات.';
      case 'teacher_productivity':
        return 'يعرض إنجاز الأساتذة خلال فترة زمنية محددة (مطلوبة). يشمل معلومات الالتزام والأداء.';
      case 'general_attendance':
        return 'يعرض حضور الطلاب خلال فترة زمنية محددة (مطلوبة). يشمل إحصائيات الحضور والغياب.';
      default:
        return 'تقرير مخصص حسب الفلاتر المحددة.';
    }
  }

  bool _validateInputs() {
    final bool isDateRequired = _isDateRequired();

    if (isDateRequired && (_startDate == null || _endDate == null)) {
      _showErrorMessage(context,
        'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء لهذا التقرير.',
      );
      return false;
    }

    if (_startDate != null &&
        _endDate != null &&
        _startDate!.isAfter(_endDate!)) {
      _showErrorMessage(context,'تاريخ البداية يجب أن يكون قبل تاريخ النهاية.');
      return false;
    }

    return true;
  }
 void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.tajawal()),
        backgroundColor: Colors.red,
      ),
    );
  }
  // void _showErrorMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message, style: GoogleFonts.tajawal()),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? date,
    Function(DateTime) onDateSelected,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: const Icon(Icons.calendar_today_outlined, size: 18),
      label: Text(
        date == null ? label : DateFormat('yyyy-MM-dd').format(date),
        style: GoogleFonts.tajawal(fontSize: 12),
      ),
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }

  // ===== تحديث aggregated_reports_screen.dart =====

  // في دالة _showFilterDialog، تأكد من التعامل مع التواريخ بشكل صحيح:

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
                  // تقرير الطلاب: التواريخ اختيارية
                  context.read<ReportsBloc>().add(
                    GenerateComprehensiveStudentReport(
                      startDate: startDate,
                      endDate: endDate,
                      centerId: centerId,
                    ),
                  );
                  break;

                case 'teacher_productivity':
                  // تقرير الأساتذة: التواريخ مطلوبة
                  if (startDate != null && endDate != null) {
                    context.read<ReportsBloc>().add(
                      GenerateTeacherProductivityReport(
                        startDate: startDate,
                        endDate: endDate,
                        centerId: centerId,
                      ),
                    );
                  } else {
                    _showErrorMessage(
                      context,
                      'الرجاء تحديد تاريخ البداية والنهاية لتقرير الأساتذة.',
                    );
                  }
                  break;

                case 'general_attendance':
                  // تقرير الحضور: التواريخ مطلوبة
                  if (startDate != null && endDate != null) {
                    context.read<ReportsBloc>().add(
                      GenerateGeneralAttendanceReport(
                        startDate: startDate,
                        endDate: endDate,
                        centerId: centerId,
                      ),
                    );
                  } else {
                    _showErrorMessage(
                      context,
                      'الرجاء تحديد تاريخ البداية والنهاية لتقرير الحضور.',
                    );
                  }
                  break;
              }
            },
          ),
        );
      },
    );
  }
}

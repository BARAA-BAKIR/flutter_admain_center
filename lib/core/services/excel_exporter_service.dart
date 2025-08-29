// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class ExcelExporterService {
//   Future<void> exportAndShare({
//     required List<Map<String, dynamic>> data,
//     required String fileName,
//     required String sheetName,
//   }) async {
//     if (data.isEmpty) {
//       throw Exception('لا توجد بيانات لتصديرها.');
//     }

//     // 1. إنشاء ملف Excel. سيحتوي على ورقة افتراضية "Sheet1".
//     final excel = Excel.createExcel();

//     // ==================== هنا هو الإصلاح الكامل ====================

//     // 2. إنشاء ورقة العمل الجديدة بالاسم المطلوب.
//     final Sheet sheetObject = excel[sheetName];

//     // 3. حذف ورقة العمل الافتراضية "Sheet1".
//     excel.delete('Sheet1');

//     // 4. جعل ورقتنا الجديدة هي ورقة العمل النشطة عند فتح الملف.
//     excel.setDefaultSheet(sheetName);

//     // 5. ضبط اتجاه ورقة العمل الجديدة من اليمين إلى اليسار.
//     sheetObject.isRTL = true;
//     // 6. إضافة العناوين مع عمود التسلسل "ت".
//     final List<String> arabicHeaders = data.first.keys.toList();
//     final finalHeaders = ['ت', ...arabicHeaders];
//     sheetObject.appendRow(
//       finalHeaders.map((key) => TextCellValue(key)).toList(),
//     );

//     // 7. إضافة البيانات مع الرقم التسلسلي.
//     for (int i = 0; i < data.length; i++) {
//       final rowData = data[i];
//       final rowValues =
//           arabicHeaders
//               .map((header) => TextCellValue(rowData[header]?.toString() ?? ''))
//               .toList();
//       final finalRow = [TextCellValue((i + 1).toString()), ...rowValues];
//       sheetObject.appendRow(finalRow);
//     }

//     // =============================================================

//     // حفظ ومشاركة الملف
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/$fileName.xlsx';
//     final fileBytes = excel.save();

//     if (fileBytes != null) {
//       final file =
//           File(filePath)
//             ..createSync(recursive: true)
//             ..writeAsBytesSync(fileBytes);

//       final xfile = XFile(file.path);
//       await Share.shareXFiles([xfile], text: 'تقرير $fileName');
//     }
//   }
// }
// // import 'dart:io';
// // import 'package:excel/excel.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:share_plus/share_plus.dart';

// // class ExcelExporter {
// //   Future<void> exportAndShare({
// //     required List<Map<String, dynamic>> data,
// //     required String fileName,
// //     required String sheetName,
// //     // ==================== هنا هي الإضافات الجديدة والمهمة ====================
// //     required List<String> headers, // <-- أسماء الأعمدة بالعربي
// //     required List<String> keys,     // <-- مفاتيح الحقول بالانجليزي
// //     // ====================================================================
// //   }) async {
// //     if (data.isEmpty) {
// //       throw Exception('لا توجد بيانات للتصدير.');
// //     }
// //     // التحقق من تطابق عدد الأعمدة والمفاتيح
// //     if (headers.length != keys.length) {
// //       throw Exception('عدد الأعمدة لا يتطابق مع عدد المفاتيح.');
// //     }

// //     final excel = Excel.createExcel();
// //     final Sheet sheetObject = excel[sheetName];

// //     // --- إعدادات اتجاه الورقة من اليمين لليسار ---
// //     excel.setDefaultSheet(sheetName);
// //     final sheet = excel.sheets[sheetName];
// //     if (sheet != null) {
// //       sheet.isRTL = true;
// //     }

// //     // 1. إضافة العناوين (Headers) بالعربي
// //     sheetObject.appendRow(headers.map((header) => TextCellValue(header)).toList());

// //     // 2. إضافة البيانات الحقيقية بناءً على المفاتيح (Keys)
// //     for (final rowData in data) {
// //       final row = keys.map((key) {
// //         // جلب القيمة بشكل آمن وتحويلها إلى نص
// //         final value = rowData[key]?.toString() ?? '';
// //         return TextCellValue(value);
// //       }).toList();
// //       sheetObject.appendRow(row);
// //     }

// //     // 3. حفظ ومشاركة الملف (الكود يبقى كما هو)
// //     final directory = await getTemporaryDirectory();
// //     final filePath = '${directory.path}/$fileName.xlsx';
// //     final fileBytes = excel.save();

// //     if (fileBytes != null) {
// //       File(filePath)
// //         ..createSync(recursive: true)
// //         ..writeAsBytesSync(fileBytes);
// //       final xfile = XFile(filePath);
// //       await Share.shareXFiles([xfile], text: 'تقرير $sheetName');
// //     }
// //   }
// // }
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelExporterService {
  Future<void> exportAndShare({
    required List<Map<String, dynamic>> data,
    required String fileName,
    required String sheetName,
    required List<String> headers, // <-- أسماء الأعمدة بالعربي
    required List<String> keys,     // <-- مفاتيح الحقول بالانجليزي
  }) async {
    if (data.isEmpty) {
      throw Exception('لا توجد بيانات للتصدير.');
    }
    if (headers.length != keys.length) {
      throw Exception('عدد الأعمدة لا يتطابق مع عدد المفاتيح.');
    }

    final excel = Excel.createExcel();
    final Sheet sheetObject = excel[sheetName];

    // --- إعدادات الورقة ---
    excel.delete('Sheet1');
    excel.setDefaultSheet(sheetName);
    sheetObject.isRTL = true;

    // 1. إضافة العناوين مع عمود التسلسل "ت"
    final finalHeaders = ['ت', ...headers];
    sheetObject.appendRow(
      finalHeaders.map((header) => TextCellValue(header)).toList()
    );

    // 2. إضافة البيانات مع الرقم التسلسلي
    for (int i = 0; i < data.length; i++) {
      final rowData = data[i];
      // بناء الصف بناءً على المفاتيح (keys)
      final rowValues = keys.map((key) {
        final value = rowData[key]?.toString() ?? '';
        return TextCellValue(value);
      }).toList();
      
      // إضافة الرقم التسلسلي في بداية الصف
      final finalRow = [TextCellValue((i + 1).toString()), ...rowValues];
      sheetObject.appendRow(finalRow);
    }

    // 3. حفظ ومشاركة الملف
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName.xlsx';
    final fileBytes = excel.save();

    if (fileBytes != null) {
      final file = File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      final xfile = XFile(file.path);
      // ignore: deprecated_member_use
      await Share.shareXFiles([xfile], text: 'تقرير $fileName');
    }
  }
}

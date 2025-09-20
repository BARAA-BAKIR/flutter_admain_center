
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

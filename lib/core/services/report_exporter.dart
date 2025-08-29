// You can create a new file like 'core/services/report_exporter.dart'
// Or add this function directly inside 'aggregated_reports_screen.dart'

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportToExcel(BuildContext context, {
  required List<Map<String, dynamic>> data,
  required String reportName,
}) async {
  if (data.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('لا توجد بيانات لتصديرها!')),
    );
    return;
  }

  // Show a loading indicator
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('جاري إنشاء ملف Excel...')),
  );

  try {
    // 1. Create a new Excel document
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[reportName]; // Sheet name

    // 2. Get headers from the keys of the first data map
    List<String> headers = data.first.keys.toList();
    sheetObject.appendRow(headers.map((header) => TextCellValue(header)).toList());

    // 3. Add data rows
    for (var rowData in data) {
      List<CellValue> row = headers.map((header) {
        return TextCellValue(rowData[header]?.toString() ?? '');
      }).toList();
      sheetObject.appendRow(row);
    }

    // 4. Get the temporary directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${reportName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    // 5. Save the file
    final fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // 6. Open the file
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Could not open the file: ${result.message}');
      }
    } else {
      throw Exception('Failed to save the Excel file.');
    }

  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل التصدير: ${e.toString()}'), backgroundColor: Colors.red),
    );
  }
}

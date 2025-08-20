// In features/super_admin/widgets/report_data_table.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ReportDataTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('لا توجد بيانات لعرضها.'));
    }

    // Get the columns from the keys of the first map entry
    final columns = data.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20.0,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.grey.shade200,
          ),
          columns:
              columns
                  .map(
                    (colName) => DataColumn(
                      label: Text(
                        colName,
                        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  .toList(),
          rows:
              data.map((rowData) {
                return DataRow(
                  cells:
                      columns.map((colName) {
                        return DataCell(
                          Text(rowData[colName]?.toString() ?? ''),
                        );
                      }).toList(),
                );
              }).toList(),
        ),
      ),
    );
  }
}

// In features/super_admin/widgets/report_filter_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/reports_bloc/reports_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    bool needsDate = widget.reportType == 'students' || widget.reportType == 'attendance';
    bool needsCenter = widget.reportType == 'attendance';

    return AlertDialog(
      title: Text('تخصيص التقرير', style: GoogleFonts.tajawal()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (needsDate) ...[
              Text('حدد نطاق التاريخ (اختياري للطلاب)', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDatePicker(context, 'من تاريخ', _startDate, (date) => setState(() => _startDate = date))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDatePicker(context, 'إلى تاريخ', _endDate, (date) => setState(() => _endDate = date))),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (needsCenter) ...[
              BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  return DropdownButtonFormField<int>(
                    hint: const Text('فلترة حسب المركز (اختياري)'),
                    value: _selectedCenterId,
                    items: state.centers.map((center) {
                      return DropdownMenuItem<int>(value: center['id'], child: Text(center['name']));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCenterId = value),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            widget.onApply({
              'startDate': _startDate,
              'endDate': _endDate,
              'centerId': _selectedCenterId,
            });
            Navigator.of(context).pop();
          },
          child: const Text('إنشاء التقرير'),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime? date, Function(DateTime) onDateSelected) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.calendar_today),
      label: Text(date == null ? label : DateFormat('yyyy-MM-dd').format(date)),
      onPressed: () async {
        final pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}

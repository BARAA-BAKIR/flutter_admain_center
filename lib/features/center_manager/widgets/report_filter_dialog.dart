import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportFilterDialog extends StatefulWidget {
  final bool needsDateRange;
  final bool needsHalaqa;
  final Function(DateTime? startDate, DateTime? endDate, int? halaqaId) onApply;

  const ReportFilterDialog({
    super.key,
    this.needsDateRange = false,
    this.needsHalaqa = false,
    required this.onApply,
  });

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedHalaqaId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تخصيص التقرير', style: GoogleFonts.tajawal()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.needsDateRange) ...[
              Text('اختر نطاق التاريخ', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                        if (date != null) setState(() => _startDate = date);
                      },
                      child: Text(_startDate == null ? 'من تاريخ' : DateFormat('yyyy-MM-dd').format(_startDate!)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                        if (date != null) setState(() => _endDate = date);
                      },
                      child: Text(_endDate == null ? 'إلى تاريخ' : DateFormat('yyyy-MM-dd').format(_endDate!)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (widget.needsHalaqa) ...[
              // TODO: استبدال هذا بـ DropdownButtonFormField حقيقي
              DropdownButtonFormField<int>(
                hint: const Text('اختر حلقة (اختياري)'),
                value: _selectedHalaqaId,
                items: const [DropdownMenuItem(value: 1, child: Text('حلقة الصحابة'))],
                onChanged: (value) => setState(() => _selectedHalaqaId = value),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_startDate, _endDate, _selectedHalaqaId);
            Navigator.of(context).pop();
          },
          child: const Text('إنشاء التقرير'),
        ),
      ],
    );
  }
}

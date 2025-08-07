import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ملاحظة: سنحتاج لجلب قائمة الحلقات من الـ API

class TransferStudentDialog extends StatefulWidget {
  final int studentId;
  final String studentName;
  const TransferStudentDialog({super.key, required this.studentId, required this.studentName});

  @override
  State<TransferStudentDialog> createState() => _TransferStudentDialogState();
}

class _TransferStudentDialogState extends State<TransferStudentDialog> {
  int? _selectedHalaqaId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('نقل الطالب: ${widget.studentName}', style: GoogleFonts.tajawal()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: استبدال هذا بـ DropdownButtonFormField حقيقي مع بيانات من الـ API
          DropdownButton<int>(
            hint: const Text('اختر الحلقة الجديدة'),
            value: _selectedHalaqaId,
            onChanged: (value) {
              setState(() {
                _selectedHalaqaId = value;
              });
            },
            items: const [
              // بيانات وهمية حالياً
              DropdownMenuItem(value: 1, child: Text('حلقة الصحابة')),
              DropdownMenuItem(value: 2, child: Text('حلقة الأنصار')),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _selectedHalaqaId == null ? null : () {
            // TODO: إرسال حدث النقل إلى البلوك
            Navigator.of(context).pop(true); // إرجاع true للدلالة على النجاح
          },
          child: const Text('نقل'),
        ),
      ],
    );
  }
}

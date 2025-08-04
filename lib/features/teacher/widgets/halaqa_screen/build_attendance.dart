// في ملف build_attendance.dart أو ما يماثله

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- هذا هو التعريف الأصلي والصحيح ---
Widget buildAttendanceButton(
  String label,
  IconData icon,
  Color color,
  bool isSelected,
  VoidCallback onPressed, // <-- تستقبل دالة عادية لا تعرف شيئاً عن الـ Bloc
) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        onPressed: onPressed, // <-- ببساطة تستدعي الدالة التي تم تمريرها
        icon: Icon(icon, size: 18),
        label: Text(label, style: GoogleFonts.tajawal()),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : color.withOpacity(0.1),
          foregroundColor: isSelected ? Colors.white : color,
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? color : Colors.transparent),
          ),
        ),
      ),
    ),
  );
}

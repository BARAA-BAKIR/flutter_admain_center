// دوال مساعدة لجلب اللون والنص بناءً على الحالة
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/data/models/student_model.dart';

Color getBorderColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return AppColors.teal_blue;
    case AttendanceStatus.absent:
      return Colors.red.shade600;
    // case AttendanceStatus.excused:
    //   return AppColors.golden_orange;
    default:
      return Colors.grey.shade300;
  }
}

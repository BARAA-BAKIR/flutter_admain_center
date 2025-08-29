// lib/data/models/student_progress_model.dart
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';

import 'student_progress_stage_model.dart';


class StudentProgress {
  final int id;
  final int studentId;
  final int? levelId;
  final int? groupId;
  final DateTime entryDate;
  final DateTime? graduationDate;
  final StudentProgressStage? stage;
  final Halaqa? halaqa;

  StudentProgress({
    required this.id,
    required this.studentId,
    this.levelId,
    this.groupId,
    required this.entryDate,
    this.graduationDate,
    this.stage,
    this.halaqa,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      id: json['id'],
      studentId: json['student_id'],
      levelId: json['level_id'],
      groupId: json['group_id'],
      entryDate: DateTime.parse(json['entry_date']),
      graduationDate: json['graduation_date'] != null 
          ? DateTime.parse(json['graduation_date']) 
          : null,
      stage: json['stage'] != null 
          ? StudentProgressStage.fromJson(json['stage']) 
          : null,
      halaqa: json['halaqa'] != null 
          ? Halaqa.fromJson(json['halaqa']) 
          : null,
    );
  }
}
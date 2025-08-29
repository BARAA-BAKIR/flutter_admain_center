// lib/data/models/parts_completed_model.dart';
import 'part_model.dart';

class PartsCompleted {
  final int id;
  final int studentId;
  final int partId;
  final Part part;
  final DateTime createdAt;

  PartsCompleted({
    required this.id,
    required this.studentId,
    required this.partId,
    required this.part,
    required this.createdAt,
  });

  factory PartsCompleted.fromJson(Map<String, dynamic> json) {
    return PartsCompleted(
      id: json['id'],
      studentId: json['student_id'],
      partId: json['part_id'],
      part: Part.fromJson(json['part']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
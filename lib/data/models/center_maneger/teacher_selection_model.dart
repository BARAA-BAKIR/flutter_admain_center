// lib/data/models/center_manager/teacher_selection_model.dart
import 'package:equatable/equatable.dart';

class TeacherSelectionModel extends Equatable {
  final int id;
  final String name;

  const TeacherSelectionModel({required this.id, required this.name});

  factory TeacherSelectionModel.fromJson(Map<String, dynamic> json) {
    return TeacherSelectionModel(
      id: json['id'],
      name: json['name'] ?? 'اسم غير محدد',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

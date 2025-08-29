// lib/data/models/student_progress_stage_model.dart
class StudentProgressStage {
  final int id;
  final String stageName;

  StudentProgressStage({required this.id, required this.stageName});

  factory StudentProgressStage.fromJson(Map<String, dynamic> json) {
    return StudentProgressStage(
      id: json['id'],
      stageName: json['stage_name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage_name': stageName,
    };
  }
}
part of 'add_student_bloc.dart';

abstract class AddStudentEvent {}

// حدث لتغيير الخطوة الحالية في الـ Stepper
class StepChanged extends AddStudentEvent {
  final int step;
  StepChanged(this.step);
}
// --- حدث جديد لتغيير الجنس ---
class GenderChanged extends AddStudentEvent {
  final String gender;
  GenderChanged(this.gender);
}
// --- حدث جديد لتغيير الحالة الاجتماعية ---
class SocialStatusChanged extends AddStudentEvent {
  final String socialStatus;
  SocialStatusChanged(this.socialStatus);
}
// حدث عند الضغط على زر "إضافة الطالب" النهائي
class SubmitStudentData extends AddStudentEvent {
  // هنا نمرر كل البيانات التي تم جمعها
  final AddStudentModel studentData;
  SubmitStudentData(this.studentData);
}
class FetchLevels extends AddStudentEvent {}
class LevelChanged extends AddStudentEvent {
  final int levelId;
  LevelChanged(this.levelId);
}
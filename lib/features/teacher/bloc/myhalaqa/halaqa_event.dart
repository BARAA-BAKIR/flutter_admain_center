// lib/features/teacher/bloc/halaqa_event.dart
part of 'halaqa_bloc.dart'; // سيتم إنشاؤه في الخطوة التالية

abstract class HalaqaEvent {}

// حدث لجلب قائمة الطلاب عند فتح الشاشة
class FetchHalaqaData extends HalaqaEvent {}

// حدث لتسجيل حضور طالب معين
class MarkStudentAttendance extends HalaqaEvent {
  final int studentId;
  
  final newStatus;

  MarkStudentAttendance({required this.studentId, required this.newStatus});
}

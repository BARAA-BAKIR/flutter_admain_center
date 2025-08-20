// lib/features/center_manager/bloc/edit_teacher_bloc/edit_teacher_event.dart

part of 'edit_teacher_bloc.dart'; // <-- الخطوة 1: الربط بالملف الرئيسي للـ BLoC

abstract class EditTeacherEvent extends Equatable {
  const EditTeacherEvent();

  @override
  List<Object> get props => [];
}

// حدث لجلب بيانات الأستاذ الحالية لعرضها في حقول التعديل
class LoadTeacherForEdit extends EditTeacherEvent {
  final int teacherId;
  const LoadTeacherForEdit(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}

// حدث لإرسال البيانات الجديدة إلى الخادم بعد الضغط على "حفظ"
class SubmitTeacherUpdate extends EditTeacherEvent {
  final int teacherId;
  final Map<String, dynamic> data;
  const SubmitTeacherUpdate({required this.teacherId, required this.data});

  @override
  List<Object> get props => [teacherId, data];
}

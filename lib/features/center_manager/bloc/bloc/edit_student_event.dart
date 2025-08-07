part of 'edit_student_bloc.dart';

abstract class EditStudentEvent extends Equatable {
  const EditStudentEvent();
  @override
  List<Object> get props => [];
}

class SubmitStudentUpdate extends EditStudentEvent {
  final int studentId;
  final Map<String, dynamic> data;
  const SubmitStudentUpdate({required this.studentId, required this.data});
}

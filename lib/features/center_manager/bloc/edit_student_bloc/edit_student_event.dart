part of 'edit_student_bloc.dart';

abstract class EditStudentEvent extends Equatable {
  const EditStudentEvent();
  @override
  List<Object> get props => [];
}

class FetchStudentDetails extends EditStudentEvent {
  final int studentId;
  const FetchStudentDetails(this.studentId);
}

class SubmitStudentUpdate extends EditStudentEvent {
  final int studentId;
  final EditStudentModel data;
  const SubmitStudentUpdate({required this.studentId, required this.data});
}

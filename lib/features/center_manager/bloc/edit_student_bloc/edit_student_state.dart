part of 'edit_student_bloc.dart';

enum EditStudentStatus { initial, loadingDetails, detailsLoaded, submitting, success, failure }

class EditStudentState extends Equatable {
  final EditStudentStatus status;
  final StudentDetails? student;
  final StudentDetails? updatedStudent;
  final String? errorMessage;

  const EditStudentState({
    this.status = EditStudentStatus.initial,
    this.student,
    this.updatedStudent,
    this.errorMessage,
  });

  EditStudentState copyWith({
    EditStudentStatus? status,
    StudentDetails? student,
    StudentDetails? updatedStudent,
    String? errorMessage,
  }) {
    return EditStudentState(
      status: status ?? this.status,
      student: student ?? this.student,
      updatedStudent: updatedStudent ?? this.updatedStudent,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, student, updatedStudent, errorMessage];
}

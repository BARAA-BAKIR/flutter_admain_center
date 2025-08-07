part of 'edit_student_bloc.dart';

enum EditStudentStatus { initial, loading, success, failure }

class EditStudentState extends Equatable {
  final EditStudentStatus status;
  final Student? updatedStudent; // لإرجاع الطالب المحدث
  final String? errorMessage;

  const EditStudentState({
    this.status = EditStudentStatus.initial,
    this.updatedStudent,
    this.errorMessage,
  });

  EditStudentState copyWith({
    EditStudentStatus? status,
    Student? updatedStudent,
    String? errorMessage,
  }) {
    return EditStudentState(
      status: status ?? this.status,
      updatedStudent: updatedStudent ?? this.updatedStudent,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, updatedStudent, errorMessage];
}

part of 'add_teacher_bloc.dart';

enum AddTeacherStatus { initial, submitting, success, failure }

class AddTeacherState extends Equatable {
  final AddTeacherStatus status;
  final String? errorMessage;
  final Teacher? createdTeacher;

  const AddTeacherState({
    this.status = AddTeacherStatus.initial,
    this.errorMessage,
    this.createdTeacher,
  });

  AddTeacherState copyWith({
    AddTeacherStatus? status,
    String? errorMessage,
    Teacher? createdTeacher,
  }) {
    return AddTeacherState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdTeacher: createdTeacher ?? this.createdTeacher,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, createdTeacher];
}

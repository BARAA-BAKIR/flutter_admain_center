part of 'add_teacher_bloc.dart';

abstract class AddTeacherEvent extends Equatable {
  const AddTeacherEvent();
  @override
  List<Object> get props => [];
}

class SubmitNewTeacher extends AddTeacherEvent {
  final AddTeacherModel teacherData;
  const SubmitNewTeacher(this.teacherData);
}

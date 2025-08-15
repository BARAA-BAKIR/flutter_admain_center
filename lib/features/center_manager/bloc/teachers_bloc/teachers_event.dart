part of 'teachers_bloc.dart';

abstract class TeachersEvent extends Equatable {
  const TeachersEvent();
  @override
  List<Object?> get props => [];
}

class FetchTeachers extends TeachersEvent {
  final String? searchQuery;
  const FetchTeachers({this.searchQuery});
}

class FetchMoreTeachers extends TeachersEvent {}
class DeleteTeacher extends TeachersEvent {
  final int teacherId;
  const DeleteTeacher(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}
class AddNewTeacherToList extends TeachersEvent {
  final Teacher newTeacher;
  const AddNewTeacherToList(this.newTeacher);

  @override
  List<Object?> get props => [newTeacher];
}
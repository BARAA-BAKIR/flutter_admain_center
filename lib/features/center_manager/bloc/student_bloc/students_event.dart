part of 'students_bloc.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();
  @override
  List<Object> get props => [];
}

class FetchStudents extends StudentsEvent {
  final String? searchQuery;
  const FetchStudents({this.searchQuery});
}

class FetchMoreStudents extends StudentsEvent {}

class ApplyStudentsFilter extends StudentsEvent {
  final int? halaqaId;
  final int? levelId;
  const ApplyStudentsFilter({this.halaqaId, this.levelId});
}

class DeleteStudent extends StudentsEvent {
  final int studentId;
  const DeleteStudent(this.studentId);
}

// هذا الحدث يجب أن يستقبل المودل الشامل StudentDetails
class UpdateStudentInList extends StudentsEvent {
  final StudentDetails updatedStudent;
  const UpdateStudentInList(this.updatedStudent);
}

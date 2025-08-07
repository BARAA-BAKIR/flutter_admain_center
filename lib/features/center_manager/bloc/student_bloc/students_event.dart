part of 'students_bloc.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object> get props => [];
}

// حدث لجلب الدفعة الأولى من الطلاب أو لتحديث القائمة
class FetchStudents extends StudentsEvent {
  final String? searchQuery;
  const FetchStudents({this.searchQuery});
}

// حدث لجلب المزيد من الطلاب عند التمرير (Pagination)
class FetchMoreStudents extends StudentsEvent {}
// حدث جديد لتطبيق الفلاتر
class ApplyStudentsFilter extends StudentsEvent {
  final int? halaqaId;
  final int? levelId;
  const ApplyStudentsFilter({this.halaqaId, this.levelId});
}

// حدث جديد لحذف طالب
class DeleteStudent extends StudentsEvent {
  final int studentId;
  const DeleteStudent(this.studentId);
}
class UpdateStudentInList extends StudentsEvent {
  final Student updatedStudent;
  const UpdateStudentInList(this.updatedStudent);

  @override
  List<Object> get props => [updatedStudent];
}
part of 'all_students_bloc.dart';

abstract class AllStudentsEvent extends Equatable {
  const AllStudentsEvent();
  @override
  List<Object?> get props => [];
}

// --- أحداث قائمة الطلاب ---
class FetchAllStudents extends AllStudentsEvent {
  final String? searchQuery;
  const FetchAllStudents({this.searchQuery});
}
class FetchMoreAllStudents extends AllStudentsEvent {}
class DeleteStudent extends AllStudentsEvent {
  final int studentId;
  const DeleteStudent(this.studentId);
}

// --- أحداث نموذج الإضافة/التعديل ---
class LoadDataForStudentForm extends AllStudentsEvent {
  final int? studentId;
  const LoadDataForStudentForm({this.studentId});
}

class AddNewStudent extends AllStudentsEvent {
  final Map<String, dynamic> data;
  const AddNewStudent({required this.data});
}

class UpdateStudentDetails extends AllStudentsEvent {
  final int studentId;
  final Map<String, dynamic> data;
  const UpdateStudentDetails({required this.studentId, required this.data});
}

class CenterSelected extends AllStudentsEvent {
  final int? centerId;
  const CenterSelected(this.centerId);
}

class FormValueChanged extends AllStudentsEvent {
  final int? halaqaId;
  final int? levelId;
  final String? gender;
  final DateTime? birthDate;
  final bool? isOneParentDeceased;

  const FormValueChanged({
    this.halaqaId,
    this.levelId,
    this.gender,
    this.birthDate,
    this.isOneParentDeceased,
  });
}

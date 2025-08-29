part of 'teacher_management_bloc.dart';

abstract class TeacherManagementEvent extends Equatable {
  const TeacherManagementEvent();
  @override
  List<Object> get props => [];
}

// Fetch approved teachers with pagination and search
class FetchApprovedTeachers extends TeacherManagementEvent {
  final String? searchQuery;
  const FetchApprovedTeachers({this.searchQuery});
}
class FetchMoreApprovedTeachers extends TeacherManagementEvent {}

// Fetch pending teacher requests
class FetchPendingTeachers extends TeacherManagementEvent {}

// Approve a teacher's request
class ApproveTeacherRequest extends TeacherManagementEvent {
  final int userId;
  const ApproveTeacherRequest(this.userId);
}

// Reject a teacher's request
class RejectTeacherRequest extends TeacherManagementEvent {
  final int userId;
  const RejectTeacherRequest(this.userId);
}
class PromoteTeacher extends TeacherManagementEvent {
  final int teacherId;
  final String newRole;
  const PromoteTeacher({required this.teacherId, required this.newRole});
}
// ... (other events)

class AddTeacher extends TeacherManagementEvent {
  final Map<String, dynamic> data;
  const AddTeacher({required this.data});

  @override
  List<Object> get props => [data];
}

class UpdateTeacher extends TeacherManagementEvent {
  final int teacherId;
  final Map<String, dynamic> data;
  const UpdateTeacher({required this.teacherId, required this.data});

  @override
  List<Object> get props => [teacherId, data];
}
class DeleteTeacher extends TeacherManagementEvent {
  final int teacherId;
  const DeleteTeacher(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}
class FetchPrerequisitesForTeacherForm extends TeacherManagementEvent {
  const FetchPrerequisitesForTeacherForm();
}
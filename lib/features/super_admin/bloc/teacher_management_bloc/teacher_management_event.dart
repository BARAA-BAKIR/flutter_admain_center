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

part of 'teacher_management_bloc.dart';

enum TeacherManagementStatus { initial, loading, success, failure }

class TeacherManagementState extends Equatable {
  // For approved teachers list
  final TeacherManagementStatus approvedStatus;
  final List<Teacher> approvedTeachers;
  final bool hasReachedMax;
  final int currentPage;

  // For pending teachers list
  final TeacherManagementStatus pendingStatus;
  final List<PendingUser> pendingTeachers;

  final String? errorMessage;

  const TeacherManagementState({
    this.approvedStatus = TeacherManagementStatus.initial,
    this.approvedTeachers = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.pendingStatus = TeacherManagementStatus.initial,
    this.pendingTeachers = const [],
    this.errorMessage,
  });

  TeacherManagementState copyWith({
    TeacherManagementStatus? approvedStatus,
    List<Teacher>? approvedTeachers,
    bool? hasReachedMax,
    int? currentPage,
    TeacherManagementStatus? pendingStatus,
    List<PendingUser>? pendingTeachers,
    String? errorMessage,
  }) {
    return TeacherManagementState(
      approvedStatus: approvedStatus ?? this.approvedStatus,
      approvedTeachers: approvedTeachers ?? this.approvedTeachers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      pendingStatus: pendingStatus ?? this.pendingStatus,
      pendingTeachers: pendingTeachers ?? this.pendingTeachers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [approvedStatus, approvedTeachers, hasReachedMax, currentPage, pendingStatus, pendingTeachers, errorMessage];
}

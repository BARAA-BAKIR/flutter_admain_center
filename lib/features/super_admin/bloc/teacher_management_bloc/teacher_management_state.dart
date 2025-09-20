part of 'teacher_management_bloc.dart';

enum FormStatus { initial, submitting, success, failure }
enum TeacherManagementStatus { initial, loading, success, failure }
enum TeacherActionStatus { initial, success, failure }

class TeacherManagementState extends Equatable {
  // For approved teachers list
  final TeacherManagementStatus approvedStatus;
  final List<Teacher> approvedTeachers;
  final bool hasReachedMax;
  final int currentPage;

  // For pending teachers list
  final TeacherManagementStatus pendingStatus;
  final List<PendingUser> pendingTeachers;

  // For form handling (add/edit)
  final FormStatus formStatus;
  final String? formError;
  final List<CenterFilterModel> centersList;
  final bool isLoadingPrerequisites;

  // For general actions (approve, reject, delete)
  final TeacherActionStatus actionStatus;
  final String? successMessage;
  final String? errorMessage;

  const TeacherManagementState({
    this.approvedStatus = TeacherManagementStatus.initial,
    this.approvedTeachers = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.pendingStatus = TeacherManagementStatus.initial,
    this.pendingTeachers = const [],
    this.formStatus = FormStatus.initial,
    this.formError,
    this.centersList = const [],
    this.isLoadingPrerequisites = false,
    this.actionStatus = TeacherActionStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  TeacherManagementState copyWith({
    TeacherManagementStatus? approvedStatus,
    List<Teacher>? approvedTeachers,
    bool? hasReachedMax,
    int? currentPage,
    TeacherManagementStatus? pendingStatus,
    List<PendingUser>? pendingTeachers,
    FormStatus? formStatus,
    String? formError,
    List<CenterFilterModel>? centersList,
    bool? isLoadingPrerequisites,
    TeacherActionStatus? actionStatus,
    String? successMessage,
    String? errorMessage,
    bool resetActionStatus = false, 
  }) {
    return TeacherManagementState(
      approvedStatus: approvedStatus ?? this.approvedStatus,
      approvedTeachers: approvedTeachers ?? this.approvedTeachers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      pendingStatus: pendingStatus ?? this.pendingStatus,
      pendingTeachers: pendingTeachers ?? this.pendingTeachers,
      formStatus: formStatus ?? this.formStatus,
      formError: formError, // No ?? operator, allows setting to null
      centersList: centersList ?? this.centersList,
      isLoadingPrerequisites: isLoadingPrerequisites ?? this.isLoadingPrerequisites,
      // ✅ إصلاح: إعادة تعيين الحالة والرسائل بشكل صحيح
      actionStatus: resetActionStatus ? TeacherActionStatus.initial : (actionStatus ?? this.actionStatus),
      successMessage: successMessage, // No ?? operator
      errorMessage: errorMessage,     // No ?? operator
    );
  }

  @override
  List<Object?> get props => [
    approvedStatus,
    approvedTeachers,
    hasReachedMax,
    currentPage,
    pendingStatus,
    pendingTeachers,
    formStatus,
    formError,
    centersList,
    isLoadingPrerequisites,
    actionStatus,
    successMessage,
    errorMessage,
  ];
}

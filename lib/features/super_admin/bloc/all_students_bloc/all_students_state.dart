part of 'all_students_bloc.dart';

enum AllStudentsStatus { initial, loading, success, failure }

class AllStudentsState extends Equatable {
  final AllStudentsStatus status;
  final List<StudentListItem> students; // سنستخدم نفس مودل الطالب
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;
  final String? searchQuery;

  const AllStudentsState({
    this.status = AllStudentsStatus.initial,
    this.students = const <StudentListItem>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
    this.searchQuery,
  });

  AllStudentsState copyWith({
    AllStudentsStatus? status,
    List<StudentListItem>? students,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
    String? searchQuery,
  }) {
    return AllStudentsState(
      status: status ?? this.status,
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, students, hasReachedMax, currentPage, errorMessage, searchQuery];
}

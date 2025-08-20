part of 'all_students_bloc.dart';

enum AllStudentsStatus { initial, loading, success, failure }

class AllStudentsState extends Equatable {
  final AllStudentsStatus status;
  final List<StudentListItem> students;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;
  
  // To keep track of current filters for pagination
  final String? searchQuery;
  final int? centerId;
  final int? halaqaId;

  const AllStudentsState({
    this.status = AllStudentsStatus.initial,
    this.students = const <StudentListItem>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
    this.searchQuery,
    this.centerId,
    this.halaqaId,
  });

  AllStudentsState copyWith({
    AllStudentsStatus? status,
    List<StudentListItem>? students,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  }) {
    return AllStudentsState(
      status: status ?? this.status,
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      centerId: centerId ?? this.centerId,
      halaqaId: halaqaId ?? this.halaqaId,
    );
  }

  @override
  List<Object?> get props => [status, students, hasReachedMax, currentPage, errorMessage, searchQuery, centerId, halaqaId];
}

part of 'students_bloc.dart';

enum StudentsStatus { initial, loading, success, failure }

class StudentsState extends Equatable {
  final StudentsStatus status;
  final List<StudentListItem> students;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;
  final int? halaqaIdFilter;
  final int? levelIdFilter;

  const StudentsState({
    this.status = StudentsStatus.initial,
    this.students = const <StudentListItem>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
    this.halaqaIdFilter,
    this.levelIdFilter,
  });

  StudentsState copyWith({
    StudentsStatus? status,
    List<StudentListItem>? students,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
    int? halaqaIdFilter,
    int? levelIdFilter,
  }) {
    return StudentsState(
      status: status ?? this.status,
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
      halaqaIdFilter: halaqaIdFilter ?? this.halaqaIdFilter,
      levelIdFilter: levelIdFilter ?? this.levelIdFilter,
    );
  }

  @override
  List<Object?> get props => [status, students, hasReachedMax, currentPage, errorMessage, halaqaIdFilter, levelIdFilter];
}

part of 'students_bloc.dart';

enum StudentsStatus { initial, loading, success, failure }

class StudentsState extends Equatable {
  final StudentsStatus status;
  final List<Student> students;
  final bool hasReachedMax; // هل وصلنا إلى نهاية القائمة؟
  final int currentPage;
  final String? errorMessage;

 final int? halaqaIdFilter;
  final int? levelIdFilter;

  const StudentsState({
    this.status = StudentsStatus.initial,
    this.students = const <Student>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,

     this.halaqaIdFilter,
    this.levelIdFilter,
  });

  StudentsState copyWith({
    StudentsStatus? status,
    List<Student>? students,
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
      errorMessage: errorMessage ?? this.errorMessage,

        halaqaIdFilter: halaqaIdFilter ?? this.halaqaIdFilter,
      levelIdFilter: levelIdFilter ?? this.levelIdFilter,
    );
  }

  @override
  List<Object?> get props => [status, students, hasReachedMax, currentPage, errorMessage
  , halaqaIdFilter, levelIdFilter];
}

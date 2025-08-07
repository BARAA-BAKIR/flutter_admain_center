part of 'teachers_bloc.dart';

enum TeachersStatus { initial, loading, success, failure }

class TeachersState extends Equatable {
  final TeachersStatus status;
  final List<Teacher> teachers;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const TeachersState({
    this.status = TeachersStatus.initial,
    this.teachers = const <Teacher>[],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  TeachersState copyWith({
    TeachersStatus? status,
    List<Teacher>? teachers,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return TeachersState(
      status: status ?? this.status,
      teachers: teachers ?? this.teachers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, teachers, hasReachedMax, currentPage, errorMessage];
}

part of 'all_students_bloc.dart';

abstract class AllStudentsEvent extends Equatable {
  const AllStudentsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllStudents extends AllStudentsEvent {
  final String? searchQuery;
  final int? centerId;
  final int? halaqaId;

  const FetchAllStudents({this.searchQuery, this.centerId, this.halaqaId});

  @override
  List<Object?> get props => [searchQuery, centerId, halaqaId];
}

class FetchMoreAllStudents extends AllStudentsEvent {}

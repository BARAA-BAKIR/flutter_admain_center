part of 'all_students_bloc.dart';

abstract class AllStudentsEvent extends Equatable {
  const AllStudentsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllStudents extends AllStudentsEvent {
  final String? searchQuery;
  const FetchAllStudents({this.searchQuery});
}

class FetchMoreAllStudents extends AllStudentsEvent {}

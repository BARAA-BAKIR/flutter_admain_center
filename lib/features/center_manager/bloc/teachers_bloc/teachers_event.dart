
part of 'teachers_bloc.dart';

abstract class TeachersEvent extends Equatable {
  const TeachersEvent();
  @override
  List<Object?> get props => [];
}

class FetchTeachers extends TeachersEvent {
  final String? searchQuery;
  const FetchTeachers({this.searchQuery});
}

class FetchMoreTeachers extends TeachersEvent {}

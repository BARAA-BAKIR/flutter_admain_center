
part of 'center_managers_bloc.dart';

abstract class CenterManagersState extends Equatable {
  const CenterManagersState();

  @override
  List<Object> get props => [];
}

class CenterManagersInitial extends CenterManagersState {}

class CenterManagersLoading extends CenterManagersState {}

class CenterManagersLoaded extends CenterManagersState {
  final List<CenterManagerModel> managers;

  const CenterManagersLoaded(this.managers);

  @override
  List<Object> get props => [managers];
}

class CenterManagersError extends CenterManagersState {
  final String message;

  const CenterManagersError(this.message);

  @override
  List<Object> get props => [message];
}
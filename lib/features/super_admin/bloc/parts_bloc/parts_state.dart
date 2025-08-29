// lib/features/super_admin/bloc/parts_bloc/parts_state.dart
part of 'parts_bloc.dart';

abstract class PartsState {}

class PartsInitial extends PartsState {}

class PartsLoading extends PartsState {}

class PartsLoaded extends PartsState {
  final List<Part> parts;

  PartsLoaded(this.parts);
}

class PartsError extends PartsState {
  final String message;

  PartsError(this.message);
}
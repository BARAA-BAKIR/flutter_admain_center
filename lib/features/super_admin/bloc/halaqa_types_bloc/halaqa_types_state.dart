// lib/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_state.dart
part of 'halaqa_types_bloc.dart';

abstract class HalaqaTypesState {}

class HalaqaTypesInitial extends HalaqaTypesState {}

class HalaqaTypesLoading extends HalaqaTypesState {}

class HalaqaTypesLoaded extends HalaqaTypesState {
  final List<HalaqaType> types;

  HalaqaTypesLoaded(this.types);
}

class HalaqaTypesError extends HalaqaTypesState {
  final String message;

  HalaqaTypesError(this.message);
}
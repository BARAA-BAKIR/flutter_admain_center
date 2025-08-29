// lib/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_event.dart
part of 'halaqa_types_bloc.dart';

abstract class HalaqaTypesEvent {}

class LoadHalaqaTypes extends HalaqaTypesEvent {}

class AddHalaqaType extends HalaqaTypesEvent {
  final String name;

  AddHalaqaType({required this.name});
}

class UpdateHalaqaType extends HalaqaTypesEvent {
  final int id;
  final String name;

  UpdateHalaqaType({required this.id, required this.name});
}

class DeleteHalaqaType extends HalaqaTypesEvent {
  final int id;

  DeleteHalaqaType({required this.id});
}
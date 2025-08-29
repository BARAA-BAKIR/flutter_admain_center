// lib/features/super_admin/bloc/parts_bloc/parts_event.dart
part of 'parts_bloc.dart';

abstract class PartsEvent {}

class LoadParts extends PartsEvent {}

class AddPart extends PartsEvent {
  final String writing;

  AddPart({required this.writing});
}

class UpdatePart extends PartsEvent {
  final int id;
  final String writing;

  UpdatePart({required this.id, required this.writing});
}

class DeletePart extends PartsEvent {
  final int id;

  DeletePart({required this.id});
}
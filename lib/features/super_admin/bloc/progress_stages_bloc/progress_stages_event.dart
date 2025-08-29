// lib/features/super_admin/bloc/progress_stages_bloc/progress_stages_event.dart
part of 'progress_stages_bloc.dart';

abstract class ProgressStagesEvent {}

class LoadProgressStages extends ProgressStagesEvent {}

class AddProgressStage extends ProgressStagesEvent {
  final String name;

  AddProgressStage({required this.name});
}

class UpdateProgressStage extends ProgressStagesEvent {
  final int id;
  final String name;

  UpdateProgressStage({required this.id, required this.name});
}

class DeleteProgressStage extends ProgressStagesEvent {
  final int id;

  DeleteProgressStage({required this.id});
}
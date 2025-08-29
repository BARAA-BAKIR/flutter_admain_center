// lib/features/super_admin/bloc/progress_stages_bloc/progress_stages_state.dart
part of 'progress_stages_bloc.dart';

abstract class ProgressStagesState {}

class ProgressStagesInitial extends ProgressStagesState {}

class ProgressStagesLoading extends ProgressStagesState {}

class ProgressStagesLoaded extends ProgressStagesState {
  final List<StudentProgressStage> stages;

  ProgressStagesLoaded(this.stages);
}

class ProgressStagesError extends ProgressStagesState {
  final String message;

  ProgressStagesError(this.message);
}
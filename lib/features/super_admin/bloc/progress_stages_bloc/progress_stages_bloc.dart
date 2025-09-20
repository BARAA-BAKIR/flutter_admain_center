// // lib/features/super_admin/bloc/progress_stages_bloc/progress_stages_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

// part 'progress_stages_event.dart';
// part 'progress_stages_state.dart';

// class ProgressStagesBloc extends Bloc<ProgressStagesEvent, ProgressStagesState> {
//   final SuperAdminRepository repository;

//   ProgressStagesBloc({required this.repository}) : super(ProgressStagesInitial()) {
//     on<LoadProgressStages>(_onLoadProgressStages);
//     on<AddProgressStage>(_onAddProgressStage);
//     on<UpdateProgressStage>(_onUpdateProgressStage);
//     on<DeleteProgressStage>(_onDeleteProgressStage);
//   }

//   Future<void> _onLoadProgressStages(
//     LoadProgressStages event,
//     Emitter<ProgressStagesState> emit,
//   ) async {
//     emit(ProgressStagesLoading());
//     try {
//       final stages = await repository.getProgressStages();
//       emit(ProgressStagesLoaded(stages as List<StudentProgressStage>));
//     } catch (e) {
//       emit(ProgressStagesError(e.toString()));
//     }
//   }

//   Future<void> _onAddProgressStage(
//     AddProgressStage event,
//     Emitter<ProgressStagesState> emit,
//   ) async {
//     try {
//       await repository.addProgressStage(event.name);
//       add(LoadProgressStages());
//     } catch (e) {
//       emit(ProgressStagesError(e.toString()));
//     }
//   }

//   Future<void> _onUpdateProgressStage(
//     UpdateProgressStage event,
//     Emitter<ProgressStagesState> emit,
//   ) async {
//     try {
//       await repository.updateProgressStage(event.id, event.name);
//       add(LoadProgressStages());
//     } catch (e) {
//       emit(ProgressStagesError(e.toString()));
//     }
//   }

//   Future<void> _onDeleteProgressStage(
//     DeleteProgressStage event,
//     Emitter<ProgressStagesState> emit,
//   ) async {
//     try {
//       await repository.deleteProgressStage(event.id);
//       add(LoadProgressStages());
//     } catch (e) {
//       emit(ProgressStagesError(e.toString()));
//     }
//   }
// }
// progress_stages_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'progress_stages_event.dart';
part 'progress_stages_state.dart';

class ProgressStagesBloc extends Bloc<ProgressStagesEvent, ProgressStagesState> {
  final SuperAdminRepository repository;

  ProgressStagesBloc({required this.repository}) : super(ProgressStagesInitial()) {
    on<LoadProgressStages>(_onLoadProgressStages);
    on<AddProgressStage>(_onAddProgressStage);
    on<UpdateProgressStage>(_onUpdateProgressStage);
    on<DeleteProgressStage>(_onDeleteProgressStage);
  }

  Future<void> _onLoadProgressStages(
    LoadProgressStages event,
    Emitter<ProgressStagesState> emit,
  ) async {
    emit(ProgressStagesLoading());
    final result = await repository.getProgressStagesForFilter();
    result.fold(
      (failure) => emit(ProgressStagesError(failure.message)),
      (stages) => emit(ProgressStagesLoaded(stages)),
    );
  }

  Future<void> _onAddProgressStage(
    AddProgressStage event,
    Emitter<ProgressStagesState> emit,
  ) async {
    emit(ProgressStagesLoading());
    final result = await repository.addProgressStage(event.name);
    result.fold(
      (failure) => emit(ProgressStagesError(failure.message)),
      (_) => add(LoadProgressStages()),
    );
  }

  Future<void> _onUpdateProgressStage(
    UpdateProgressStage event,
    Emitter<ProgressStagesState> emit,
  ) async {
    emit(ProgressStagesLoading());
    final result = await repository.updateProgressStage(event.id, event.name);
    result.fold(
      (failure) => emit(ProgressStagesError(failure.message)),
      (_) => add(LoadProgressStages()),
    );
  }

  Future<void> _onDeleteProgressStage(
    DeleteProgressStage event,
    Emitter<ProgressStagesState> emit,
  ) async {
    emit(ProgressStagesLoading());
    final result = await repository.deleteProgressStage(event.id);
    result.fold(
      (failure) => emit(ProgressStagesError(failure.message)),
      (_) => add(LoadProgressStages()),
    );
  }
}
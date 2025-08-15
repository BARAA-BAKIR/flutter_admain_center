// lib/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_halaqa_event.dart';
part 'edit_halaqa_state.dart';

class EditHalaqaBloc extends Bloc<EditHalaqaEvent, EditHalaqaState> {
  final CenterManagerRepository _repository;

  EditHalaqaBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const EditHalaqaState()) {
    on<LoadAllEditData>(_onLoadAllEditData);
    on<SelectionChanged>(_onSelectionChanged);
    on<SubmitHalaqaUpdate>(_onSubmitUpdate);
  }

  Future<void> _onLoadAllEditData(LoadAllEditData event, Emitter<EditHalaqaState> emit) async {
    emit(state.copyWith(status: EditHalaqaStatus.loading));
    final results = await Future.wait([
      _repository.getHalaqaForEdit(event.halaqaId),
      _repository.getTeachersForSelection(),
      _repository.getMosquesForSelection(),
      _repository.getHalaqaTypesForSelection(),
    ]);

    final halaqaResult = results[0] as Either<Failure, Map<String, dynamic>>;
    final teachersResult = results[1] as Either<Failure, List<TeacherSelectionModel>>;
    final mosquesResult = results[2] as Either<Failure, List<MosqueSelectionModel>>;
    final typesResult = results[3] as Either<Failure, List<Map<String, dynamic>>>;

    Map<String, dynamic>? initialHalaqaData;
    List<TeacherSelectionModel>? teachers;
    List<MosqueSelectionModel>? mosques;
    List<Map<String, dynamic>>? halaqaTypes;
    String? firstError;

    halaqaResult.fold((f) => firstError ??= f.message, (d) => initialHalaqaData = d);
    teachersResult.fold((f) => firstError ??= f.message, (d) => teachers = d);
    mosquesResult.fold((f) => firstError ??= f.message, (d) => mosques = d);
    typesResult.fold((f) => firstError ??= f.message, (d) => halaqaTypes = d);

    if (firstError == null) {
      final halaqa = initialHalaqaData!['halaqa'];
      final progress = initialHalaqaData?['progress'];

      final initialMosque = mosques!.firstWhereOrNull((m) => m.id == halaqa['mosque_id']);
      final initialType = halaqaTypes!.firstWhereOrNull((t) => t['id'] == halaqa['type']);
      final initialTeacher = (progress != null) ? teachers!.firstWhereOrNull((t) => t.id == progress['teacher_id']) : null;

      emit(state.copyWith(
        status: EditHalaqaStatus.success,
        initialHalaqaData: initialHalaqaData,
        availableTeachers: teachers,
        availableMosques: mosques,
        halaqaTypes: halaqaTypes,
        selectedMosque: initialMosque,
        selectedHalaqaType: initialType,
        selectedTeacher: initialTeacher,
      ));
    } else {
      emit(state.copyWith(status: EditHalaqaStatus.failure, errorMessage: firstError));
    }
  }

  void _onSelectionChanged(SelectionChanged event, Emitter<EditHalaqaState> emit) {
    emit(state.copyWith(
      selectedTeacher: event.selectedTeacher,
      selectedMosque: event.selectedMosque,
      selectedHalaqaType: event.selectedHalaqaType,
      unselectTeacher: event.unselectTeacher,
    ));
  }

  Future<void> _onSubmitUpdate(SubmitHalaqaUpdate event, Emitter<EditHalaqaState> emit) async {
    emit(state.copyWith(status: EditHalaqaStatus.submitting));
    final result = await _repository.updateHalaqa(event.halaqaId, event.halaqaData);
    result.fold(
      (failure) => emit(state.copyWith(status: EditHalaqaStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: EditHalaqaStatus.success, clearInitialData: true)),
    );
  }
}

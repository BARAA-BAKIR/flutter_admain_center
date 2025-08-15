import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'add_halaqa_event.dart';
part 'add_halaqa_state.dart';

class AddHalaqaBloc extends Bloc<AddHalaqaEvent, AddHalaqaState> {
  final CenterManagerRepository _repository;

  AddHalaqaBloc({required CenterManagerRepository repository})
    : _repository = repository,
      super(const AddHalaqaState()) {
    on<LoadHalaqaPrerequisites>(_onLoadPrerequisites);
    on<AddHalaqaSelectionChanged>(_onSelectionChanged);
    on<SubmitNewHalaqa>(_onSubmit);
    add(LoadHalaqaPrerequisites());
  }

  Future<void> _onLoadPrerequisites(LoadHalaqaPrerequisites event, Emitter<AddHalaqaState> emit) async {
    emit(state.copyWith(status: AddHalaqaStatus.loading));
    final results = await Future.wait([
      _repository.getTeachersForSelection(),
      _repository.getMosquesForSelection(),
      _repository.getHalaqaTypesForSelection(),
    ]);

    final teachersResult = results[0] as Either<Failure, List<TeacherSelectionModel>>;
    final mosquesResult = results[1] as Either<Failure, List<MosqueSelectionModel>>;
    final typesResult = results[2] as Either<Failure, List<Map<String, dynamic>>>;

    String? firstError;
    List<TeacherSelectionModel>? teachers;
    List<MosqueSelectionModel>? mosques;
    List<Map<String, dynamic>>? halaqaTypes;

    teachersResult.fold((f) => firstError ??= f.message, (d) => teachers = d);
    mosquesResult.fold((f) => firstError ??= f.message, (d) => mosques = d);
    typesResult.fold((f) => firstError ??= f.message, (d) => halaqaTypes = d);

    if (firstError != null) {
      emit(state.copyWith(status: AddHalaqaStatus.failure, errorMessage: firstError));
    } else {
      emit(state.copyWith(
        status: AddHalaqaStatus.initial,
        availableTeachers: teachers,
        availableMosques: mosques,
        halaqaTypes: halaqaTypes,
      ));
    }
  }

  void _onSelectionChanged(AddHalaqaSelectionChanged event, Emitter<AddHalaqaState> emit) {
    emit(state.copyWith(
      selectedTeacher: event.selectedTeacher,
      selectedMosque: event.selectedMosque,
      selectedHalaqaType: event.selectedHalaqaType,
      unselectTeacher: event.unselectTeacher,
    ));
  }

  Future<void> _onSubmit(SubmitNewHalaqa event, Emitter<AddHalaqaState> emit) async {
    emit(state.copyWith(status: AddHalaqaStatus.submitting));
    final result = await _repository.addHalaqa(event.halaqaData);
    result.fold(
      (failure) => emit(state.copyWith(status: AddHalaqaStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AddHalaqaStatus.success)),
    );
  }
}

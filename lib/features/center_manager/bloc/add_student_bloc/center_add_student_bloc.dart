import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'center_add_student_event.dart';
part 'center_add_student_state.dart';

class CenterAddStudentBloc extends Bloc<CenterAddStudentEvent, CenterAddStudentState> {
  final CenterManagerRepository centerManagerRepository;

  CenterAddStudentBloc({required this.centerManagerRepository}) : super(const CenterAddStudentState()) {
    on<FetchCenterInitialData>(_onFetchInitialData);
    on<CenterStepChanged>((event, emit) => emit(state.copyWith(currentStep: event.step)));
    on<CenterGenderChanged>((event, emit) => emit(state.copyWith(gender: event.gender)));
    on<CenterSocialStatusChanged>((event, emit) => emit(state.copyWith(socialStatus: event.socialStatus)));
    on<CenterLevelChanged>((event, emit) => emit(state.copyWith(selectedLevelId: event.levelId)));
    on<CenterHalaqaChanged>((event, emit) => emit(state.copyWith(selectedHalaqaId: event.halaqaId)));
    on<SubmitCenterStudentData>(_onSubmitStudentData);
  }

  Future<void> _onFetchInitialData(FetchCenterInitialData event, Emitter<CenterAddStudentState> emit) async {
    emit(state.copyWith(isLoadingHalaqas: true, isLoadingLevels: true));
    final results = await Future.wait([
      centerManagerRepository.getHalaqasForSelection(),
      centerManagerRepository.getLevels(),
    ]);

    final halaqasResult = results[0];
    final levelsResult = results[1];

    halaqasResult.fold(
      (failure) => emit(state.copyWith(isLoadingHalaqas: false, errorMessage: failure.message)),
      (halaqas) => emit(state.copyWith(halaqas: halaqas as List<Halaqa>, isLoadingHalaqas: false)),
    );

    levelsResult.fold(
      (failure) => emit(state.copyWith(isLoadingLevels: false, errorMessage: failure.message)),
      (levels) => emit(state.copyWith(levels: levels as List<LevelModel>, isLoadingLevels: false)),
    );
  }

  Future<void> _onSubmitStudentData(SubmitCenterStudentData event, Emitter<CenterAddStudentState> emit) async {
    emit(state.copyWith(status: CenterAddStudentStatus.loading, errorMessage: null));
    final result = await centerManagerRepository.addStudent(studentData: event.studentData);
    result.fold(
      (failure) => emit(state.copyWith(status: CenterAddStudentStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: CenterAddStudentStatus.success)),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_diatls_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'teacher_profile_event.dart';
part 'teacher_profile_state.dart';

class TeacherProfileBloc extends Bloc<TeacherProfileEvent, TeacherProfileState> {
  final CenterManagerRepository _repository;

  TeacherProfileBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const TeacherProfileState()) {
    on<FetchTeacherProfile>(_onFetchTeacherProfile);
  }

  Future<void> _onFetchTeacherProfile(
    FetchTeacherProfile event,
    Emitter<TeacherProfileState> emit,
  ) async {
    emit(state.copyWith(status: TeacherProfileStatus.loading));
    final result = await _repository.getTeacherDetails(event.teacherId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: TeacherProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (details) => emit(state.copyWith(
        status: TeacherProfileStatus.success,
        teacherDetails: details,
      )),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'add_halaqa_event.dart';
part 'add_halaqa_state.dart';

class AddHalaqaBloc extends Bloc<AddHalaqaEvent, AddHalaqaState> {
  final CenterManagerRepository _repository;
  AddHalaqaBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const AddHalaqaState()) {
    on<LoadHalaqaPrerequisites>(_onLoadPrerequisites);
    on<SubmitNewHalaqa>(_onSubmit);
  }

  Future<void> _onLoadPrerequisites(
      LoadHalaqaPrerequisites event, Emitter<AddHalaqaState> emit) async {
    emit(state.copyWith(status: AddHalaqaStatus.loading));
    final result = await _repository.getTeachersForSelection();
    result.fold(
      (l) => emit(state.copyWith(status: AddHalaqaStatus.failure, errorMessage: l.message)),
      (teachers) => emit(state.copyWith(status: AddHalaqaStatus.initial, availableTeachers: teachers)),
    );
  }

  Future<void> _onSubmit(SubmitNewHalaqa event, Emitter<AddHalaqaState> emit) async {
    emit(state.copyWith(status: AddHalaqaStatus.loading));
    final result = await _repository.addHalaqa(event.data);
    result.fold(
      (l) => emit(state.copyWith(status: AddHalaqaStatus.failure, errorMessage: l.message)),
      (_) => emit(state.copyWith(status: AddHalaqaStatus.success)),
    );
  }
}

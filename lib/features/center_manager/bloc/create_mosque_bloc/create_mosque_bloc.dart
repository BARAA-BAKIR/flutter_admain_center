import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'create_mosque_event.dart';
part 'create_mosque_state.dart';

class CreateMosqueBloc extends Bloc<CreateMosqueEvent, CreateMosqueState> {
  final CenterManagerRepository _repository;

  CreateMosqueBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const CreateMosqueState()) {
    on<CreateMosqueSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    CreateMosqueSubmitted event,
    Emitter<CreateMosqueState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.submissionInProgress));
    final result = await _repository.createMosque(event.mosqueData);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FormStatus.submissionFailure,
        errorMessage: failure.message,
      )),
      (mosque) => emit(state.copyWith(status: FormStatus.submissionSuccess)),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_mosque_event.dart';
part 'edit_mosque_state.dart';

class EditMosqueBloc extends Bloc<EditMosqueEvent, EditMosqueState> {
  final CenterManagerRepository _repository;

  EditMosqueBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const EditMosqueState()) {
    on<EditMosqueSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    EditMosqueSubmitted event,
    Emitter<EditMosqueState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.submissionInProgress));
    final result = await _repository.updateMosque(event.mosqueId, event.mosqueData);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FormStatus.submissionFailure,
        errorMessage: failure.message,
      )),
      (updatedMosque) => emit(state.copyWith(
        status: FormStatus.submissionSuccess,
        updatedMosque: updatedMosque,
      )),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'add_edit_center_event.dart';
part 'add_edit_center_state.dart';

class AddEditCenterBloc extends Bloc<AddEditCenterEvent, AddEditCenterState> {
  final SuperAdminRepository _repository;
  final int? centerId; // Store the ID for editing

  AddEditCenterBloc({required SuperAdminRepository repository, this.centerId})
      : _repository = repository,
        super(const AddEditCenterState()) {
    on<LoadCenterPrerequisites>(_onLoadPrerequisites);
    on<SubmitNewCenter>(_onSubmitNew);
    on<SubmitCenterUpdate>(_onSubmitUpdate);
  }

  Future<void> _onLoadPrerequisites(LoadCenterPrerequisites event, Emitter<AddEditCenterState> emit) async {
    emit(state.copyWith(status: FormStatus.loading));
    final managersResult = await _repository.getPotentialManagers();
    managersResult.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (managers) => emit(state.copyWith(status: FormStatus.loaded, potentialManagers: managers)),
    );
  }

  Future<void> _onSubmitNew(SubmitNewCenter event, Emitter<AddEditCenterState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await _repository.createCenter(event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> _onSubmitUpdate(SubmitCenterUpdate event, Emitter<AddEditCenterState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await _repository.updateCenter(centerId: centerId!, data: event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}

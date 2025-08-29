import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'add_edit_halaqa_event.dart';
part 'add_edit_halaqa_state.dart';

class AddEditHalaqaBloc extends Bloc<AddEditHalaqaEvent, AddEditHalaqaState> {
  final SuperAdminRepository repository;

  AddEditHalaqaBloc({required this.repository}) : super(const AddEditHalaqaState()) {
    on<LoadHalaqaPrerequisites>(_onLoadPrerequisites);
    on<CenterSelected>(_onCenterSelected);
    on<SubmitHalaqa>(_onSubmit);
     on<SubmitHalaqaUpdate>(_onSubmitUpdate);
  }

  Future<void> _onLoadPrerequisites(LoadHalaqaPrerequisites event, Emitter<AddEditHalaqaState> emit) async {
    emit(state.copyWith(status: FormStatus.loading));
    final centersResult = await repository.getCentersList();
    final typesResult = await repository.getHalaqaTypes();
    
    centersResult.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (centers) {
        typesResult.fold(
          (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
          (types) => emit(state.copyWith(status: FormStatus.loaded, centers: centers, halaqaTypes: types)),
        );
      },
    );
  }

  Future<void> _onCenterSelected(CenterSelected event, Emitter<AddEditHalaqaState> emit) async {
    emit(state.copyWith(status: FormStatus.loading, mosques: [])); // أفرغ قائمة المساجد القديمة
    final mosquesResult = await repository.getMosquesByCenter(event.centerId);
    mosquesResult.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (mosques) => emit(state.copyWith(status: FormStatus.loaded, mosques: mosques)),
    );
  }

  Future<void> _onSubmit(SubmitHalaqa event, Emitter<AddEditHalaqaState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    // هنا يمكنك التمييز بين الإضافة والتعديل
    final result = await repository.addHalaqa(event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
   Future<void> _onSubmitUpdate(SubmitHalaqaUpdate event, Emitter<AddEditHalaqaState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await repository.updateHalaqa(id: event.halaqaId, data: event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}

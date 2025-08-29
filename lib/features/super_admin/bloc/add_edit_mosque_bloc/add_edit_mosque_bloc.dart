import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'add_edit_mosque_event.dart';
part 'add_edit_mosque_state.dart';

class AddEditMosqueBloc extends Bloc<AddEditMosqueEvent, AddEditMosqueState> {
  final SuperAdminRepository repository;
  final MosqueModel? mosqueToEdit; // نحتفظ بالمسجد للتعديل

  AddEditMosqueBloc({required this.repository, this.mosqueToEdit})
      : super(AddEditMosqueState(initialData: mosqueToEdit)) {
    on<LoadMosquePrerequisites>(_onLoadPrerequisites);
    on<SubmitNewMosque>(_onSubmitNew);
    on<SubmitMosqueUpdate>(_onSubmitUpdate);
  }

  // ✅ 1. معالج الحدث الجديد
  Future<void> _onLoadPrerequisites(
    LoadMosquePrerequisites event,
    Emitter<AddEditMosqueState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.loading));
    // استدعاء الدالة من الـ Repository لجلب قائمة المراكز
    final centersResult = await repository.getCentersList();
    centersResult.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (centers) => emit(state.copyWith(
        status: FormStatus.loaded,
        availableCenters: centers.map((centerMap) => CenterModel.fromJson(centerMap)).toList(),
      )),
    );
  }

  Future<void> _onSubmitNew(SubmitNewMosque event, Emitter<AddEditMosqueState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await repository.addMosque(event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> _onSubmitUpdate(SubmitMosqueUpdate event, Emitter<AddEditMosqueState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await repository.updateMosque(id: mosqueToEdit!.id, data: event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}


import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'parts_event.dart';
part 'parts_state.dart';

class PartsBloc extends Bloc<PartsEvent, PartsState> {
  final SuperAdminRepository repository;

  PartsBloc({required this.repository}) : super(PartsInitial()) {
    on<LoadParts>(_onLoadParts);
    on<AddPart>(_onAddPart);
    on<UpdatePart>(_onUpdatePart);
    on<DeletePart>(_onDeletePart);
  }

  Future<void> _onLoadParts(
    LoadParts event,
    Emitter<PartsState> emit,
  ) async {
    emit(PartsLoading());
    final result = await repository.getParts();
    result.fold(
      (failure) => emit(PartsError(failure.message)),
      (parts) => emit(PartsLoaded(parts)),
    );
  }

  Future<void> _onAddPart(
    AddPart event,
    Emitter<PartsState> emit,
  ) async {
    emit(PartsLoading());
    final result = await repository.addPart(event.writing);
    result.fold(
      (failure) => emit(PartsError(failure.message)),
      (_) => add(LoadParts()),
    );
  }

  Future<void> _onUpdatePart(
    UpdatePart event,
    Emitter<PartsState> emit,
  ) async {
    emit(PartsLoading());
    final result = await repository.updatePart(event.id, event.writing);
    result.fold(
      (failure) => emit(PartsError(failure.message)),
      (_) => add(LoadParts()),
    );
  }

  Future<void> _onDeletePart(
    DeletePart event,
    Emitter<PartsState> emit,
  ) async {
    emit(PartsLoading());
    final result = await repository.deletePart(event.id);
    result.fold(
      (failure) => emit(PartsError(failure.message)),
      (_) => add(LoadParts()),
    );
  }
}
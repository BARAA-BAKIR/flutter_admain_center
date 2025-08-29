import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'center_managers_event.dart';
part 'center_managers_state.dart';

class CenterManagersBloc extends Bloc<CenterManagersEvent, CenterManagersState> {
  final SuperAdminRepository repository;

  CenterManagersBloc({required this.repository}) : super(CenterManagersInitial()) {
    on<LoadCenterManagers>(_onLoad);
    on<AddCenterManager>(_onAdd);
    on<UpdateCenterManager>(_onUpdate);
    on<DeleteCenterManager>(_onDelete);
  }

  Future<void> _onLoad(LoadCenterManagers event, Emitter<CenterManagersState> emit) async {
    emit(CenterManagersLoading());
    final result = await repository.getCenterManagers();
    result.fold(
      (failure) => emit(CenterManagersError(failure.message)),
      (managers) => emit(CenterManagersLoaded(managers)),
    );
  }

  Future<void> _onAdd(AddCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.addCenterManager(event.data);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }

  Future<void> _onUpdate(UpdateCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.updateCenterManager(id: event.id, data: event.data);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }

  Future<void> _onDelete(DeleteCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.deleteCenterManager(event.id);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }
}

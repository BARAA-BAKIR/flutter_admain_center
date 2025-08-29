import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'add_edit_manager_event.dart';
part 'add_edit_manager_state.dart';

class AddEditManagerBloc extends Bloc<AddEditManagerEvent, AddEditManagerState> {
  final SuperAdminRepository repository;

  AddEditManagerBloc({required this.repository}) : super(const AddEditManagerState()) {
    on<LoadManagerPrerequisites>(_onLoadPrerequisites);
    on<SubmitNewManager>(_onSubmitNew);
    on<SubmitManagerUpdate>(_onSubmitUpdate);
  }

  // Future<void> _onLoadPrerequisites(LoadManagerPrerequisites event, Emitter<AddEditManagerState> emit) async {
  //   emit(state.copyWith(status: FormStatus.loading));

  //   final result = await repository.getManagerPrerequisites();
  //   result.fold(
  //     (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
  //     (data) {
  //       emit(state.copyWith(
  //         status: FormStatus.loaded,
  //         potentialUsers: List<Map<String, dynamic>>.from(data['potential_users'] ?? []),
  //         unassignedCenters: List<Map<String, dynamic>>.from(data['unassigned_centers'] ?? []),
  //       ));
  //     },
  //   );
  // }

 Future<void> _onLoadPrerequisites(LoadManagerPrerequisites event, Emitter<AddEditManagerState> emit) async {
    emit(state.copyWith(status: FormStatus.loading));
    
    final result = await repository.getManagerPrerequisites();
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (data) {
        final potentialUsers = List<Map<String, dynamic>>.from(data['potential_users'] ?? []);
        final unassignedCentersData = List<Map<String, dynamic>>.from(data['unassigned_centers'] ?? []);

        // Use a Set to keep track of added center IDs to prevent duplicates.
        final Set<int> addedCenterIds = {};
        final List<Map<String, dynamic>> uniqueCenters = [];

        // 1. If editing a manager, add their current center first.
        // This gives it priority and ensures it's in the list.
        final manager = event.managerToEdit;
        if (manager != null && manager.centerId != null) {
          uniqueCenters.add({
            'id': manager.centerId,
            'name': manager.centerName ?? 'المركز الحالي',
          });
          addedCenterIds.add(manager.centerId!);
        }

        // 2. Add centers from the "unassigned" list, but only if they haven't been added already.
        for (final center in unassignedCentersData) {
          final centerId = center['id'] as int?;
          if (centerId != null && !addedCenterIds.contains(centerId)) {
            uniqueCenters.add(center);
            addedCenterIds.add(centerId);
          }
        }

        emit(state.copyWith(
          status: FormStatus.loaded,
          potentialUsers: potentialUsers,
          unassignedCenters: uniqueCenters, // Emit the guaranteed unique list
        ));
      },
    );
  }
  Future<void> _onSubmitNew(SubmitNewManager event, Emitter<AddEditManagerState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await repository.addCenterManager(event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> _onSubmitUpdate(SubmitManagerUpdate event, Emitter<AddEditManagerState> emit) async {
    emit(state.copyWith(status: FormStatus.submitting));
    final result = await repository.updateCenterManager(id: event.managerId, data: event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}

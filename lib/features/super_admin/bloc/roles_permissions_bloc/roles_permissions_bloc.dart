import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'roles_permissions_event.dart';
part 'roles_permissions_state.dart';

class RolesPermissionsBloc extends Bloc<RolesEvent, RolesState> {
  final SuperAdminRepository _repository;

  RolesPermissionsBloc({required SuperAdminRepository repository})
      : _repository = repository,
        super(const RolesState()) {
    on<LoadRolesAndPermissions>(_onLoad);
    on<SyncPermissions>(_onSync);
  }

  Future<void> _onLoad(LoadRolesAndPermissions event, Emitter<RolesState> emit) async {
    emit(state.copyWith(status: RolesStatus.loading));
    final rolesResult = await _repository.getRoles();
    final permissionsResult = await _repository.getPermissions();

    List<Role>? roles;
    Map<String, List<Permission>>? permissions;
    String? error;

    rolesResult.fold((l) => error = l.message, (r) => roles = r);
    if (error != null) {
      emit(state.copyWith(status: RolesStatus.failure, errorMessage: error));
      return;
    }

    permissionsResult.fold((l) => error = l.message, (r) => permissions = r);
    if (error != null) {
      emit(state.copyWith(status: RolesStatus.failure, errorMessage: error));
      return;
    }

    emit(state.copyWith(
      status: RolesStatus.success,
      roles: roles,
      permissions: permissions,
    ));
  }

  Future<void> _onSync(SyncPermissions event, Emitter<RolesState> emit) async {
    emit(state.copyWith(status: RolesStatus.submitting));
    final result = await _repository.syncPermissionsToRole(roleId: event.roleId, permissionIds: event.permissionIds);
    result.fold(
      (failure) => emit(state.copyWith(status: RolesStatus.failure, errorMessage: failure.message)),
      (_) => add(LoadRolesAndPermissions()),
    );
  }
}

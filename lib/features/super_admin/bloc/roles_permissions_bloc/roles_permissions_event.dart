part of 'roles_permissions_bloc.dart';

abstract class RolesEvent extends Equatable {
  const RolesEvent();
  @override
  List<Object> get props => [];
}

class LoadRolesAndPermissions extends RolesEvent {}

class SyncPermissions extends RolesEvent {
  final int roleId;
  final List<int> permissionIds;
  const SyncPermissions({required this.roleId, required this.permissionIds});
}

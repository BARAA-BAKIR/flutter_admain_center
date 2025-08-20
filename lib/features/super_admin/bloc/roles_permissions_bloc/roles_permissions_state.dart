part of 'roles_permissions_bloc.dart';

enum RolesStatus { initial, loading, success, failure, submitting }

class RolesState extends Equatable {
  final RolesStatus status;
  final List<Role> roles;
  final Map<String, List<Permission>> permissions;
  final String? errorMessage;

  const RolesState({
    this.status = RolesStatus.initial,
    this.roles = const [],
    this.permissions = const {},
    this.errorMessage,
  });

  RolesState copyWith({
    RolesStatus? status,
    List<Role>? roles,
    Map<String, List<Permission>>? permissions,
    String? errorMessage,
  }) {
    return RolesState(
      status: status ?? this.status,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, roles, permissions, errorMessage];
}

import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';

class Role extends Equatable {
  final int id;
  final String name;
  final List<Permission> permissions;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    var permissionsList = json['permissions'] as List? ?? [];
    List<Permission> perms = permissionsList.map((p) => Permission.fromJson(p)).toList();
    
    return Role(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      permissions: perms,
    );
  }

  @override
  List<Object?> get props => [id, name, permissions];
}

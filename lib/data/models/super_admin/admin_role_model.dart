import 'package:equatable/equatable.dart';

class AdminRoleModel extends Equatable {
  final int id;
  final String administrativeRole;
  final String status;

  const AdminRoleModel({
    required this.id,
    required this.administrativeRole,
    required this.status,
  });

  factory AdminRoleModel.fromJson(Map<String, dynamic> json) {
    return AdminRoleModel(
      id: json['id'],
      administrativeRole: json['administrative_role'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, administrativeRole, status];
}

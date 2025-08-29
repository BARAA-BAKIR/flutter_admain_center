import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/employee_profile_model.dart';

class UserProfileModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final EmployeeProfileModel? employee;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.employee,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      employee: json['employee'] != null
          ? EmployeeProfileModel.fromJson(json['employee'])
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, email, employee];
}

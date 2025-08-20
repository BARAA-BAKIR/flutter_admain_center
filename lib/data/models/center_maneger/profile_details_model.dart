// في lib/data/models/profile_details_model.dart

import 'package:equatable/equatable.dart';

class ProfileDetailsModel extends Equatable {
  // بيانات المستخدم الأساسية
  final int userId;
  final String name;
  final String email;
  final String userStatus;

  // بيانات الموظف (قد تكون null)
  final int? employeeId;
  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? motherName;
  final String? phoneNumber;
  final String? address;
  final String? educationLevel;
  final String? startDate;
  final String? centerName;

  // بيانات المدير (قد تكون null)
  final int? adminId;
  final String? adminType; // (مثال: 'مدير إداري')

  const ProfileDetailsModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.userStatus,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.motherName,
    this.phoneNumber,
    this.address,
    this.educationLevel,
    this.startDate,
    this.centerName,
    this.adminId,
    this.adminType,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    final employeeData = json['employee'];
    final adminData = employeeData?['employee_admin'];
    final centerData = employeeData?['center'];

    return ProfileDetailsModel(
      userId: json['id'] ?? 0,
      name: json['name'] ?? 'غير متوفر',
      email: json['email'] ?? 'غير متوفر',
      userStatus: json['status'] ?? 'غير معروف',
      employeeId: employeeData?['id'],
      firstName: employeeData?['first_name'],
      lastName: employeeData?['last_name'],
      fatherName: employeeData?['father_name'],
      motherName: employeeData?['mother_name'],
      phoneNumber: employeeData?['phone_number'],
      address: employeeData?['address'],
      educationLevel: employeeData?['education_level'],
      startDate: employeeData?['start_date'],
      centerName: centerData?['name'],
      adminId: adminData?['id'],
      adminType: adminData?['type'],
    );
  }

  @override
  List<Object?> get props => [userId, name, email, employeeId, adminId];
}

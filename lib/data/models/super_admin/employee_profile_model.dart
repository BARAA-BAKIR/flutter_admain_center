import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/admin_role_model.dart';

class EmployeeProfileModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String educationLevel;
  final String address;
  final String phoneNumber;
  final String documentNumber; // <-- حقل مضاف
  final String gender;         // <-- حقل مضاف
  final AdminRoleModel? employeeadmin;

  const EmployeeProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.address,
    required this.phoneNumber,
    required this.documentNumber,
    required this.gender,
    this.employeeadmin,
  });

  factory EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      educationLevel: json['education_level'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      documentNumber: json['document_number'] ?? '', // <-- حقل مضاف
      gender: json['gender'] ?? '',                 // <-- حقل مضاف
      employeeadmin: json['employeeadmin'] != null
          ? AdminRoleModel.fromJson(json['employeeadmin'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id, firstName, lastName, fatherName, motherName, birthDate,
        educationLevel, address, phoneNumber, documentNumber, gender, employeeadmin
      ];
}

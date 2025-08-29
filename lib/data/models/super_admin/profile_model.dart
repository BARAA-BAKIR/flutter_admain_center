
import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final int notificationsEnabled;
  final EmployeeProfile? employee;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.notificationsEnabled,
    this.employee,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      notificationsEnabled: json['notifications_enabled'] ?? true,
      employee: json['employee'] != null ? EmployeeProfile.fromJson(json['employee']) : null,
    );
  }

  @override
  List<Object?> get props => [id, name, email, notificationsEnabled, employee];
}

class EmployeeProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String educationLevel;
  final String startDate;
  final String? documentNumber;
  final String? gender;
  final String? address;
  final double? salary;

  const EmployeeProfile({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.startDate,
    this.documentNumber,
    this.gender,
    this.address,
    this.salary,
  });

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'],
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      educationLevel: json['education_level'] ?? '',
      startDate: json['start_date'] ?? '',
      documentNumber: json['document_number'],
      gender: json['gender'],
      address: json['address'],
      salary: (json['salary'] != null) ? (json['salary'] as num).toDouble() : null,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    fatherName,
    motherName,
    birthDate,
    educationLevel,
    startDate,
    documentNumber,
    gender,
    address,
    salary,
  ];
}



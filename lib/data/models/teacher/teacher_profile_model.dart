// class TeacherProfile {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String fatherName;
//   final String motherName;
//   final String birthDate;
//   final String educationLevel;
//   final String startDate;
//   final String phoneNumber;
//   final String address;
//   final String email;

//   TeacherProfile({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.fatherName,
//     required this.motherName,
//     required this.birthDate,
//     required this.educationLevel,
//     required this.startDate,
//     required this.phoneNumber,
//     required this.address,
//     required this.email,
//   });

//   factory TeacherProfile.fromJson(Map<String, dynamic> json) {
//     return TeacherProfile(
//       id: json['id'],
//       firstName: json['first_name'] as String? ?? '',
//       lastName: json['last_name'] as String? ?? '',
//       fatherName: json['father_name'] as String? ?? '',
//       motherName: json['mother_name'] as String? ?? '',
//       birthDate: json['birth_date'] as String? ?? '',
//       educationLevel: json['education_level'] as String? ?? '',
//       startDate: json['start_date'] as String? ?? '',
//       phoneNumber: json['phone_number'] as String? ?? '',
//       address: json['address'] as String? ?? '',
//       email: json['email'] as String? ?? '',
//     );
//   }
// }
// In lib/data/models/teacher/teacher_profile_model.dart

import 'package:equatable/equatable.dart';

class TeacherProfile extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String? fatherName;
  final String? motherName;
  final DateTime? birthDate;
  final String? educationLevel;
  final String gender;
  final String phoneNumber;
  final String? address;
  final String centerName;
  final String? halaqaName;

  final DateTime? startDate;

  const TeacherProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.startDate,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.educationLevel,
    required this.gender,
    required this.phoneNumber,
    this.address,
    required this.centerName,
    this.halaqaName,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      birthDate: json['birth_date'] != null ? DateTime.tryParse(json['birth_date']) : null,
      educationLevel: json['education_level'],
      gender: json['gender'] ?? 'غير محدد',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'],
      centerName: json['center_name'] ?? 'غير محدد',
      halaqaName: json['halaqa_name'],
    );
  }

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        fatherName,
        motherName,
        birthDate,
        educationLevel,
        gender,
        phoneNumber,
        address,
        centerName,
        halaqaName,
      ];
}

// lib/data/models/center_maneger/teacher_details_model.dart
import 'package:equatable/equatable.dart';

class TeacherDetailsModel extends Equatable {
  final int teacherId;
  final int employeeId;
  final int userId;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String phoneNumber;
  final String email;

  const TeacherDetailsModel({
    required this.teacherId,
    required this.employeeId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.phoneNumber,
    required this.email,
  });

  factory TeacherDetailsModel.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'] ?? {};
    final user = employee['user'] ?? {};
    return TeacherDetailsModel(
      teacherId: json['id'],
      employeeId: employee['id'],
      userId: user['id'],
      firstName: employee['first_name'] ?? '',
      lastName: employee['last_name'] ?? '',
      fatherName: employee['father_name'] ?? '',
      motherName: employee['mother_name'] ?? '',
      phoneNumber: employee['phone_number'] ?? '',
      email: user['email'] ?? '',
    );
  }
  
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [teacherId, firstName, lastName, email];
}

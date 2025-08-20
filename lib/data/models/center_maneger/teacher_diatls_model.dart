// lib/data/models/center_maneger/teacher_details_model.dart
import 'package:equatable/equatable.dart';

class TeacherDetailsModel extends Equatable {
  // --- معلومات من جدول Teacher ---
  final int teacherId;
  final int memorizedParts;
  final String status;

  // --- معلومات من جدول Employee ---
  final int employeeId;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String? birthDate;
  final String educationLevel;
  final String? startDate;
  final String documentNumber;
  final String gender;
  final String phoneNumber;
  final String address;

  // --- معلومات من جدول User ---
  final int userId;
  final String email;

  const TeacherDetailsModel({
    // Teacher
    required this.teacherId,
    required this.memorizedParts,
    required this.status,
    // Employee
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    this.birthDate,
    required this.educationLevel,
    this.startDate,
    required this.documentNumber,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    // User
    required this.userId,
    required this.email,
  });

  // --- الإصلاح الجذري هنا ---
  factory TeacherDetailsModel.fromJson(Map<String, dynamic> json) {
    // نقوم بتعريف الكائنات المتداخلة لتسهيل القراءة وتجنب الأخطاء
    final employee = json['employee'] as Map<String, dynamic>? ?? {};
    final user = employee['user'] as Map<String, dynamic>? ?? {};

    return TeacherDetailsModel(
      // --- قراءة بيانات Teacher ---
      teacherId: json['id'] ?? 0,
      memorizedParts: json['memorized_parts'] ?? 0,
      status: json['status'] ?? 'غير معروف',

      // --- قراءة بيانات Employee ---
      employeeId: employee['id'] ?? 0,
      firstName: employee['first_name'] ?? '',
      lastName: employee['last_name'] ?? '',
      fatherName: employee['father_name'] ?? '',
      motherName: employee['mother_name'] ?? '',
      birthDate: employee['birth_date'], // قد يكون null
      educationLevel: employee['education_level'] ?? '',
      startDate: employee['start_date'], // قد يكون null
      documentNumber: employee['document_number'] ?? '',
      gender: employee['gender'] ?? '',
      phoneNumber: employee['phone_number'] ?? '',
      address: employee['address'] ?? '',

      // --- قراءة بيانات User ---
      userId: user['id'] ?? 0,
      email: user['email'] ?? '',
    );
  }

  // دالة مساعدة للحصول على الاسم الكامل
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        teacherId,
        employeeId,
        userId,
        firstName,
        lastName,
        email,
        phoneNumber
      ];
}

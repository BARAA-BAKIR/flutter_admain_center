// lib/data/models/registration_model.dart

class RegistrationModel {
  // --- بيانات جدول users ---
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation; // Laravel's 'confirmed' rule needs this

  // --- بيانات جدول employees ---
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate; // سنرسله كنص YYYY-MM-DD
  final String educationLevel;
  final String startDate; // سنرسله كنص YYYY-MM-DD
  final int centerId;
  final double salary;
  final String documentNumber;
  final String gender;
  final String phone;
  final String address;

  // --- بيانات جدول teachers ---
  final int memorizedParts;

  RegistrationModel({
    // User
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    // Employee
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.startDate,
    required this.centerId,
    required this.salary,
    required this.documentNumber,
    required this.gender,
    required this.phone,
    required this.address,
    // Teacher
    required this.memorizedParts,
  });

  // دالة لتحويل النموذج إلى Map (JSON) لإرساله إلى الـ API
  // الآن أسماء الحقول هنا تطابق تماماً ما يتوقعه الـ API في Laravel
  Map<String, dynamic> toJson() {
    return {
      // User data
      'name':name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,

      // Employee data
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_name': motherName,
      'birth_date': birthDate,
      'education_level': educationLevel,
      'start_date': startDate,
      'center_id': centerId,
      'salary': salary,
      'document_number': documentNumber,
      'gender': gender,
      'phone_number': phone, // اسم الحقل في Laravel هو phone_number
      'address': address,

      // Teacher data
      'memorized_parts': memorizedParts,
    };
  }
}

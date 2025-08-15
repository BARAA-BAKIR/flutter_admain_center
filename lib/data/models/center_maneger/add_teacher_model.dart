// lib/data/models/center_maneger/add_teacher_model.dart
import 'package:equatable/equatable.dart';

class AddTeacherModel extends Equatable {
  // حقول جدول users
  final String email;
  final String password;
  // حقول جدول employees
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String educationLevel;
  final String startDate;
  final String documentNumber;
  final String gender;
  final String phoneNumber;
  final String address;
  // حقول جدول teachers
  final int memorizedParts;

  const AddTeacherModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.startDate,
    required this.documentNumber,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.memorizedParts,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_name': motherName,
      'birth_date': birthDate,
      'education_level': educationLevel,
      'start_date': startDate,
      'document_number': documentNumber,
      'gender': gender,
      'phone_number': phoneNumber,
      'address': address,
      'memorized_parts': memorizedParts,
    };
  }
  

  @override
  List<Object?> get props => [email, phoneNumber, documentNumber];
}

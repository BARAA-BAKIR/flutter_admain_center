import 'package:equatable/equatable.dart';

class Halaqan extends Equatable {
  final int id;
  final String name;
  const Halaqan({required this.id, required this.name});
  factory Halaqan.fromJson(Map<String, dynamic> json) => Halaqan(id: json['id'], name: json['name']);
  @override
  List<Object?> get props => [id, name];
}

class Level extends Equatable {
  final int id;
  final String name;
  const Level({required this.id, required this.name});
  factory Level.fromJson(Map<String, dynamic> json) => Level(id: json['id'], name: json['name']);
  @override
  List<Object?> get props => [id, name];
}

class StudentDetails extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String? fatherName;
  final String? motherName;
  final String? birthDate;
  final String? gender;
  final String? socialStatus;
  final String? educationaLevel;
  final String? healthStatus;
  final String? phone;
  final Halaqan? halaqan;
  final Level? level;

  const StudentDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.gender,
    this.socialStatus,
    this.educationaLevel,
    this.healthStatus,
    this.phone,
    this.halaqan,
    this.level,
  });

  String get fullName => '$firstName $lastName';

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    final progress = json['latest_student_progress'];
    return StudentDetails(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      socialStatus: json['social_status'],
      educationaLevel: json['educationa_level'],
      healthStatus: json['health_status'],
      phone: json['contact_number'],
      halaqan: progress != null && progress['halaqan'] != null ? Halaqan.fromJson(progress['halaqan']) : null,
      level: progress != null && progress['level'] != null ? Level.fromJson(progress['level']) : null,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, fatherName, motherName, birthDate, gender, socialStatus, educationaLevel, healthStatus, phone, halaqan, level];
}

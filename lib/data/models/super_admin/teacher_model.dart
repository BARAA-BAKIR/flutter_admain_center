import 'dart:convert';

class Teacher {
  final int id; // Teacher ID
  final String fullName;
  final String? centerName;
  final String? phoneNumber;
  final String? email;
  final String? status;

  // Detailed fields for the edit screen
  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? motherName;
  final DateTime? birthDate;
  final String? gender;
  final String? address;
  final String? educationLevel;
  final DateTime? startDate;
  final int? centerId;
  final int memorizedParts;
  final String? documentNumber; // ✅ إصلاح: إضافة الحقل الناقص
  final double? salary;        // ✅ إصلاح: إضافة الحقل الناقص

  Teacher({
    required this.id,
    required this.fullName,
    this.centerName,
    this.phoneNumber,
    this.email,
    this.status,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.gender,
    this.address,
    this.educationLevel,
    this.startDate,
    this.centerId,
    required this.memorizedParts,
    this.documentNumber,
    this.salary,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse dates
    DateTime? _parseDate(String? dateStr) {
      return dateStr == null ? null : DateTime.tryParse(dateStr);
    }
 double? _parseSalary(dynamic salaryValue) {
      if (salaryValue == null) return null;
      if (salaryValue is num) return salaryValue.toDouble(); // إذا كان رقمًا بالفعل
      if (salaryValue is String) return double.tryParse(salaryValue); // إذا كان نصًا
      return null; // في الحالات الأخرى
    }
    // The API response nests employee and user data inside the teacher object
    final employee = json['employee'] as Map<String, dynamic>?;
    final user = employee?['user'] as Map<String, dynamic>?;
    final center = employee?['center'] as Map<String, dynamic>?;

    return Teacher(
      id: json['id'],
      status: json['status'],
      memorizedParts: json['memorized_parts'] ?? 0,
      
      // Data from nested employee object
      firstName: employee?['first_name'],
      lastName: employee?['last_name'],
      fatherName: employee?['father_name'],
      motherName: employee?['mother_name'],
      phoneNumber: employee?['phone_number'],
      address: employee?['address'],
      educationLevel: employee?['education_level'],
      gender: employee?['gender'],
      birthDate: _parseDate(employee?['birth_date']),
      startDate: _parseDate(employee?['start_date']),
      documentNumber: employee?['document_number'], // ✅ إصلاح: قراءة الحقل
     salary: _parseSalary(employee?['salary']),

      // Data from nested user object
      email: user?['email'],
      
      // Data from nested center object
      centerName: center?['name'],
      centerId: center?['id'],

      // Assembled full name
      fullName: user?['name'] ?? '${employee?['first_name'] ?? ''} ${employee?['last_name'] ?? ''}'.trim(),
    );
  }

  static List<Teacher> fromJsonList(String jsonString) {
    final data = jsonDecode(jsonString) as List;
    return data.map((item) => Teacher.fromJson(item as Map<String, dynamic>)).toList();
  }
}

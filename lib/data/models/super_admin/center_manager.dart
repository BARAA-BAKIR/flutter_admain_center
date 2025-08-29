import 'package:equatable/equatable.dart';

class CenterManagerModel extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? centerName;
  final int? centerId; // ✅ 1. إضافة الحقل الجديد هنا
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate;
  final String educationLevel;
  final String startDate;
  final String? documentNumber;
  final String? gender;
  final String? phoneNumber;
  final String? address;
  final double? salary;

  const CenterManagerModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.centerName,
    this.centerId, // ✅ 2. إضافته إلى الكونستركتور
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.educationLevel,
    required this.startDate,
    this.documentNumber,
    this.gender,
    this.phoneNumber,
    this.address,
    this.salary,
  });

  factory CenterManagerModel.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'];
    final employeeAdmin = employee?['employeeadmin'];
    
    // ✅ 3. استخراج البيانات من الـ JSON
    final centerData = employeeAdmin?['centern'];

    return CenterManagerModel(
      id: json['id'],
      fullName: json['name'],
      email: json['email'],
      centerName: centerData?['name'], // اسم المركز
      centerId: centerData?['id'],     // ✅ رقم المركز
      firstName: employee?['first_name'] ?? '',
      lastName: employee?['last_name'] ?? '',
      fatherName: employee?['father_name'] ?? '',
      motherName: employee?['mother_name'] ?? '',
      birthDate: employee?['birth_date'] ?? '',
      educationLevel: employee?['education_level'] ?? '',
      startDate: employee?['start_date'] ?? '',
      documentNumber: employee?['document_number'],
      gender: employee?['gender'],
      phoneNumber: employee?['phone_number'],
      address: employee?['address'],
      salary: employee?['salary'] != null ? double.tryParse(employee['salary'].toString()) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        centerName,
        centerId, // ✅ 4. إضافته إلى props
        firstName,
        lastName,
        fatherName,
        motherName,
        birthDate,
        educationLevel,
        startDate,
        documentNumber,
        gender,
        phoneNumber,
        address,
        salary,
      ];
}

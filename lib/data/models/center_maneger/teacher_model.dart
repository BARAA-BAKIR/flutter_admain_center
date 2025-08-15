// lib/data/models/center_maneger/teacher_model.dart

import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int id;
  final String fullName;
  final String? email;
  final String? phoneNumber;

  const Teacher({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // ✅ 1. تحقق من وجود 'employee' قبل استخدامه
    final employeeData = json['employee'] as Map<String, dynamic>?;
    
    // ✅ 2. بناء الاسم بأمان
    final firstName = employeeData?['first_name'] as String? ?? '';
    final lastName = employeeData?['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    // ✅ 3. جلب البريد الإلكتروني بأمان من 'user' المتداخل
    final userData = employeeData?['user'] as Map<String, dynamic>?;
    final email = userData?['email'] as String?;

    return Teacher(
      id: json['id'] as int, // تأكد من أن الـ ID هو int
      fullName: fullName.isEmpty ? 'اسم غير محدد' : fullName,
      email: email,
      phoneNumber: employeeData?['phone_number'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber];
}

import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int id;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? centerName;
  final String status;

  const Teacher({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.centerName,
    required this.status,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'] ?? {};
    final user = employee['user'] ?? {};
    final center = employee['center'] ?? {};

    return Teacher(
      id: json['id'],
      fullName: '${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}'.trim(),
      email: user['email'],
      phoneNumber: employee['phone_number'],
      centerName: center['name'],
      status: json['status'] ?? 'N/A',
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber, centerName, status];
}

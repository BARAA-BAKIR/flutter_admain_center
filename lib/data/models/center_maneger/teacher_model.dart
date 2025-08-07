import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;

  const Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // استخراج البيانات من العلاقات المتداخلة بشكل آمن
    final employee = json['employee'];
    final user = employee != null ? employee['user'] : null;

    return Teacher(
      id: json['id'],
      firstName: employee != null ? employee['first_name'] ?? '' : '',
      lastName: employee != null ? employee['last_name'] ?? '' : '',
      phoneNumber: employee != null ? employee['phone_number'] : 'غير متوفر',
      email: user != null ? user['email'] : 'غير متوفر',
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, phoneNumber, email];
}

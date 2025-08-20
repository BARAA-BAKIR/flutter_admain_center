import 'package:equatable/equatable.dart';

class StudentListItem extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String? halaqaName;
  final String? centerName; // ✅ تم إضافة اسم المركز

  const StudentListItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.halaqaName,
    this.centerName, // ✅ تم إضافته للمنشئ
  });

  String get fullName => '$firstName $lastName'.trim();

  factory StudentListItem.fromJson(Map<String, dynamic> json) {
    // Safely access nested data
    final progress = json['student_progress'];
    final halaqa = progress != null ? progress['halaqa'] : null;
    final mosque = halaqa != null ? halaqa['mosque'] : null;
    final center = mosque != null ? mosque['center'] : null;

    return StudentListItem(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      halaqaName: halaqa != null ? halaqa['name'] : 'بلا حلقة',
      centerName: center != null ? center['name'] : 'بلا مركز', // ✅ جلب اسم المركز
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, halaqaName, centerName];
}

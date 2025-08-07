import 'package:equatable/equatable.dart';

// موديل مصغر للحلقة لتجنب التعقيد
class HalaqaInfo extends Equatable {
  final int id;
  final String name;

  const HalaqaInfo({required this.id, required this.name});

  factory HalaqaInfo.fromJson(Map<String, dynamic> json) {
    return HalaqaInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير محدد',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Student extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final HalaqaInfo? halaqa; // الحلقة التي ينتمي إليها الطالب

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.halaqa,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      // تحقق من وجود بيانات الحلقة قبل تحليلها
      halaqa: json['halaqa'] != null ? HalaqaInfo.fromJson(json['halaqa']) : null,
    );
  }

  // Getter للحصول على الاسم الكامل بسهولة
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, halaqa];
}

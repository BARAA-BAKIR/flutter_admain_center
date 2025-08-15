// import 'package:equatable/equatable.dart';

// // مودل بسيط لتمثيل الحلقة
// class Halaqa extends Equatable {
//   final int id;
//   final String name;
//   const Halaqa({required this.id, required this.name});

//   factory Halaqa.fromJson(Map<String, dynamic> json) {
//     return Halaqa(id: json['id'], name: json['name'] ?? 'اسم غير محدد');
//   }

//   @override
//   List<Object?> get props => [id, name];
// }

// // مودل بسيط لتمثيل المرحلة
// class Level extends Equatable {
//   final int id;
//   final String name;
//   const Level({required this.id, required this.name});

//   factory Level.fromJson(Map<String, dynamic> json) {
//     return Level(id: json['id'], name: json['name'] ?? 'اسم غير محدد');
//   }

//   @override
//   List<Object?> get props => [id, name];
// }

// // ==================== مودل الطالب الرئيسي والمكتمل ====================
// class Student extends Equatable {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String? halaqaName;
//   final String? fatherName;
//   final String? motherName;
//   final String? birthDate;
//   final String? gender;
//   final String? socialStatus;
//   final String? educationaLevel;
//   final String? healthStatus;
//   final String? phone;
//   final Halaqa? halaqa;
//   final Level? level;

//   const Student({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//      this.halaqaName,
//     this.fatherName,
//     this.motherName,
//     this.birthDate,
//     this.gender,
//     this.socialStatus,
//     this.educationaLevel,
//     this.healthStatus,
//     this.phone,
//     this.halaqa,
//     this.level,
//   });

//   String get fullName => '$firstName $lastName';

//   factory Student.fromJson(Map<String, dynamic> json) {
//     final progress = json['latest_student_progress'];

//     return Student(
//       id: json['id'],
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//        halaqaName: json['halaqa_name'],
//       fatherName: json['father_name'],
//       motherName: json['mother_name'],
//       birthDate: json['birth_date'],
//       gender: json['gender'],
//       socialStatus: json['social_status'],
//       educationaLevel: json['educationa_level'],
//       healthStatus: json['health_status'],
//       phone: json['contact_number'],
//       halaqa: progress != null && progress['halaqa'] != null
//           ? Halaqa.fromJson(progress['halaqa'])
//           : null,
//       level: progress != null && progress['level'] != null
//           ? Level.fromJson(progress['level'])
//           : null,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         firstName,
//         lastName,
//         fatherName,
//         motherName,
//         birthDate,
//         gender,
//         socialStatus,
//         educationaLevel,
//         healthStatus,
//         phone,
//         halaqa,
//         level
//       ];
// }

// lib/data/models/myhalaqa_model.dart
import 'package:flutter_admain_center/data/models/teacher/student_model.dart';

class MyhalaqaModel {
  final int idhalaqa;
  final String namehalaqa;
  final int countstudent;
  final List<Student> students;

  MyhalaqaModel({
    required this.idhalaqa,
    required this.namehalaqa,
    required this.countstudent,
    required this.students,
  });

  // --- هذه هي الدالة التي سنقوم بإصلاحها ---
  factory MyhalaqaModel.fromJson(Map<String, dynamic> json) {
    // 1. تحويل قائمة الطلاب بأمان
    var studentList = <Student>[];
    // تحقق أولاً من وجود الحقل وأنه قائمة بالفعل
    if (json['students'] != null && json['students'] is List) {
      studentList =
          (json['students'] as List)
              .map((studentJson) => Student.fromJson(studentJson))
              .toList();
    }

    return MyhalaqaModel(
      idhalaqa: json['id'] ?? 0,
      namehalaqa: json['halaqa_name'] ??  'غير محددة',
      countstudent: json['student_count']  ?? 0,
      students: studentList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idhalaqa,
      'halaqa_name': namehalaqa,
      'student_count': countstudent,
      // تحويل كل طالب في القائمة إلى JSON
      'students': students.map((student) => student.toJson()).toList(),
    };
  }

  // دالة copyWith مهمة للـ Bloc (تأكد من وجودها)
  MyhalaqaModel copyWith({
    int? idhalaqa,
    String? namehalaqa,
    int? countstudent,
    List<Student>? students,
  }) {
    return MyhalaqaModel(
      idhalaqa: idhalaqa ?? this.idhalaqa,
      namehalaqa: namehalaqa ?? this.namehalaqa,
      countstudent: countstudent ?? this.countstudent,
      students: students ?? this.students,
    );
  }
}

// lib/data/models/student_model.dart

// تأكد من وجود هذا الـ enum
enum AttendanceStatus {
  pending,
  present,
  absent,
}

class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
   bool hasTodayFollowUp;
  AttendanceStatus attendanceStatus;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    this.hasTodayFollowUp = false,
    this.attendanceStatus = AttendanceStatus.pending,
  });

  // =================================================================
  // --- هذا هو الجزء الذي سنقوم بتعديله ---
  // =================================================================
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      // **هذا هو السطر الذي يحل المشكلة على الأغلب**
      // إذا كانت قيمة 'id' هي null، استخدم 0 كقيمة افتراضية.
      id: json['id'] ?? 0,
      
      // تحصين باقي الحقول النصية أيضاً للأمان
      firstName: json['first_name'] ?? 'اسم غير معروف',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'] ?? '',
    );
  }
  // =================================================================

  // دالة لتحويل الكائن إلى JSON (مفيدة للحفظ أو الإرسال)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
    };
  }

  // دالة نسخ الكائن (مهمة جداً للـ BLoC)
  Student copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? fatherName,
     bool? hasTodayFollowUp,
    AttendanceStatus? attendanceStatus,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fatherName: fatherName ?? this.fatherName,
      hasTodayFollowUp: hasTodayFollowUp ?? this.hasTodayFollowUp,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
    );
  }
}

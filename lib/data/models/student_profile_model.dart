import 'package:flutter_admain_center/data/models/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/duty_model.dart';

// موديل للإحصائيات
class ProfileStats {
  final double monthlyMemorizationAvg;
  final double monthlyReviewAvg;
  final int presentCount;
  final int absentCount;

  ProfileStats({
    required this.monthlyMemorizationAvg,
    required this.monthlyReviewAvg,
    required this.presentCount,
    required this.absentCount,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      monthlyMemorizationAvg: (json['monthly_memorization_avg'] ?? 0.0).toDouble(),
      monthlyReviewAvg: (json['monthly_review_avg'] ?? 0.0).toDouble(),
      presentCount: json['attendance_present_count'] ?? 0,
      absentCount: json['attendance_absent_count'] ?? 0,
    );
  }
}
class studentProfile{
  final int id;
   final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String birthDate; // YYYY-MM-DD
  final String gender;
  final String phone;
  final String social_status;
  final String educationaLevel;
  final String healthStatus;

  studentProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.birthDate,
    required this.gender,
    required this.phone,
    required this.social_status,
    required this.educationaLevel,
    required this.healthStatus,
  });

  factory studentProfile.fromJson(Map<String, dynamic> json) {
    return studentProfile(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      birthDate: json['birth_date'] ?? 'غير محدد',
      gender: json['gender'] ?? 'غير محدد',
      phone: json['phone'] ?? 'غير متوفر',
      social_status: json['social_status'] ?? 'غير محدد',
      educationaLevel: json['educationa_level'] ?? 'غير محدد',
      healthStatus: json['health_status'] ?? 'غير محدد',
    );
  }
}
// الموديل الرئيسي الذي يجمع كل شيء
class StudentProfileModel {
  final studentProfile studentDetails;
  final List<DailyFollowUpModel> trackings;
  final DutyModel? duty;
  final ProfileStats stats;

  StudentProfileModel({
    required this.studentDetails,
    required this.trackings,
    this.duty,
    required this.stats,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      // نستخدم الموديل الجديد والمفصل
      studentDetails: studentProfile.fromJson(json['details']),
      
      // نستدعي fromJson من مودل المتابعة
      trackings: (json['trackings'] as List<dynamic>)
          .map((item) => DailyFollowUpModel.fromJson(item)) // <-- تم التصحيح
          .toList(),
          
      // نستدعي fromJson من مودل الواجب
      // الواجب موجود داخل 'details' لأننا استخدمنا with() في لارافل
      duty: json['details']['duty'] != null 
          ? DutyModel.fromJson(json['details']['duty']) // <-- تم التصحيح
          : null,
          
      // لا تغيير هنا
      stats: ProfileStats.fromJson(json['stats']),
    );
  }
}

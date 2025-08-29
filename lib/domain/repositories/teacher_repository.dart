// lib/domain/repositories/teacher_repository.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/data/models/teacher/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:flutter_admain_center/data/models/teacher/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_profile_model.dart';
import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart';

abstract class TeacherRepository {
  // --- دوال جلب البيانات ---
  Future<Either<Failure, MyhalaqaModel?>> getMyHalaqaWithLocalData();
  Future<Either<Failure, StudentProfileModel>> getStudentProfile(int studentId);
  Future<Either<Failure, HalaqaModel>> fetchHalaqaInfo(int halaqaId);
  Future<Either<Failure, List<LevelModel>>> getLevels();
  Future<Either<Failure, DashboardModel>> getDashboardSummary({required int halaqaId});
  Future<Either<Failure, Map<String, dynamic>>> getFollowUpAndDutyForStudent(int studentId, String date);

  // --- دوال الحفظ والمزامنة ---
  Future<Either<Failure, bool>> storeFollowUpAndDuty(
    DailyFollowUpModel followUp,
    DutyModel duty,
  );
  Future<Either<Failure, void>> syncAllUnsyncedData();

  // --- دوال إضافة طالب ---
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required String token,
    required AddStudentModel studentData,
  });

 // دالة لجلب الملف الشخصي للمعلم
  Future<Either<Failure, TeacherProfile>> getTeacherProfile();
  
  // دالة لتحديث الملف الشخصي للمعلم
  // Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
  //     String? firstName,
  //   String? lastName,
  //   String? phone,
  //   String? address,
  //   // كلمة المرور الحالية دائماً مطلوبة للتأكيد
  //   required String currentPassword,
  // });
  // In domain/repositories/teacher_repository.dart
Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
  required String firstName,
  required String lastName,
  String? fatherName,
  String? motherName,
  DateTime? birthDate,
  String? educationLevel,
  required String gender,
  required String phone,
  String? address,
  required String currentPassword,
  String? newPassword,
  String? newPasswordConfirmation,
});

   Future<Either<Failure, Map<String, dynamic>>> getNotifications(int page);
   Future<Either<Failure, void>> markNotificationAsRead(String notificationId);
  Future<Either<Failure, void>> markAttendanceOnly(int studentId, int halaqaId, bool isPresent);
  Future<Either<Failure, List<Map<String, dynamic>>>> getPartsForStudent(int studentId);
Future<Either<Failure, void>> syncStudentParts(int studentId, List<int> partIds);
}
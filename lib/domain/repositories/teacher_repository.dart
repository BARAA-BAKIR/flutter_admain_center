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
  Future<Either<Failure, MyhalaqaModel>> getMyHalaqaWithLocalData();
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
  Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
      String? firstName,
    String? lastName,
    String? phone,
    String? address,
    // كلمة المرور الحالية دائماً مطلوبة للتأكيد
    required String currentPassword,
  });
   Future<Either<Failure, Map<String, dynamic>>> getNotifications(int page);
   Future<Either<Failure, void>> markNotificationAsRead(String notificationId);
  // الدوال التالية كانت موجودة في الكود القديم لكنها لم تُعدّل
  // وهي دوال لا تتبع النمط الجديد `Either` وغير موجودة في طبقة التنفيذ
  // لذلك قمت بإزالتها أو تعديلها لتصبح متوافقة.
  // Future<bool> syncMyHalaqa();
  // Future<bool> syncLevels();
  // Future<bool> syncFollowUpAndDuty(int studentId, String date);
  // Future<Either<Failure, StudentProfileModel>> fetchStudentProfile(int studentId); // تم دمجها مع getStudentProfile
  // Future<MyhalaqaModel> mergeWithLocalFollowUps(MyhalaqaModel halaqa); // هذه دالة مساعدة، يجب أن تكون خاصة ولا تظهر في الواجهة
}
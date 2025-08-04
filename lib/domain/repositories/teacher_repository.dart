// lib/domain/repositories/teacher_repository.dart

import 'package:flutter_admain_center/data/models/add_student_model.dart';
import 'package:flutter_admain_center/data/models/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/duty_model.dart';
import 'package:flutter_admain_center/data/models/level_model.dart';
import 'package:flutter_admain_center/data/models/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/student_profile_model.dart';

abstract class TeacherRepository {
   // --- دوال جلب البيانات ---
  Future<MyhalaqaModel> getMyHalaqaWithLocalData();
  Future<List<LevelModel>> getLevels();
  Future<Map<String, dynamic>> getFollowUpAndDutyForStudent(int studentId, String date);

  // --- دوال الحفظ والمزامنة ---
  Future<bool> storeFollowUpAndDuty(DailyFollowUpModel followUp, DutyModel duty);
  Future<void> syncAllUnsyncedData(); // دالة شاملة للمزامنة

  // --- دوال إضافة طالب ---
  Future<Map<String, dynamic>> addStudent({required String token, required AddStudentModel studentData});


  // --- دالة جديدة: لجلب ملف الطالب الكامل ---
  Future<StudentProfileModel> getStudentProfile(int studentId);

}

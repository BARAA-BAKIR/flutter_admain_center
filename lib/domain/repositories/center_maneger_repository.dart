import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';

abstract class CenterManagerRepository {
  // دالة لجلب بيانات الطلاب
  // إضافة تعريف الدالة الجديدة
  Future<Either<Failure, Map<String, dynamic>>> getStudents({
    required int page,
    String? searchQuery,
    int? halaqaId,
    int? levelId,
  });

  Future<Either<Failure, Map<String, dynamic>>> getHalaqas({
    required int page,
    String? searchQuery,
  });
  Future<Either<Failure, Map<String, dynamic>>> getTeachers({
    required int page,
    String? searchQuery,
  });
  Future<Either<Failure, DashboardSummary>> getDashboardSummary();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllStudentsForReport();
  Future<Either<Failure, List<LevelModel>>> getLevels();
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required AddStudentModel studentData,
  });
  Future<Either<Failure, List<Halaqa>>> getHalaqasForSelection();
  Future<Either<Failure, void>> deleteStudent(int studentId);
  Future<Either<Failure, void>> addHalaqa(Map<String, dynamic> halaqaData);
  Future<Either<Failure, void>> deleteHalaqa(int halaqaId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getTeachersForSelection();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReportData({
    required DateTime startDate,
    required DateTime endDate,
    int? halaqaId,
  });

  Future<Either<Failure, void>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  });
  Future<Either<Failure, Map<String, dynamic>>> updateStudent({
    required int studentId,
    required Map<String, dynamic> studentData,
  });
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData();
  
}

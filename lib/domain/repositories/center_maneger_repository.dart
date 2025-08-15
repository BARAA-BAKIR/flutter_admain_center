import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_teacher_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/dashboard_summary_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_name_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_diatls_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
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
  Future<Either<Failure, DashboardSummaryCenter>> getDashboardSummary();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllStudentsForReport();
  Future<Either<Failure, List<LevelModel>>> getLevels();
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required AddStudentModel studentData,
  });
  Future<Either<Failure, List<HalaqaNameModel>>> getHalaqasForSelection();
  Future<Either<Failure, void>> deleteStudent(int studentId);
  Future<Either<Failure, void>> addHalaqa(AddHalaqaModel halaqaData);
  Future<Either<Failure, void>> deleteHalaqa(int halaqaId);
  Future<Either<Failure, List<TeacherSelectionModel>>>
  getTeachersForSelection();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReportData({
    required DateTime startDate,
    required DateTime endDate,
    int? halaqaId,
  });

  // دالة جديدة لنقل الطالب
  Future<Either<Failure, Map<String, dynamic>>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  });
  Future<Either<Failure, Map<String, dynamic>>> updateStudent({
    required int studentId,
    required Map<String, dynamic> studentData,
  });
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData();
  Future<Either<Failure, StudentDetails>> getStudentDetails(int studentId);
  Future<Either<Failure, List<MosqueSelectionModel>>> getMosquesForSelection();
 Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqaTypesForSelection();
 Future<Either<Failure, Map<String, dynamic>>> getHalaqaForEdit(int halaqaId);
  Future<Either<Failure, void>> updateHalaqa(int halaqaId, AddHalaqaModel halaqaData);
  Future<Either<Failure, void>> deleteTeacher(int teacherId);
 Future<Either<Failure, Teacher>> addTeacher(AddTeacherModel data);
  Future<Either<Failure, TeacherDetailsModel>> getTeacherDetails(int teacherId);
  Future<Either<Failure, TeacherDetailsModel>> updateTeacherDetails(int teacherId, Map<String, dynamic> data);
Future<Either<Failure, Halaqa>> getHalaqaDetails(int halaqaId);

  // Future<Either<Failure, Map<String, dynamic>>> addTeacher(AddTeacherModel teacherData);
}

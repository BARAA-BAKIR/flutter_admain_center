
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/paginated_response.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_details_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/user_profile_model.dart';

abstract class SuperAdminRepository {
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary();
   Future<Either<Failure, List<Map<String, dynamic>>>> getComprehensiveStudentReport({
    DateTime? startDate,
    DateTime? endDate,
    int? centerId,
    int? halaqaId,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherProductivityReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getGeneralAttendanceReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList();
  Future<Either<Failure, Map<String, dynamic>>> getCenters({
    required int page,
    String? searchQuery,
  });
  Future<Either<Failure, void>> deleteCenter(int centerId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers({
    required int? editingCenterId,
  });
  Future<Either<Failure, void>> createCenter(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateCenter({
    required int centerId,
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({
    required int page,
    String? searchQuery,
  });
  Future<Either<Failure, List<PendingUser>>> getPendingTeachers();
  Future<Either<Failure, void>> approveTeacher(int userId);
  Future<Either<Failure, void>> rejectTeacher(int userId);
  // Future<Either<Failure, Map<String, dynamic>>> getAllStudents({
  //   required int page,
  //   String? searchQuery,
  //   int? centerId,
  //   int? halaqaId,
  // });
  Future<Either<Failure, List<Role>>> getRoles();
  Future<Either<Failure, Map<String, List<Permission>>>> getPermissions();
  Future<Either<Failure, void>> syncPermissionsToRole({
    required int roleId,
    required List<int> permissionIds,
  });
  Future<Either<Failure, Map<String, dynamic>>> getStudentFilters();
  // Future<Either<Failure, void>> updateStudent({
  //   required int studentId,
  //   required Map<String, dynamic> data,
  // });
  Future<Either<Failure, void>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  });
  Future<Either<Failure, void>> deleteStudent(int studentId);
  Future<Either<Failure, CenterModel>> getCenterDetails(
    int centerId,
  ); // ✅ إضافة الدالة الجديدة
  // ... (داخل abstract class SuperAdminRepository)
  Future<Either<Failure, void>> promoteTeacher({
    required int teacherId,
    required String newRole,
  });

  // أنواع الحلقات
  Future<Either<Failure, List<HalaqaType>>> getHalaqaTypes();
  Future<Either<Failure, void>> addHalaqaType(String name);
  Future<Either<Failure, void>> updateHalaqaType(int id, String name);
  Future<Either<Failure, void>> deleteHalaqaType(int id);

  // مراحل تقدم الطالب
  // Future<Either<Failure, List<StudentProgressStage>>> getProgressStages();
  Future<Either<Failure, void>> addProgressStage(String name);
  Future<Either<Failure, void>> updateProgressStage(int id, String name);
  Future<Either<Failure, void>> deleteProgressStage(int id);

  // الأجزاء الثابتة
  Future<Either<Failure, List<Part>>> getParts();
  Future<Either<Failure, void>> addPart(String writing);
  Future<Either<Failure, void>> updatePart(int id, String writing);
  Future<Either<Failure, void>> deletePart(int id);

  // Future<Either<Failure, Map<String, dynamic>>> getProfile();
  Future<Either<Failure, void>> verifyPassword(String password);
  Future<Either<Failure, List<CenterManagerModel>>> getCenterManagers({String? searchQuery});
  Future<Either<Failure, void>> addCenterManager(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateCenterManager({
    required int id,
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, void>> deleteCenterManager(int id);

  // دوال إدارة الحلقات
  // Future<Either<Failure, List<HalaqaModel>>> getHalaqas();

  // ... (داخل abstract class SuperAdminRepository)
  Future<Either<Failure, Map<String, dynamic>>> getMosques({
    required int page,
    String? searchQuery,
  });
  Future<Either<Failure, void>> addMosque(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateMosque({
    required int id,
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, void>> deleteMosque(int id);
  Future<Either<Failure, List<HalaqaModel>>> getHalaqas({String? searchQuery});
  Future<Either<Failure, void>> deleteHalaqa(int id);

  // ...
  Future<Either<Failure, void>> addHalaqa(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateHalaqa({
    required int id,
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getMosquesByCenter(
    int centerId,
  );
  Future<Either<Failure, Map<String, dynamic>>> getManagerPrerequisites();
  Future<Either<Failure, UserProfileModel>> getProfile();
  Future<Either<Failure, UserProfileModel>> updateProfile(
    Map<String, dynamic> data,
  );

 Future<Either<Failure, void>> addStudentBySuperAdmin(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> updateStudentBySuperAdmin(
    int studentId,
    Map<String, dynamic> data,
  );
   Future<Either<Failure, PaginatedResponse<StudentListItem>>> getAllStudents({
    required int page,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  });
  
  Future<Either<Failure, void>> addTeacher(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateTeacher({
    required int teacherId,
    required Map<String, dynamic> data,
  });
  // delete teacher
  Future<Either<Failure,void>>deleteTeacher(int id);
  Future<Either<Failure, List<dynamic>>> getTeacherHalaqas(int teacherId);

  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersForFilter();
  Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter(int centerId);
  Future<Either<Failure, List<StudentProgressStage>>> getProgressStagesForFilter();
  Future<Either<Failure, StudentDetails>> getStudentDetails(int studentId);
}

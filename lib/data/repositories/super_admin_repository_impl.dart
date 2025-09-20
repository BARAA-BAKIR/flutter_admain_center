
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
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
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

class SuperAdminRepositoryImpl implements SuperAdminRepository {
  final SuperAdminApiDatasource datasource;

  SuperAdminRepositoryImpl({required this.datasource});

  /// دالة مساعدة لمعالجة النتائج وتحويلها بأمان
  Either<Failure, T> _handleResult<T>(
    Either<Failure, dynamic> result,
    T Function(dynamic data) fromJson,
  ) {
    return result.fold((failure) => Left(failure), (data) {
      try {
        return Right(fromJson(data));
      } catch (e) {
        return Left(
          ServerFailure(message: 'فشل في تحليل البيانات: ${e.toString()}'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary() async {
    final result = await datasource.getDashboardSummary();
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCenters({
    required int page,
    String? searchQuery,
  }) async {
    final result = await datasource.getCenters(
      page: page,
      searchQuery: searchQuery,
    );
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers({
    required int? editingCenterId,
  }) async {
    final result = await datasource.getPotentialManagers(
      editingCenterId: editingCenterId ?? -1,
    );
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({
    required int page,
    String? searchQuery,
  }) async {
    final result = await datasource.getApprovedTeachers(
      page: page,
      searchQuery: searchQuery,
    );
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, List<PendingUser>>> getPendingTeachers() async {
    final result = await datasource.getPendingTeachers();
    return _handleResult(
      result,
      (data) =>
          (data as List).map((json) => PendingUser.fromJson(json)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<Role>>> getRoles() async {
    final result = await datasource.getRoles();
    return _handleResult(
      result,
      (data) => (data as List).map((json) => Role.fromJson(json)).toList(),
    );
  }

  @override
  Future<Either<Failure, Map<String, List<Permission>>>>
  getPermissions() async {
    final result = await datasource.getPermissions();
    return _handleResult(result, (data) {
      final permissionMap = <String, List<Permission>>{};
      (data as Map<String, dynamic>).forEach((key, value) {
        permissionMap[key] =
            (value as List).map((p) => Permission.fromJson(p)).toList();
      });
      return permissionMap;
    });
  }

  @override
  Future<Either<Failure, CenterModel>> getCenterDetails(int centerId) async {
    final result = await datasource.getCenterDetails(centerId: centerId);
    return _handleResult(result, (data) => CenterModel.fromJson(data));
  }

  @override
  Future<Either<Failure, List<HalaqaType>>> getHalaqaTypes() async {
    final result = await datasource.getHalaqaTypes();
    return _handleResult(
      result,
      (data) =>
          (data as List).map((json) => HalaqaType.fromJson(json)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<Part>>> getParts() async {
    final result = await datasource.getParts();
    return _handleResult(
      result,
      (data) => (data as List).map((json) => Part.fromJson(json)).toList(),
    );
  }

  // @override
  // Future<Either<Failure, List<CenterManagerModel>>> getCenterManagers() async {
  //   final result = await datasource.getCenterManagers();
  //   return _handleResult(
  //     result,
  //     (data) =>
  //         (data as List)
  //             .map((json) => CenterManagerModel.fromJson(json))
  //             .toList(),
  //   );
  // }
@override
Future<Either<Failure, List<CenterManagerModel>>> getCenterManagers({String? searchQuery}) async {
  // ✅ الخطوة 1: استدعاء الـ Datasource مع تمرير قيمة البحث
  final result = await datasource.getCenterManagers(searchQuery: searchQuery);

  // ✅ الخطوة 2: التعامل مع النتيجة بشكل صحيح
  return result.fold(
    // في حالة الفشل، أرجع الفشل كما هو
    (failure) => Left(failure),
    // في حالة النجاح، قم بتحليل البيانات
    (data) {
      try {
        // 1. تأكد من أن البيانات هي Map (كائن JSON)
        if (data is Map<String, dynamic>) {
          // 2. استخرج القائمة من مفتاح 'data'
          final List<dynamic> managerList = data['data'];

          // 3. قم بتحويل كل عنصر في القائمة إلى موديل
          final managers = managerList
              .map((json) => CenterManagerModel.fromJson(json))
              .toList();
          
          // 4. أرجع قائمة المدراء بنجاح
          return Right(managers);
        } else {
          // إذا كانت البيانات ليست بالشكل المتوقع، أرجع خطأ تحليل
          return Left(ParsingFailure(message: 'استجابة الخادم غير متوقعة'));
        }
      } catch (e) {
        // في حال حدوث أي خطأ أثناء التحليل، أرجع خطأ تحليل
        return Left(ParsingFailure(message: 'فشل في تحليل بيانات المدراء: ${e.toString()}'));
      }
    },
  );
}
  @override
  Future<Either<Failure, List<HalaqaModel>>> getHalaqas({
    String? searchQuery,
  }) async {
    final result = await datasource.getHalaqas(searchQuery: searchQuery);
    return _handleResult(
      result,
      (data) =>
          (data as List).map((json) => HalaqaModel.fromJson(json)).toList(),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMosquesByCenter(
    int centerId,
  ) async {
    final result = await datasource.getMosquesByCenter(centerId: centerId);
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getManagerPrerequisites() async {
    final result = await datasource.getManagerPrerequisites();
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, UserProfileModel>> getProfile() async {
    final result = await datasource.getProfile();
    return _handleResult(result, (data) => UserProfileModel.fromJson(data));
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    final result = await datasource.updateProfile(data: data);
    return _handleResult(result, (data) => UserProfileModel.fromJson(data));
  }

  @override
  Future<Either<Failure, PaginatedResponse<StudentListItem>>> getAllStudents({
    required int page,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  }) async {
    final result = await datasource.getAllStudents(
      page: page,
      searchQuery: searchQuery,
      centerId: centerId,
      halaqaId: halaqaId,
    );
    return _handleResult(
      result,
      (data) => PaginatedResponse.fromJson(
        data,
        (json) => StudentListItem.fromJson(json as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<Either<Failure, List<dynamic>>> getTeacherHalaqas(
    int teacherId,
  ) async {
    final result = await datasource.getTeacherHalaqas(teacherId: teacherId);
    return _handleResult(result, (data) => data as List<dynamic>);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getCentersForFilter() async {
    final result = await datasource.getCentersForFilter();
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter(
    int centerId,
  ) async {
    final result = await datasource.getHalaqasForFilter(centerId);
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, List<StudentProgressStage>>>
  getProgressStagesForFilter() async {
    final result = await datasource.getProgressStages();
    return _handleResult(
      result,
      (data) =>
          (data as List)
              .map((json) => StudentProgressStage.fromJson(json))
              .toList(),
    );
  }

  @override
  Future<Either<Failure, StudentDetails>> getStudentDetails(
    int studentId,
  ) async {
    final result = await datasource.getStudentDetails(studentId);
    return _handleResult(result, (data) => StudentDetails.fromJson(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMosques({
    required int page,
    String? searchQuery,
  }) async {
    final result = await datasource.getMosques(
      page: page,
      searchQuery: searchQuery,
    );
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStudentFilters() async {
    final result = await datasource.getStudentFilters();
    return _handleResult(result, (data) => data as Map<String, dynamic>);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getComprehensiveStudentReport({
    DateTime? startDate,
    DateTime? endDate,
    int? centerId,
    int? halaqaId,
  }) async {
    final result = await datasource.getComprehensiveStudentReport(
      startDate: startDate,
      endDate: endDate,
      centerId: centerId,
      halaqaId: halaqaId,
    );
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getTeacherProductivityReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) async {
    final result = await datasource.getTeacherProductivityReport(
      startDate: startDate,
      endDate: endDate,
      centerId: centerId,
    );
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getGeneralAttendanceReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) async {
    final result = await datasource.getGeneralAttendanceReport(
      startDate: startDate,
      endDate: endDate,
      centerId: centerId,
    );
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList() async {
    final result = await datasource.getCentersList();
    return _handleResult(
      result,
      (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  // --- Void Functions (Direct Pass-through) ---
  @override
  Future<Either<Failure, void>> deleteCenter(int centerId) =>
      datasource.deleteCenter(centerId: centerId);
  @override
  Future<Either<Failure, void>> createCenter(Map<String, dynamic> data) =>
      datasource.createCenter(data: data);
  @override
  Future<Either<Failure, void>> updateCenter({
    required int centerId,
    required Map<String, dynamic> data,
  }) => datasource.updateCenter(centerId: centerId, data: data);
  @override
  Future<Either<Failure, void>> approveTeacher(int userId) =>
      datasource.approveTeacher(userId: userId);
  @override
  Future<Either<Failure, void>> rejectTeacher(int userId) =>
      datasource.rejectTeacher(userId: userId);
  @override
  Future<Either<Failure, void>> syncPermissionsToRole({
    required int roleId,
    required List<int> permissionIds,
  }) => datasource.syncPermissionsToRole(
    roleId: roleId,
    permissionIds: permissionIds,
  );
  @override
  Future<Either<Failure, void>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  }) => datasource.transferStudent(
    studentId: studentId,
    newHalaqaId: newHalaqaId,
  );
  @override
  Future<Either<Failure, void>> promoteTeacher({
    required int teacherId,
    required String newRole,
  }) => datasource.promoteTeacher(teacherId: teacherId, newRole: newRole);
  @override
  Future<Either<Failure, void>> addHalaqaType(String name) =>
      datasource.addHalaqaType(name);
  @override
  Future<Either<Failure, void>> updateHalaqaType(int id, String name) =>
      datasource.updateHalaqaType(id, name);
  @override
  Future<Either<Failure, void>> deleteHalaqaType(int id) =>
      datasource.deleteHalaqaType(id);
  @override
  Future<Either<Failure, void>> addPart(String writing) =>
      datasource.addPart(writing);
  @override
  Future<Either<Failure, void>> updatePart(int id, String writing) =>
      datasource.updatePart(id, writing);
  @override
  Future<Either<Failure, void>> deletePart(int id) => datasource.deletePart(id);
  @override
  Future<Either<Failure, void>> verifyPassword(String password) =>
      datasource.verifyPassword(password);
  @override
  Future<Either<Failure, void>> addCenterManager(Map<String, dynamic> data) =>
      datasource.addCenterManager(data: data);
  @override
  Future<Either<Failure, void>> updateCenterManager({
    required int id,
    required Map<String, dynamic> data,
  }) => datasource.updateCenterManager(id: id, data: data);
  @override
  Future<Either<Failure, void>> deleteCenterManager(int id) =>
      datasource.deleteCenterManager(id: id);
  @override
  Future<Either<Failure, void>> addMosque(Map<String, dynamic> data) =>
      datasource.addMosque(data: data);
  @override
  Future<Either<Failure, void>> updateMosque({
    required int id,
    required Map<String, dynamic> data,
  }) => datasource.updateMosque(id: id, data: data);
  @override
  Future<Either<Failure, void>> deleteMosque(int id) =>
      datasource.deleteMosque(id: id);
  @override
  Future<Either<Failure, void>> deleteHalaqa(int id) =>
      datasource.deleteHalaqa(id: id);
  @override
  Future<Either<Failure, void>> addHalaqa(Map<String, dynamic> data) =>
      datasource.addHalaqa(data: data);
  @override
  Future<Either<Failure, void>> updateHalaqa({
    required int id,
    required Map<String, dynamic> data,
  }) => datasource.updateHalaqa(id: id, data: data);
  @override
  Future<Either<Failure, void>> addStudentBySuperAdmin(
    Map<String, dynamic> data,
  ) => datasource.addStudent(data);
  @override
  Future<Either<Failure, void>> updateStudentBySuperAdmin(
    int studentId,
    Map<String, dynamic> data,
  ) => datasource.updateStudent(studentId, data);
  @override
  Future<Either<Failure, void>> deleteStudent(int studentId) =>
      datasource.deleteStudent(studentId: studentId);
  @override
  Future<Either<Failure, void>> addTeacher(Map<String, dynamic> data) =>
      datasource.addTeacher(data: data);
  @override
  Future<Either<Failure, void>> updateTeacher({
    required int teacherId,
    required Map<String, dynamic> data,
  }) => datasource.updateTeacher(teacherId: teacherId, data: data);
  @override
  Future<Either<Failure, void>> deleteTeacher(int id) =>
      datasource.deleteTeacher(id);

  // الدوال الناقصة من العقد
  @override
  Future<Either<Failure, void>> addProgressStage(String name) =>
      datasource.addProgressStage(name);
  @override
  Future<Either<Failure, void>> updateProgressStage(int id, String name) =>
      datasource.updateProgressStage(id, name);
  @override
  Future<Either<Failure, void>> deleteProgressStage(int id) =>
      datasource.deleteProgressStage(id);
}

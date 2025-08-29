import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_filter_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/paginated_response.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
// ✅ ---  1. استيراد الموديلات الناقصة ---
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/profile_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_details_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/user_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SuperAdminRepositoryImpl implements SuperAdminRepository {
  final SuperAdminApiDatasource datasource;
  final FlutterSecureStorage storage;

  SuperAdminRepositoryImpl({required this.datasource, required this.storage});

  Future<String?> _getToken() async {
    final userData = await storage.read(key: 'user_data');
    if (userData == null) return null;
    return jsonDecode(userData)['token'];
  }

  // ✅ --- 2. تصحيح كل الدوال التي ترجع Map أو List ---

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getDashboardSummary(token: token);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCenters({
    required int page,
    String? searchQuery,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'لا يوجد تسجيل دخول'));
    }
    final result = await datasource.getCenters(
      token: token,
      page: page,
      searchQuery: searchQuery,
    );
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers({
    required int? editingCenterId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getPotentialManagers(
      token: token,
      editingCenterId: editingCenterId ?? -1,
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({
    required int page,
    String? searchQuery,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getApprovedTeachers(
      token: token,
      page: page,
      searchQuery: searchQuery,
    );
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudentReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getStudentReport(
      token: token,
      startDate: startDate,
      endDate: endDate,
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getAttendanceReport(
      token: token,
      startDate: startDate,
      endDate: endDate,
      centerId: centerId,
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherReport() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getTeacherReport(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getCentersList(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  // --- الدوال التي لا تحتاج تعديل (لأنها void أو تم تحويلها مسبقاً) ---
  @override
  Future<Either<Failure, void>> deleteCenter(int centerId) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.deleteCenter(token: token, centerId: centerId);
  }

  @override
  Future<Either<Failure, void>> createCenter(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.createCenter(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateCenter({
    required int centerId,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.updateCenter(
      token: token,
      centerId: centerId,
      data: data,
    );
  }

  @override
  Future<Either<Failure, List<PendingUser>>> getPendingTeachers() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getPendingTeachers(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((json) => PendingUser.fromJson(json)).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> approveTeacher(int userId) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.approveTeacher(token: token, userId: userId);
  }

  @override
  Future<Either<Failure, void>> rejectTeacher(int userId) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.rejectTeacher(token: token, userId: userId);
  }

  @override
  Future<Either<Failure, List<Role>>> getRoles() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getRoles(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((json) => Role.fromJson(json)).toList()),
    );
  }

  @override
  Future<Either<Failure, Map<String, List<Permission>>>>
  getPermissions() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getPermissions(token: token);
    return result.fold((l) => Left(l), (r) {
      final Map<String, List<Permission>> permissionMap = {};
      r.forEach((key, value) {
        permissionMap[key] =
            (value as List).map((p) => Permission.fromJson(p)).toList();
      });
      return Right(permissionMap);
    });
  }

  @override
  Future<Either<Failure, void>> syncPermissionsToRole({
    required int roleId,
    required List<int> permissionIds,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.syncPermissionsToRole(
      token: token,
      roleId: roleId,
      permissionIds: permissionIds,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStudentFilters() async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.getStudentFilters(token: token);
  }

  // @override
  // Future<Either<Failure, void>> updateStudent({
  //   required int studentId,
  //   required Map<String, dynamic> data,
  // }) async {
  //   final token = await _getToken();
  //   if (token == null) {
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
  //   }
  //   return await datasource.updateStudent(
  //     token: token,
  //     studentId: studentId,
  //     data: data,
  //   );
  // }

  @override
  Future<Either<Failure, void>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.transferStudent(
      token: token,
      studentId: studentId,
      newHalaqaId: newHalaqaId,
    );
  }

  // @override
  // Future<Either<Failure, void>> deleteStudent(int studentId) async {
  //   final token = await _getToken();
  //   if (token == null) {
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
  //   }
  //   return await datasource.deleteStudent(token: token, studentId: studentId);
  // }

  @override
  Future<Either<Failure, CenterModel>> getCenterDetails(int centerId) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getCenterDetails(
      token: token,
      centerId: centerId,
    );
    return result.fold((l) => Left(l), (r) => Right(CenterModel.fromJson(r)));
  }

  // ... (داخل class SuperAdminRepositoryImpl)
  @override
  Future<Either<Failure, void>> promoteTeacher({
    required int teacherId,
    required String newRole,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    return await datasource.promoteTeacher(
      token: token,
      teacherId: teacherId,
      newRole: newRole,
    );
  }

  @override
  Future<Either<Failure, List<HalaqaType>>> getHalaqaTypes() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
      }

      final result = await datasource.getHalaqaTypes(token: token);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addHalaqaType(String name) async {
    try {
      await datasource.addHalaqaType(name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateHalaqaType(int id, String name) async {
    try {
      await datasource.updateHalaqaType(id, name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHalaqaType(int id) async {
    try {
      await datasource.deleteHalaqaType(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, void>> addProgressStage(String name) async {
    try {
      await datasource.addProgressStage(name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProgressStage(int id, String name) async {
    try {
      await datasource.updateProgressStage(id, name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProgressStage(int id) async {
    try {
      await datasource.deleteProgressStage(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Part>>> getParts() async {
    try {
      final result = await datasource.getParts();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPart(String writing) async {
    try {
      await datasource.addPart(writing);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePart(int id, String writing) async {
    try {
      await datasource.updatePart(id, writing);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePart(int id) async {
    try {
      await datasource.deletePart(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPassword(String password) async {
    try {
      final token = await _getToken();
      if (token == null)
        return Left(CacheFailure(message: 'User not logged in'));
      await datasource.verifyPassword(token, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ...
  @override
  Future<Either<Failure, List<CenterManagerModel>>> getCenterManagers() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getCenterManagers(token: token);
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(
        (data).map((json) => CenterManagerModel.fromJson(json)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> addCenterManager(
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.addCenterManager(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateCenterManager({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.updateCenterManager(
      token: token,
      id: id,
      data: data,
    );
  }

  @override
  Future<Either<Failure, void>> deleteCenterManager(int id) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.deleteCenterManager(token: token, id: id);
  }

  // @override
  // Future<Either<Failure, List<HalaqaModel>>> getHalaqas() async {
  //   final token = await _getToken();
  //   if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
  //   final result = await datasource.getHalaqas(token: token);
  //   return result.fold(
  //     (failure) => Left(failure),
  //     (data) => Right((data).map((json) => HalaqaModel.fromJson(json)).toList()),
  //   );
  // }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMosques({
    required int page,
    String? searchQuery,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    final result = await datasource.getMosques(
      token: token,
      page: page,
      searchQuery: searchQuery,
    );
    return result.fold((l) => Left(l), (r) => Right(r));
  }
  // ... (داخل class SuperAdminRepositoryImpl)
  // @override
  // Future<Either<Failure, Map<String, dynamic>>?> getMosques({required int page, String? searchQuery}) async {
  //   final token = await _getToken();
  //   if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
  //   return await datasource.getMosques(token: token, page: page, searchQuery: searchQuery);
  // }

  @override
  Future<Either<Failure, void>> addMosque(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.addMosque(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateMosque({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.updateMosque(token: token, id: id, data: data);
  }

  @override
  Future<Either<Failure, void>> deleteMosque(int id) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.deleteMosque(token: token, id: id);
  }

  // ... (داخل class SuperAdminRepositoryImpl)
  @override
  Future<Either<Failure, List<HalaqaModel>>> getHalaqas({
    String? searchQuery,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getHalaqas(
      token: token,
      searchQuery: searchQuery,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) =>
          Right((data).map((json) => HalaqaModel.fromJson(json)).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteHalaqa(int id) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.deleteHalaqa(token: token, id: id);
  }

  // ...
  @override
  Future<Either<Failure, void>> addHalaqa(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.addHalaqa(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateHalaqa({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.updateHalaqa(token: token, id: id, data: data);
  }

  @override
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMosquesByCenter(
    int centerId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getMosquesByCenter(
      token: token,
      centerId: centerId,
    );
    return result.fold(
      (l) => Left(l),
      (r) => Right(List<Map<String, dynamic>>.from(r)),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  getManagerPrerequisites() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getManagerPrerequisites(token: token);
    return result.fold((l) => Left(l), (r) => Right(r as Map<String, dynamic>));
  }

  @override
  Future<Either<Failure, UserProfileModel>> getProfile() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getProfile(token: token);
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(UserProfileModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'User not logged in'));
    }
    final result = await datasource.updateProfile(token: token, data: data);
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(UserProfileModel.fromJson(data)),
    );
  }

  // ... (داخل class SuperAdminRepositoryImpl)

  // @override
  // Future<Either<Failure, PaginatedResponse<StudentListItem>>> getAllStudents({
  //   required int page,
  //   String? searchQuery,
  //   int? centerId,
  //   int? halaqaId,
  // }) async {
  //   try {
  //     final result = await datasource.getAllStudents(
  //       page: page,
  //       searchQuery: searchQuery,
  //       centerId: centerId,
  //       halaqaId: halaqaId,
  //     );
  //     final paginatedResponse = PaginatedResponse<StudentListItem>.fromJson(
  //       result,
  //       (json) => StudentListItem.fromJson(json as Map<String, dynamic>),
  //     );
  //     return Right(paginatedResponse);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   }
  // }
  @override
  Future<Either<Failure, PaginatedResponse<StudentListItem>>> getAllStudents({
    required int page,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    }
    // استدعاء المصدر الذي يُرجع Map
    final result = await datasource.getAllStudents(
      token: token,
      page: page,
      searchQuery: searchQuery,
      centerId: centerId,
      halaqaId: halaqaId,
    );

    // تحويل الـ Map إلى كائن منظم
    return result.fold((l) => Left(l), (r) {
      try {
        // r هنا هي الـ Map<String, dynamic>
        final paginatedResponse = PaginatedResponse<StudentListItem>.fromJson(
          r,
          (json) => StudentListItem.fromJson(json as Map<String, dynamic>),
        );
        return Right(paginatedResponse);
      } catch (e) {
        return Left(
          ServerFailure(message: 'خطأ في تحليل بيانات الطلاب: ${e.toString()}'),
        );
      }
    });
  }

  // @override
  // Future<Either<Failure, StudentDetails>> getStudentDetails(
  //   int studentId,
  // ) async {
  //   try {
  //     final result = await datasource.getStudentDetails(studentId);
  //     return Right(StudentDetails.fromJson(result));
  //   } catch (e) {
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, void>> addStudentBySuperAdmin(
    Map<String, dynamic> data,
  ) async {
    try {
      await datasource.addStudent(data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStudentBySuperAdmin(
    int studentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await datasource.updateStudent(studentId, data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(int studentId) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'User not logged in'));
    }
    try {
      await datasource.deleteStudent(token: token, studentId: studentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  //   @override
  // Future<Either<Failure, List<CenterFilterModel>>> getCentersForFilter() async {
  //   try {
  //     // استدعاء الدالة المصححة من الـ Datasource
  //     final result = await datasource.getCentersForFilter();
  //     // تحويل القائمة الديناميكية إلى قائمة من الموديلات
  //     return Right(result.map((json) => CenterFilterModel.fromJson(json)).toList());
  //   } on Exception catch (e) {
  //     // التعامل مع أي خطأ، بما في ذلك خطأ عدم وجود توكن
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter(
  //   int centerId,
  // ) async {
  //   try {
  //     final result = await datasource.getHalaqasForFilter(centerId);
  //     return Right(List<Map<String, dynamic>>.from(result as Iterable));
  //   } catch (e) {
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  // ... (داخل class SuperAdminRepositoryImpl)

  @override
  Future<Either<Failure, void>> addTeacher(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.addTeacher(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateTeacher({
    required int teacherId,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.updateTeacher(
      token: token,
      teacherId: teacherId,
      data: data,
    );
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(int id) {
    // TODO: implement deleteTeacher
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<dynamic>>> getTeacherHalaqas(
    int teacherId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.getTeacherHalaqas(
      token: token,
      teacherId: teacherId,
    );
  }

// في ملف data/repositories/super_admin_repository_impl.dart

@override
Future<Either<Failure, List<Map<String, dynamic>>>> getCentersForFilter() async {
  return await datasource.getCentersForFilter();
}

@override
Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter(int centerId) async {
  return await datasource.getHalaqasForFilter(centerId);
}

@override
Future<Either<Failure, List<StudentProgressStage>>> getProgressStagesForFilter() async {
  return await datasource.getProgressStages();
}

@override
Future<Either<Failure, StudentDetails>> getStudentDetails(int studentId) async {
  return await datasource.getStudentDetails(studentId);
}

  @override
  Future<Either<Failure, List<StudentProgressStage>>> getProgressStages() {
    // TODO: implement getProgressStages
    throw UnimplementedError();
  }


  // @override
  // Future<Either<Failure, List<StudentProgressStage>>>
  // getProgressStages() async {
  //   try {
  //     final result = await datasource.getProgressStages();
  //     return Right(result);
  //   } catch (e) {
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }
  
}

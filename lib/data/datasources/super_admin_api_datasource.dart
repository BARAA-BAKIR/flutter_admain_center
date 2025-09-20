
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SuperAdminApiDatasource {
  final Dio _dio;
  final FlutterSecureStorage storage;

  SuperAdminApiDatasource(this.storage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppRoutes.url,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  Future<String?> _getToken() async {
    try {
      final userData = await storage.read(key: 'user_data');
      if (userData == null) return null;
      final decodedData = jsonDecode(userData) as Map<String, dynamic>;
      return decodedData['token'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<Either<Failure, T>> _handleRequest<T>(
    Future<Response<T>> Function(String token) apiCall,
  ) async {
    final token = await _getToken();
    if (token == null)
      return Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
    return safeApiCall(() async {
      final response = await apiCall(token);
      return response.data as T;
    });
  }

  Future<Either<Failure, T>> _get<T>(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    return _handleRequest(
      (token) => _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  Future<Either<Failure, T>> _post<T>(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    return _handleRequest(
      (token) => _dio.post(
        path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  Future<Either<Failure, T>> _put<T>(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    return _handleRequest(
      (token) => _dio.put(
        path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  Future<Either<Failure, T>> _delete<T>(String path) async {
    return _handleRequest(
      (token) => _dio.delete(
        path,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  // --- Implementations ---
  Future<Either<Failure, dynamic>> getDashboardSummary() =>
      _get('/super-admin/dashboard');
  Future<Either<Failure, dynamic>> getCenters({
    required int page,
    String? searchQuery,
  }) => _get(
    '/super-admin/centers',
    query: {'page': page, if (searchQuery != null) 'search': searchQuery},
  );
  Future<Either<Failure, void>> deleteCenter({required int centerId}) =>
      _delete('/super-admin/centers/$centerId');
  Future<Either<Failure, dynamic>> getPotentialManagers({
    required int editingCenterId,
  }) => _get(
    '/super-admin/potential-managers',
    query: {'editing_center_id': editingCenterId},
  );
  Future<Either<Failure, void>> createCenter({
    required Map<String, dynamic> data,
  }) => _post('/super-admin/centers', data: data);
  Future<Either<Failure, void>> updateCenter({
    required int centerId,
    required Map<String, dynamic> data,
  }) => _put('/super-admin/centers/$centerId', data: data);
  Future<Either<Failure, dynamic>> getApprovedTeachers({
    required int page,
    String? searchQuery,
  }) => _get(
    '/super-admin/teachers',
    query: {'page': page, if (searchQuery != null) 'search': searchQuery},
  );
  Future<Either<Failure, dynamic>> getPendingTeachers() =>
      _get('/super-admin/teachers/pending');
  Future<Either<Failure, void>> approveTeacher({required int userId}) =>
      _post('/super-admin/teachers/approve/$userId', data: {});
  Future<Either<Failure, void>> rejectTeacher({required int userId}) =>
      _post('/super-admin/teachers/reject/$userId', data: {});
  Future<Either<Failure, dynamic>> getAllStudents({
    required int page,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  }) => _get(
    '/super-admin/students',
    query: {
      'page': page,
      if (searchQuery != null) 'search': searchQuery,
      if (centerId != null) 'center_id': centerId,
      if (halaqaId != null) 'halaqa_id': halaqaId,
    },
  );
  Future<Either<Failure, dynamic>> getRoles() => _get('/super-admin/roles');
  Future<Either<Failure, dynamic>> getPermissions() =>
      _get('/super-admin/permissions');
  Future<Either<Failure, void>> syncPermissionsToRole({
    required int roleId,
    required List<int> permissionIds,
  }) => _post(
    '/super-admin/roles/sync-permissions',
    data: {'role_id': roleId, 'permissions': permissionIds},
  );
  Future<Either<Failure, dynamic>> getComprehensiveStudentReport({
    DateTime? startDate,
    DateTime? endDate,
    int? centerId,
    int? halaqaId,
  }) => _get(
    '/super-admin/reports/students-performance',
    query: {
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'center_id': centerId,
      'halaqa_id': halaqaId,
    },
  );
  Future<Either<Failure, dynamic>> getTeacherProductivityReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) => _get(
    '/super-admin/reports/teacher-productivity',
    query: {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'center_id': centerId,
    },
  );
  Future<Either<Failure, dynamic>> getGeneralAttendanceReport({
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) => _get(
    '/super-admin/reports/general-attendance',
    query: {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'center_id': centerId,
    },
  );
  Future<Either<Failure, dynamic>> getCentersList() =>
      _get('/super-admin/reports/centers-list');
  Future<Either<Failure, dynamic>> getStudentFilters() =>
      _get('/super-admin/students/filters');
  Future<Either<Failure, void>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  }) => _post(
    '/super-admin/students/$studentId/transfer',
    data: {'new_halaqa_id': newHalaqaId},
  );
  Future<Either<Failure, dynamic>> getCenterDetails({required int centerId}) =>
      _get('/super-admin/centers/new/$centerId');
  Future<Either<Failure, void>> promoteTeacher({
    required int teacherId,
    required String newRole,
  }) => _post(
    '/super-admin/teachers/$teacherId/promote',
    data: {'administrative_role': newRole},
  );
  Future<Either<Failure, dynamic>> getHalaqaTypes() =>
      _get('/super-admin/halaqa-types');
  Future<Either<Failure, void>> addHalaqaType(String name) =>
      _post('/super-admin/halaqa-types', data: {'name': name});
  Future<Either<Failure, void>> updateHalaqaType(int id, String name) =>
      _put('/super-admin/halaqa-types/$id', data: {'name': name});
  Future<Either<Failure, void>> deleteHalaqaType(int id) =>
      _delete('/super-admin/halaqa-types/$id');
  Future<Either<Failure, dynamic>> getParts() => _get('/super-admin/parts');
  Future<Either<Failure, void>> addPart(String writing) =>
      _post('/super-admin/parts', data: {'writing': writing});
  Future<Either<Failure, void>> updatePart(int id, String writing) =>
      _put('/super-admin/parts/$id', data: {'writing': writing});
  Future<Either<Failure, void>> deletePart(int id) =>
      _delete('/super-admin/parts/$id');
  Future<Either<Failure, void>> verifyPassword(String password) =>
      _post('/profile/verify-password', data: {'password': password});
  Future<Either<Failure, dynamic>> getProfile() => _get('/super-admin/profile');
  Future<Either<Failure, dynamic>> updateProfile({
    required Map<String, dynamic> data,
  }) => _put('/profile/update', data: data);
 Future<Either<Failure, dynamic>> getCenterManagers({String? searchQuery}) =>
    _get(
      '/super-admin/center-managers',
      query: { if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery },
    );
  Future<Either<Failure, void>> addCenterManager({
    required Map<String, dynamic> data,
  }) => _post('/super-admin/center-managers', data: data);
  Future<Either<Failure, void>> updateCenterManager({
    required int id,
    required Map<String, dynamic> data,
  }) => _put('/super-admin/center-managers/$id', data: data);
  Future<Either<Failure, void>> deleteCenterManager({required int id}) =>
      _delete('/super-admin/center-managers/$id');
  Future<Either<Failure, dynamic>> getMosques({
    required int page,
    String? searchQuery,
  }) => _get(
    '/super-admin/mosques',
    query: {'page': page, if (searchQuery != null) 'search': searchQuery},
  );
  Future<Either<Failure, void>> addMosque({
    required Map<String, dynamic> data,
  }) => _post('/super-admin/mosques', data: data);
  Future<Either<Failure, void>> updateMosque({
    required int id,
    required Map<String, dynamic> data,
  }) => _put('/super-admin/mosques/$id', data: data);
  Future<Either<Failure, void>> deleteMosque({required int id}) =>
      _delete('/super-admin/mosques/$id');
  Future<Either<Failure, dynamic>> getHalaqas({String? searchQuery}) =>
      _get('/super-admin/halaqas', query: {'search': searchQuery});
  Future<Either<Failure, void>> deleteHalaqa({required int id}) =>
      _delete('/super-admin/halaqas/$id');
  Future<Either<Failure, void>> addHalaqa({
    required Map<String, dynamic> data,
  }) => _post('/super-admin/halaqas', data: data);
  Future<Either<Failure, void>> updateHalaqa({
    required int id,
    required Map<String, dynamic> data,
  }) => _put('/super-admin/halaqas/$id', data: data);
  Future<Either<Failure, dynamic>> getMosquesByCenter({
    required int centerId,
  }) => _get('/super-admin/centers/$centerId/mosques');
  Future<Either<Failure, dynamic>> getManagerPrerequisites() =>
      _get('/super-admin/center-managers/prerequisites');
  Future<Either<Failure, void>> addStudent(Map<String, dynamic> data) =>
      _post('/super-admin/students/add', data: data);
  Future<Either<Failure, void>> updateStudent(
    int studentId,
    Map<String, dynamic> data,
  ) => _put('/super-admin/students/$studentId/update', data: data);
  Future<Either<Failure, void>> deleteStudent({required int studentId}) =>
      _delete('/super-admin/students/$studentId');
  Future<Either<Failure, void>> addTeacher({
    required Map<String, dynamic> data,
  }) => _post('/super-admin/teachers', data: data);
  Future<Either<Failure, void>> updateTeacher({
    required int teacherId,
    required Map<String, dynamic> data,
  }) => _put('/super-admin/teachers/$teacherId', data: data);
  Future<Either<Failure, dynamic>> getTeacherHalaqas({
    required int teacherId,
  }) => _get('/super-admin/data/teachers/$teacherId/halaqas');
  Future<Either<Failure, dynamic>> getCentersForFilter() =>
      _get('/super-admin/reports/centers-list');
  Future<Either<Failure, dynamic>> getHalaqasForFilter(int centerId) =>
      _get('/super-admin/centers/$centerId/halaqas');
  Future<Either<Failure, dynamic>> getProgressStages() =>
      _get('/super-admin/progress-stages');
  Future<Either<Failure, dynamic>> getStudentDetails(int studentId) =>
      _get('/super-admin/students/$studentId');
  Future<Either<Failure, void>> deleteTeacher(int id) =>
      _delete('/super-admin/teachers/$id');
  Future<Either<Failure, void>> addProgressStage(String name) async {
    return _post<void>(
      '/super-admin/progress-stages',
      data: {'stage_name': name},
    );
  }

  Future<Either<Failure, void>> updateProgressStage(int id, String name) async {
    return _put<void>(
      '/super-admin/progress-stages/$id',
      data: {'stage_name': name},
    );
  }

  Future<Either<Failure, void>> deleteProgressStage(int id) async {
    return _delete<void>('/super-admin/progress-stages/$id');
  }
}

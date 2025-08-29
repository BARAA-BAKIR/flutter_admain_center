import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_super_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_details_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SuperAdminApiDatasource {
  final Dio _dio;

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
  final FlutterSecureStorage storage;
  Future<String?> _getToken() async {
    final userData = await storage.read(key: 'user_data');
    if (userData == null) return null;
    return jsonDecode(userData)['token'];
  }

  Future<Either<Failure, dynamic>> _get(
    String path, {
    String? token,
    Map<String, dynamic>? query,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        path,
        queryParameters: query,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, void>> _post(
    String path, {
    String? token,
    required Map<String, dynamic> data,
  }) async {
    return await safeApiCall(
      () async => await _dio.post(
        path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  Future<Either<Failure, void>> _put(
    String path, {
    String? token,
    required Map<String, dynamic> data,
  }) async {
    return await safeApiCall(
      () async => await _dio.put(
        path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  Future<Either<Failure, void>> _delete(String path, {String? token}) async {
    return await safeApiCall(
      () async => await _dio.delete(
        path,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      ),
    );
  }

  // --- Implementations ---
  Future<Either<Failure, dynamic>> getDashboardSummary({
    required String token,
  }) async => await _get('/super-admin/dashboard', token: token);
  Future<Either<Failure, dynamic>> getCenters({
    required String token,
    required int page,
    String? searchQuery,
  }) async => await _get(
    '/super-admin/centers',
    token: token,
    query: {'page': page, if (searchQuery != null) 'search': searchQuery},
  );
  Future<Either<Failure, void>> deleteCenter({
    required String token,
    required int centerId,
  }) async => await _delete('/super-admin/centers/$centerId', token: token);
  Future<Either<Failure, List<dynamic>>> getPotentialManagers({
    required int editingCenterId,
    required String token,
  }) async {
    final result = await _get(
      '/super-admin/potential-managers',
      token: token,
      query:
          // ignore: unnecessary_null_comparison
          editingCenterId != null
              ? {'editing_center_id': editingCenterId}
              : null,
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, void>> createCenter({
    required String token,
    required Map<String, dynamic> data,
  }) async => await _post('/super-admin/centers', token: token, data: data);
  Future<Either<Failure, void>> updateCenter({
    required String token,
    required int centerId,
    required Map<String, dynamic> data,
  }) async =>
      await _put('/super-admin/centers/$centerId', token: token, data: data);
  Future<Either<Failure, dynamic>> getApprovedTeachers({
    required String token,
    required int page,
    String? searchQuery,
  }) async => await _get(
    '/super-admin/teachers',
    token: token,
    query: {'page': page, if (searchQuery != null) 'search': searchQuery},
  );
  Future<Either<Failure, List<dynamic>>> getPendingTeachers({
    required String token,
  }) async {
    final result = await _get('/super-admin/teachers/pending', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, void>> approveTeacher({
    required String token,
    required int userId,
  }) async => await _post(
    '/super-admin/teachers/approve/$userId',
    token: token,
    data: {},
  );
  Future<Either<Failure, void>> rejectTeacher({
    required String token,
    required int userId,
  }) async => await _post(
    '/super-admin/teachers/reject/$userId',
    token: token,
    data: {},
  );
  Future<Either<Failure, dynamic>> getAllStudents({
    required String token,
    required int page,
    String? searchQuery,
    int? centerId,
    int? halaqaId,
  }) async => await _get(
    '/super-admin/students',
    token: token,
    query: {
      'page': page,
      if (searchQuery != null) 'search': searchQuery,
      if (centerId != null) 'center_id': centerId,
      if (halaqaId != null) 'halaqa_id': halaqaId,
    },
  );
  Future<Either<Failure, List<dynamic>>> getRoles({
    required String token,
  }) async {
    final result = await _get('/super-admin/roles', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, Map<String, dynamic>>> getPermissions({
    required String token,
  }) async {
    final result = await _get('/super-admin/permissions', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as Map<String, dynamic>));
  }

  Future<Either<Failure, void>> syncPermissionsToRole({
    required String token,
    required int roleId,
    required List<int> permissionIds,
  }) async => await _post(
    '/super-admin/roles/sync-permissions',
    token: token,
    data: {'role_id': roleId, 'permissions': permissionIds},
  );
  Future<Either<Failure, List<dynamic>>> getStudentReport({
    required String token,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await _get(
      '/super-admin/reports/students',
      token: token,
      query: {
        if (startDate != null)
          'start_date': DateFormat('yyyy-MM-dd').format(startDate),
        if (endDate != null)
          'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      },
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, List<dynamic>>> getTeacherReport({
    required String token,
  }) async {
    final result = await _get('/super-admin/reports/teachers', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, List<dynamic>>> getAttendanceReport({
    required String token,
    required DateTime startDate,
    required DateTime endDate,
    int? centerId,
  }) async {
    final result = await _get(
      '/super-admin/reports/attendance',
      token: token,
      query: {
        'start_date': DateFormat('yyyy-MM-dd').format(startDate),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate),
        if (centerId != null) 'center_id': centerId,
      },
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, List<dynamic>>> getCentersList({
    required String token,
  }) async {
    final result = await _get(
      '/super-admin/reports/centers-list',
      token: token,
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, Map<String, dynamic>>> getStudentFilters({
    required String token,
  }) async {
    final result = await _get('/super-admin/students/filters', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as Map<String, dynamic>));
  }

  Future<Either<Failure, void>> transferStudent({
    required String token,
    required int studentId,
    required int newHalaqaId,
  }) async {
    return await _post(
      '/super-admin/students/$studentId/transfer',
      token: token,
      data: {'new_halaqa_id': newHalaqaId},
    );
  }

  Future<Either<Failure, dynamic>> getCenterDetails({
    required String token,
    required int centerId,
  }) async {
    return await _get('/super-admin/centers/new/$centerId', token: token);
  }

  // ... (داخل class SuperAdminApiDatasource)
  Future<Either<Failure, void>> promoteTeacher({
    required String token,
    required int teacherId,
    required String newRole,
  }) async {
    return await _post(
      '/super-admin/teachers/$teacherId/promote',
      token: token,
      data: {'administrative_role': newRole},
    );
  }

  Future<List<HalaqaType>> getHalaqaTypes({required String token}) async {
    final response = await _dio.get(
      '/super-admin/halaqa-types',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data as List)
        .map((json) => HalaqaType.fromJson(json))
        .toList();
  }

  Future<void> addHalaqaType(String name) async {
    await _dio.post(
      '/super-admin/halaqa-types',
      data: {'name': name},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> updateHalaqaType(int id, String name) async {
    await _dio.put(
      '/super-admin/halaqa-types/$id',
      data: {'name': name},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> deleteHalaqaType(int id) async {
    await _dio.delete(
      '/super-admin/halaqa-types/$id',
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  // Future<List<StudentProgressStage>> getProgressStages() async {
  //   final response = await _dio.get(
  //     '/super-admin/progress-stages',
  //     options: Options(
  //       headers: {'Authorization': 'Bearer ${await _getToken()}'},
  //     ),
  //   );
  //   return (response.data as List)
  //       .map((json) => StudentProgressStage.fromJson(json))
  //       .toList();
  // }

  Future<void> addProgressStage(String name) async {
    await _dio.post(
      '/super-admin/progress-stages',
      data: {'stage_name': name},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> updateProgressStage(int id, String name) async {
    await _dio.put(
      '/super-admin/progress-stages/$id',
      data: {'stage_name': name},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> deleteProgressStage(int id) async {
    await _dio.delete(
      '/super-admin/progress-stages/$id',
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<List<Part>> getParts() async {
    final response = await _dio.get(
      '/super-admin/parts',
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
    return (response.data as List).map((json) => Part.fromJson(json)).toList();
  }

  Future<void> addPart(String writing) async {
    await _dio.post(
      '/super-admin/parts',
      data: {'writing': writing},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> updatePart(int id, String writing) async {
    await _dio.put(
      '/super-admin/parts/$id',
      data: {'writing': writing},
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> deletePart(int id) async {
    await _dio.delete(
      '/super-admin/parts/$id',
      options: Options(
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      ),
    );
  }

  Future<void> verifyPassword(String token, String password) async {
    await _dio.post(
      '/profile/verify-password',
      data: {'password': password},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Either<Failure, dynamic>> getProfile({required String token}) async {
    return await _get('/super-admin/profile', token: token);
  }

// في ملف super_admin_api_datasource.dart

// ... (باقي الدوال)

Future<Either<Failure, Map<String, dynamic>>> updateProfile({
  required String token,
  required Map<String, dynamic> data,
}) async {
  // نستخدم safeApiCall مباشرة هنا لأننا نحتاج إلى معالجة خاصة للاستجابة
  return await safeApiCall<Map<String, dynamic>>(() async {
    final response = await _dio.put(
      '/profile/update', // تأكد من أن هذا المسار صحيح
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
    // الخادم يعيد بيانات المستخدم المحدثة، وهي من نوع Map
    // نقوم بإرجاع response.data مباشرة
    return response.data;
  });
}


  // Center Managers
  Future<Either<Failure, List<dynamic>>> getCenterManagers({
    required String token,
  }) async {
    final result = await _get('/super-admin/center-managers', token: token);
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, void>> addCenterManager({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    return await _post(
      '/super-admin/center-managers',
      token: token,
      data: data,
    );
  }

  Future<Either<Failure, void>> updateCenterManager({
    required String token,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    return await _put(
      '/super-admin/center-managers/$id',
      token: token,
      data: data,
    );
  }

  Future<Either<Failure, void>> deleteCenterManager({
    required String token,
    required int id,
  }) async {
    return await _delete('/super-admin/center-managers/$id', token: token);
  }

  // // Halaqas
  // Future<Either<Failure, List<dynamic>>> getHalaqas({
  //   required String token,
  // }) async {
  //   final result = await _get('/super-admin/halaqas', token: token);
  //   return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  // }

  // ... (داخل class SuperAdminApiDatasource)
  Future<Either<Failure, dynamic>> getMosques({
    required String token,
    required int page,
    String? searchQuery,
  }) async {
    return await _get(
      '/super-admin/mosques',
      token: token,
      query: {'page': page, if (searchQuery != null) 'search': searchQuery},
    );
  }

  Future<Either<Failure, void>> addMosque({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    return await _post('/super-admin/mosques', token: token, data: data);
  }

  Future<Either<Failure, void>> updateMosque({
    required String token,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    return await _put('/super-admin/mosques/$id', token: token, data: data);
  }

  Future<Either<Failure, void>> deleteMosque({
    required String token,
    required int id,
  }) async {
    return await _delete('/super-admin/mosques/$id', token: token);
  }

  // ... (داخل class SuperAdminApiDatasource)
  Future<Either<Failure, List<dynamic>>> getHalaqas({
    required String token,
    String? searchQuery,
  }) async {
    final result = await _get(
      '/super-admin/halaqas',
      token: token,
      query: {'search': searchQuery},
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, void>> deleteHalaqa({
    required String token,
    required int id,
  }) async {
    return await _delete('/super-admin/halaqas/$id', token: token);
  }

  // ...
  Future<Either<Failure, void>> addHalaqa({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    return await _post('/super-admin/halaqas', token: token, data: data);
  }

  Future<Either<Failure, void>> updateHalaqa({
    required String token,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    return await _put('/super-admin/halaqas/$id', token: token, data: data);
  }

  Future<Either<Failure, List<dynamic>>> getMosquesByCenter({
    required String token,
    required int centerId,
  }) async {
    final result = await _get(
      '/super-admin/centers/$centerId/mosques',
      token: token,
    );
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, dynamic>> getManagerPrerequisites({
    required String token,
  }) async {
    return await _get(
      '/super-admin/center-managers/prerequisites',
      token: token,
    );
  }

  // Future<Map<String, dynamic>> getStudentDetails(int studentId) async {
  //   final token = await _getToken();
  //   if (token == null) throw Exception('User not authenticated');

  //   final response = await _get(
  //     '/super-admin/students/$studentId',
  //     token: token,
  //   );

  //   // بما أن _get ترجع Either، يجب معالجتها
  //   return response.fold(
  //     (failure) => throw Exception(failure.message),
  //     (data) => data as Map<String, dynamic>,
  //   );
  // }

  Future<void> addStudent(Map<String, dynamic> data) async {
    await _post(
      '/super-admin/students/add',
      data: data,
      token: await _getToken(),
    );
  }

  Future<void> updateStudent(int studentId, Map<String, dynamic> data) async {
    await _put(
      '/super-admin/students/$studentId/update',
      data: data,
      token: await _getToken(),
    );
  }

  // Future<void> deleteStudent(int studentId) async {
  //     await _delete(
  //       '/super-admin/students/$studentId',
  //       token: await _getToken(),
  //     );

  // }

  Future<Either<Failure, void>> deleteStudent({
    required String token,
    required int studentId,
  }) async {
    return await _delete('/super-admin/students/$studentId', token: token);
  }

  // Future<List<dynamic>> getCentersForFilter() async {
  //   final token = await _getToken(); // أولاً، احصل على التوكن
  //   if (token == null) {
  //     // إذا لم يكن هناك توكن، لا ترسل الطلب أصلاً
  //     throw Exception('User not authenticated');
  //   }
  //   // استدعاء _get مع التوكن
  //   final response = await _get(
  //     '/super-admin/reports/centers-list',
  //     token: token, // ✅ تم تمرير التوكن هنا
  //   );
  //   return response.fold(
  //     (l) => [], // إرجاع قائمة فارغة في حالة الخطأ
  //     (r) => r as List<dynamic>,
  //   );
  // }

  // Future<Either<Failure, HalaqasuperModel>> getHalaqasForFilter(
  //   int centerId,
  // ) async {
  //   final token = await _getToken();
  //   if (token == null) {
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله'));
  //   }

  //   // _get ترجع Either بالفعل، لذا سنعيد قيمتها مباشرة
  //   final result = await _get(
  //     '/super-admin/data/centers/$centerId/halaqas',
  //     token: token,
  //   );

  //   // قم بتحويل النتيجة الديناميكية إلى قائمة في حالة النجاح
  //   return result.fold(
  //     (failure) => Left(failure), // أعد الفشل كما هو
  //     (data) {
  //       if (data is List) {
  //         return Right(
  //           data as HalaqasuperModel,
  //         ); // أعد البيانات كقائمة في حالة النجاح
  //       } else {
  //         // إذا كانت البيانات ليست قائمة، فهذا خطأ غير متوقع من الخادم
  //         return const Left(
  //           ServerFailure(message: 'البيانات المستلمة ليست بالتنسيق الصحيح'),
  //         );
  //       }
  //     },
  //   );
  // }
  // ... (داخل class SuperAdminApiDatasource)

  Future<Either<Failure, void>> addTeacher({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    return await _post('/super-admin/teachers', token: token, data: data);
  }

  Future<Either<Failure, void>> updateTeacher({
    required String token,
    required int teacherId,
    required Map<String, dynamic> data,
  }) async {
    // Laravel uses PUT for updates, but sometimes POST is used with a _method field.
    // We'll use PUT as it's more conventional.
    return await _put(
      '/super-admin/teachers/$teacherId',
      token: token,
      data: data,
    );
  }

  Future<Either<Failure, List<dynamic>>> getTeacherHalaqas({
    required String token,
    required int teacherId,
  }) async {
    final result = await _get(
      '/super-admin/data/teachers/$teacherId/halaqas',
      token: token,
    );
    // ✅ التصحيح: تحويل dynamic إلى List<dynamic>
    return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
  }

  Future<Either<Failure, List<Map<String, dynamic>>>>
  getCentersForFilter() async {
    final token = await _getToken();
    if (token == null)
      return Left(CacheFailure(message: 'User not authenticated'));

    final result = await _get(
      '/super-admin/reports/centers-list',
      token: token,
    );

    return result.fold((failure) => Left(failure), (data) {
      if (data is List) {
        // التأكد من أن كل عنصر هو Map
        return Right(List<Map<String, dynamic>>.from(data));
      }
      return Left(ServerFailure(message: 'Invalid format for centers list'));
    });
  }

  // ✅ إصلاح: هذه الدالة يجب أن تعيد قائمة من الخرائط (Maps)
  Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter(
    int centerId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return Left(CacheFailure(message: 'User not authenticated'));

    print('--- 1. DATASOURCE: Requesting halaqas for center ID: $centerId ---');

    final result = await _get(
      '/super-admin/centers/$centerId/halaqas', // ✅ تأكد 100% أن هذا المسار صحيح
      token: token,
    );

    return result.fold(
      (failure) {
        print(
          '--- 1.1. DATASOURCE ERROR: Failed to get data. Error: ${failure.message} ---',
        );
        return Left(failure);
      },
      (data) {
        print('--- 1.2. DATASOURCE SUCCESS: Received raw data: $data ---');
        if (data is List) {
          final halaqas = List<Map<String, dynamic>>.from(data);
          print(
            '--- 1.3. DATASOURCE PARSED: Successfully parsed into List<Map>. Count: ${halaqas.length} ---',
          );
          return Right(halaqas);
        }
        print(
          '--- 1.4. DATASOURCE FORMAT ERROR: Received data is NOT a List. Type is ${data.runtimeType} ---',
        );
        return Left(ServerFailure(message: 'Invalid format for halaqas list'));
      },
    );
  }

  // ✅ إصلاح: هذه الدالة يجب أن تعيد قائمة من كائنات StudentProgressStage
  Future<Either<Failure, List<StudentProgressStage>>>
  getProgressStages() async {
    final token = await _getToken();
    if (token == null)
      return Left(CacheFailure(message: 'User not authenticated'));

    final result = await _get('/super-admin/progress-stages', token: token);

    return result.fold((failure) => Left(failure), (data) {
      if (data is List) {
        try {
          final stages =
              data.map((json) => StudentProgressStage.fromJson(json)).toList();
          return Right(stages);
        } catch (e) {
          return Left(
            ServerFailure(message: 'Error parsing progress stages: $e'),
          );
        }
      }
      return Left(ServerFailure(message: 'Invalid format for progress stages'));
    });
  }

  // ✅ إصلاح: هذه الدالة يجب أن تعيد كائن StudentDetails
  Future<Either<Failure, StudentDetails>> getStudentDetails(
    int studentId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return Left(CacheFailure(message: 'User not authenticated'));

    final result = await _get(
      '/super-admin/students/$studentId', // تأكد من أن هذا المسار يستدعي دالة getStudentDetails في Laravel
      token: token,
    );

    return result.fold((failure) => Left(failure), (data) {
      try {
        return Right(StudentDetails.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        return Left(
          ServerFailure(message: 'Error parsing student details: $e'),
        );
      }
    });
  }
}

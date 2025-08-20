// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_admain_center/core/constants/app_routes.dart';
// import 'package:flutter_admain_center/core/error/failures.dart';
// import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
// import 'package:intl/intl.dart';

// class SuperAdminApiDatasource {
//   final Dio _dio;

//   SuperAdminApiDatasource()
//     : _dio = Dio(
//         BaseOptions(
//           baseUrl: AppRoutes.url, // Assuming AppRoutes.url is defined
//           connectTimeout: const Duration(seconds: 20),
//           receiveTimeout: const Duration(seconds: 20),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//   Future<Either<Failure, Map<String, dynamic>>> _get(
//     String path, {
//     String? token,
//     Map<String, dynamic>? query,
//   }) async {
//     return await safeApiCall(() async {
//       final response = await _dio.get(
//         path,
//         queryParameters: query,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       return response.data;
//     });
//   }

//   Future<Either<Failure, void>> _post(
//     String path, {
//     String? token,
//     required Map<String, dynamic> data,
//   }) async {
//     return await safeApiCall(() async {
//       await _dio.post(
//         path,
//         data: data,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//     });
//   }

//   Future<Either<Failure, void>> _put(
//     String path, {
//     String? token,
//     required Map<String, dynamic> data,
//   }) async {
//     return await safeApiCall(() async {
//       await _dio.put(
//         path,
//         data: data,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//     });
//   }

//   Future<Either<Failure, void>> _delete(String path, {String? token}) async {
//     return await safeApiCall(() async {
//       await _dio.delete(
//         path,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//     });
//   }

//   // --- Implementations ---

//   Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary({
//     required String token,
//   }) async {
//     return await _get('/super-admin/dashboard', token: token);
//   }

//   Future<Either<Failure, Map<String, dynamic>>> getCenters({
//     required String token,
//     required int page,
//     String? searchQuery,
//   }) async {
//     return await _get(
//       '/super-admin/centers',
//       token: token,
//       query: {'page': page, if (searchQuery != null) 'search': searchQuery},
//     );
//   }

//   Future<Either<Failure, void>> deleteCenter({
//     required String token,
//     required int centerId,
//   }) async {
//     return await _delete('/super-admin/centers/$centerId', token: token);
//   }

//   Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers({
//     required String token,
//   }) async {
//     final result = await _get('/super-admin/potential-managers', token: token);
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(List<Map<String, dynamic>>.from(r as Iterable)),
//     );
//   }

//   Future<Either<Failure, void>> createCenter({
//     required String token,
//     required Map<String, dynamic> data,
//   }) async {
//     return await _post('/super-admin/centers', token: token, data: data);
//   }

//   Future<Either<Failure, void>> updateCenter({
//     required String token,
//     required int centerId,
//     required Map<String, dynamic> data,
//   }) async {
//     return await _put(
//       '/super-admin/centers/$centerId',
//       token: token,
//       data: data,
//     );
//   }

//   Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({
//     required String token,
//     required int page,
//     String? searchQuery,
//   }) async {
//     return await _get(
//       '/super-admin/teachers',
//       token: token,
//       query: {'page': page, if (searchQuery != null) 'search': searchQuery},
//     );
//   }

//  Future<Either<Failure, List<dynamic>>> getPendingTeachers({required String token}) async {
//     // The _get helper now correctly returns Either<Failure, dynamic>
//     final result = await _get('/super-admin/teachers/pending', token: token);

//     return result.fold(
//       (failure) => Left(failure),
//       (data) => Right(data as List<dynamic>),
//     );
// }

//   Future<Either<Failure, void>> approveTeacher({
//     required String token,
//     required int userId,
//   }) async {
//     return await safeApiCall(
//       () async => await _dio.post(
//         '/super-admin/teachers/approve/$userId',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       ),
//     );
//   }

//   Future<Either<Failure, void>> rejectTeacher({
//     required String token,
//     required int userId,
//   }) async {
//     return await safeApiCall(
//       () async => await _dio.post(
//         '/super-admin/teachers/reject/$userId',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       ),
//     );
//   }

//   Future<Either<Failure, Map<String, dynamic>>> getAllStudents({
//     required String token,
//     required int page,
//     String? searchQuery,
//     int? centerId,
//     int? halaqaId,
//   }) async {
//     return await _get(
//       '/super-admin/students',
//       token: token,
//       query: {
//         'page': page,
//         if (searchQuery != null) 'search': searchQuery,
//         if (centerId != null) 'center_id': centerId,
//         if (halaqaId != null) 'halaqa_id': halaqaId,
//       },
//     );
//   }
//   // ... (inside SuperAdminApiDatasource class)
//   Future<Either<Failure, List<dynamic>>> getRoles({required String token}) async {
//     final result = await _get('/super-admin/roles', token: token);
//     return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
//   }

//   Future<Either<Failure, Map<String, dynamic>>> getPermissions({required String token}) async {
//     final result = await _get('/super-admin/permissions', token: token);
//     return result.fold((l) => Left(l), (r) => Right(r));
//   }

//   Future<Either<Failure, void>> syncPermissionsToRole({required String token, required int roleId, required List<int> permissionIds}) async {
//     return await _post('/super-admin/roles/sync-permissions', token: token, data: {
//       'role_id': roleId,
//       'permissions': permissionIds,
//     });
//   }
//  Future<Either<Failure, List<dynamic>>> getStudentReport({required String token, DateTime? startDate, DateTime? endDate}) async {
//     final result = await _get('/super-admin/reports/students', token: token, query: {
//       if (startDate != null) 'start_date': DateFormat('yyyy-MM-dd').format(startDate),
//       if (endDate != null) 'end_date': DateFormat('yyyy-MM-dd').format(endDate),
//     });
//     return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
//   }

//   Future<Either<Failure, List<dynamic>>> getTeacherReport({required String token}) async {
//     final result = await _get('/super-admin/reports/teachers', token: token);
//     return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
//   }

//   Future<Either<Failure, List<dynamic>>> getAttendanceReport({required String token, required DateTime startDate, required DateTime endDate, int? centerId}) async {
//     final result = await _get('/super-admin/reports/attendance', token: token, query: {
//       'start_date': DateFormat('yyyy-MM-dd').format(startDate),
//       'end_date': DateFormat('yyyy-MM-dd').format(endDate),
//       if (centerId != null) 'center_id': centerId,
//     });
//     return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
//   }

//   Future<Either<Failure, List<dynamic>>> getCentersList({required String token}) async {
//     final result = await _get('/super-admin/reports/centers-list', token: token);
//     return result.fold((l) => Left(l), (r) => Right(r as List<dynamic>));
//   }

// }import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:intl/intl.dart';

class SuperAdminApiDatasource {
  final Dio _dio;

  SuperAdminApiDatasource()
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
    required String token,
  }) async {
    final result = await _get('/super-admin/potential-managers', token: token);
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
}

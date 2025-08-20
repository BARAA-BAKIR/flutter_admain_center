// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_admain_center/core/error/failures.dart';
// import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
// import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
// import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
// import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SuperAdminRepositoryImpl implements SuperAdminRepository {
//   final SuperAdminApiDatasource datasource;
//   final FlutterSecureStorage storage;

//   SuperAdminRepositoryImpl({required this.datasource, required this.storage});

//   Future<String?> _getToken() async {
//     final userData = await storage.read(key: 'user_data');
//     if (userData == null) return null;
//     return jsonDecode(userData)['token'];
//   }

//   // ... (All previous methods are correct and complete)
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary() async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.getDashboardSummary(token: token);
//   }

//   @override
//   Future<Either<Failure, Map<String, dynamic>>> getCenters({
//     required int page,
//     String? searchQuery,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.getCenters(
//       token: token,
//       page: page,
//       searchQuery: searchQuery,
//     );
//   }

//   @override
//   Future<Either<Failure, void>> deleteCenter(int centerId) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.deleteCenter(token: token, centerId: centerId);
//   }

//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>>
//   getPotentialManagers() async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.getPotentialManagers(token: token);
//   }

//   @override
//   Future<Either<Failure, void>> createCenter(Map<String, dynamic> data) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.createCenter(token: token, data: data);
//   }

//   @override
//   Future<Either<Failure, void>> updateCenter({
//     required int centerId,
//     required Map<String, dynamic> data,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.updateCenter(
//       token: token,
//       centerId: centerId,
//       data: data,
//     );
//   }

//   @override
//   Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({
//     required int page,
//     String? searchQuery,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.getApprovedTeachers(
//       token: token,
//       page: page,
//       searchQuery: searchQuery,
//     );
//   }

//   @override
//   Future<Either<Failure, List<PendingUser>>> getPendingTeachers() async {
//     final token = await _getToken();
//     if (token == null) {
//       return const Left(CacheFailure(message: 'User not logged in'));
//     }
//     final result = await datasource.getPendingTeachers(token: token);
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(r.map((json) => PendingUser.fromJson(json)).toList()),
//     );
//   }

//   @override
//   Future<Either<Failure, void>> approveTeacher(int userId) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.approveTeacher(token: token, userId: userId);
//   }

//   @override
//   Future<Either<Failure, void>> rejectTeacher(int userId) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.rejectTeacher(token: token, userId: userId);
//   }

//   @override
//   Future<Either<Failure, Map<String, dynamic>>> getAllStudents({
//     required int page,
//     String? searchQuery,
//     int? centerId,
//     int? halaqaId,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.getAllStudents(
//       token: token,
//       page: page,
//       searchQuery: searchQuery,
//       centerId: centerId,
//       halaqaId: halaqaId,
//     );
//   }

//   @override
//   Future<Either<Failure, List<Role>>> getRoles() async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     final result = await datasource.getRoles(token: token);
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(r.map((json) => Role.fromJson(json)).toList()),
//     );
//   }

//   @override
//   Future<Either<Failure, Map<String, List<Permission>>>>
//   getPermissions() async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     final result = await datasource.getPermissions(token: token);
//     return result.fold((l) => Left(l), (r) {
//       final Map<String, List<Permission>> permissionMap = {};
//       r.forEach((key, value) {
//         permissionMap[key] =
//             (value as List).map((p) => Permission.fromJson(p)).toList();
//       });
//       return Right(permissionMap);
//     });
//   }

//   @override
//   Future<Either<Failure, void>> syncPermissionsToRole({
//     required int roleId,
//     required List<int> permissionIds,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     return await datasource.syncPermissionsToRole(
//       token: token,
//       roleId: roleId,
//       permissionIds: permissionIds,
//     );
//   }

//   // ✅ --- تنفيذ الدوال الناقصة ---
//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({
//     required DateTime startDate,
//     required DateTime endDate,
//     int? centerId,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     final result = await datasource.getAttendanceReport(
//       token: token,
//       startDate: startDate,
//       endDate: endDate,
//       centerId: centerId,
//     );
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(List<Map<String, dynamic>>.from(r)),
//     );
//   }

//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList() async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     final result = await datasource.getCentersList(token: token);
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(List<Map<String, dynamic>>.from(r)),
//     );
//   }

//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>> getStudentReport({
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final token = await _getToken();
//     if (token == null)
//       return const Left(CacheFailure(message: 'User not logged in'));
//     final result = await datasource.getStudentReport(
//       token: token,
//       startDate: startDate,
//       endDate: endDate,
//     );
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(List<Map<String, dynamic>>.from(r)),
//     );
//   }

//   @override
//   Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherReport() async {
//     final token = await _getToken();
//     if (token == null) {
//       return const Left(CacheFailure(message: 'User not logged in'));
//     }
//     final result = await datasource.getTeacherReport(token: token);
//     return result.fold(
//       (l) => Left(l),
//       (r) => Right(List<Map<String, dynamic>>.from(r)),
//     );
//   }
// }import 'dart:convert';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
// ✅ ---  1. استيراد الموديلات الناقصة ---
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';
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
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getDashboardSummary(token: token);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCenters({required int page, String? searchQuery}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getCenters(token: token, page: page, searchQuery: searchQuery);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getPotentialManagers(token: token);
    return result.fold((l) => Left(l), (r) => Right(List<Map<String, dynamic>>.from(r)));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({required int page, String? searchQuery}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getApprovedTeachers(token: token, page: page, searchQuery: searchQuery);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllStudents({required int page, String? searchQuery, int? centerId, int? halaqaId}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getAllStudents(token: token, page: page, searchQuery: searchQuery, centerId: centerId, halaqaId: halaqaId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudentReport({DateTime? startDate, DateTime? endDate}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getStudentReport(token: token, startDate: startDate, endDate: endDate);
    return result.fold((l) => Left(l), (r) => Right(List<Map<String, dynamic>>.from(r)));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({required DateTime startDate, required DateTime endDate, int? centerId}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getAttendanceReport(token: token, startDate: startDate, endDate: endDate, centerId: centerId);
    return result.fold((l) => Left(l), (r) => Right(List<Map<String, dynamic>>.from(r)));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherReport() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getTeacherReport(token: token);
    return result.fold((l) => Left(l), (r) => Right(List<Map<String, dynamic>>.from(r)));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getCentersList(token: token);
    return result.fold((l) => Left(l), (r) => Right(List<Map<String, dynamic>>.from(r)));
  }

  // --- الدوال التي لا تحتاج تعديل (لأنها void أو تم تحويلها مسبقاً) ---
  @override
  Future<Either<Failure, void>> deleteCenter(int centerId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.deleteCenter(token: token, centerId: centerId);
  }

  @override
  Future<Either<Failure, void>> createCenter(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.createCenter(token: token, data: data);
  }

  @override
  Future<Either<Failure, void>> updateCenter({required int centerId, required Map<String, dynamic> data}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.updateCenter(token: token, centerId: centerId, data: data);
  }

  @override
  Future<Either<Failure, List<PendingUser>>> getPendingTeachers() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getPendingTeachers(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((json) => PendingUser.fromJson(json)).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> approveTeacher(int userId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.approveTeacher(token: token, userId: userId);
  }

  @override
  Future<Either<Failure, void>> rejectTeacher(int userId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.rejectTeacher(token: token, userId: userId);
  }

  @override
  Future<Either<Failure, List<Role>>> getRoles() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getRoles(token: token);
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((json) => Role.fromJson(json)).toList()),
    );
  }

  @override
  Future<Either<Failure, Map<String, List<Permission>>>> getPermissions() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    final result = await datasource.getPermissions(token: token);
    return result.fold(
      (l) => Left(l),
      (r) {
        final Map<String, List<Permission>> permissionMap = {};
        r.forEach((key, value) {
          permissionMap[key] = (value as List).map((p) => Permission.fromJson(p)).toList();
        });
        return Right(permissionMap);
      },
    );
  }

  @override
  Future<Either<Failure, void>> syncPermissionsToRole({required int roleId, required List<int> permissionIds}) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.syncPermissionsToRole(token: token, roleId: roleId, permissionIds: permissionIds);
  }
}

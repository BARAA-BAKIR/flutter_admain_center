// import 'package:dartz/dartz.dart';
// import 'package:flutter_admain_center/core/error/failures.dart';
// import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
// import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
// import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';

// abstract class SuperAdminRepository {
//   Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary();
//     Future<Either<Failure, List<Map<String, dynamic>>>> getStudentReport({DateTime? startDate, DateTime? endDate});
//   Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({required DateTime startDate, required DateTime endDate, int? centerId});
//   Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherReport();
//   // We will also need a way to get a list of centers for the filter
//   Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList();

//   Future<Either<Failure, Map<String, dynamic>>> getCenters({required int page, String? searchQuery});
//   Future<Either<Failure, void>> deleteCenter(int centerId);
//   Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers();
//   Future<Either<Failure, void>> createCenter(Map<String, dynamic> data);
//   Future<Either<Failure, void>> updateCenter({required int centerId, required Map<String, dynamic> data});
// Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({required int page, String? searchQuery});
//   Future<Either<Failure, List<PendingUser>>> getPendingTeachers();
//   Future<Either<Failure, void>> approveTeacher(int userId);
//   Future<Either<Failure, void>> rejectTeacher(int userId);
//    Future<Either<Failure, Map<String, dynamic>>> getAllStudents({
//     required int page,
//     String? searchQuery,
//     int? centerId,
//     int? halaqaId,
//   });
//    Future<Either<Failure, List<Role>>> getRoles();
//   Future<Either<Failure, Map<String, List<Permission>>>> getPermissions();
//   Future<Either<Failure, void>> syncPermissionsToRole({required int roleId, required List<int> permissionIds});

// }
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/permission_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/role_model.dart';

abstract class SuperAdminRepository {
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary();
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudentReport({DateTime? startDate, DateTime? endDate});
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({required DateTime startDate, required DateTime endDate, int? centerId});
  Future<Either<Failure, List<Map<String, dynamic>>>> getTeacherReport();
  Future<Either<Failure, List<Map<String, dynamic>>>> getCentersList();
  Future<Either<Failure, Map<String, dynamic>>> getCenters({required int page, String? searchQuery});
  Future<Either<Failure, void>> deleteCenter(int centerId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getPotentialManagers();
  Future<Either<Failure, void>> createCenter(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateCenter({required int centerId, required Map<String, dynamic> data});
  Future<Either<Failure, Map<String, dynamic>>> getApprovedTeachers({required int page, String? searchQuery});
  Future<Either<Failure, List<PendingUser>>> getPendingTeachers();
  Future<Either<Failure, void>> approveTeacher(int userId);
  Future<Either<Failure, void>> rejectTeacher(int userId);
  Future<Either<Failure, Map<String, dynamic>>> getAllStudents({required int page, String? searchQuery, int? centerId, int? halaqaId});
  Future<Either<Failure, List<Role>>> getRoles();
  Future<Either<Failure, Map<String, List<Permission>>>> getPermissions();
  Future<Either<Failure, void>> syncPermissionsToRole({required int roleId, required List<int> permissionIds});
}

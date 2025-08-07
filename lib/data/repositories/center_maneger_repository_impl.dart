import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/center_maneger_api_datasource.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CenterManegerRepositoryImpl implements CenterManagerRepository {
  final CenterManegerApiDatasource datasource;
    final FlutterSecureStorage storage;
  CenterManegerRepositoryImpl({required this.datasource, required this.storage});

  // الدالة لجلب بيانات الطلاب
  //  @override
  // Future<Either<Failure, Map<String, dynamic>>> getStudents({required int page, String? searchQuery}) async {
  //   final token = await storage.read(key: 'user_data'); // اقرأ بيانات المستخدم
  //   if (token == null) {
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
  //   }
  //   final userToken = jsonDecode(token)['token']; // استخرج التوكن الفعلي

  //   return await datasource.getStudents(
  //     token: userToken,
  //     page: page,
  //     searchQuery: searchQuery,
  //   );
  // }

   @override
  Future<Either<Failure, Map<String, dynamic>>> getHalaqas({required int page, String? searchQuery}) async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final userToken = jsonDecode(userDataJson)['token'];

    return await datasource.getHalaqas(
      token: userToken,
      page: page,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTeachers({required int page, String? searchQuery}) async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final userToken = jsonDecode(userDataJson)['token'];

    return await datasource.getTeachers(
      token: userToken,
      page: page,
      searchQuery: searchQuery,
    );
  }

   @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final userToken = jsonDecode(userDataJson)['token'];

    final result = await datasource.getDashboardSummary(token: userToken);

    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          // هنا نقوم بتحويل الـ Map إلى كائن DashboardSummary مباشرة
          return Right(DashboardSummary.fromJson(data));
        } catch (e) {
          return Left(ParsingFailure(message: 'فشل في تحليل بيانات لوحة التحكم.'));
        }
      },
    );
  }
@override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllStudentsForReport() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final userToken = jsonDecode(userDataJson)['token'];

    final result = await datasource.getAllStudentsForReport(token: userToken);

    return result.fold(
      (failure) => Left(failure),
      // تحويل List<dynamic> إلى List<Map<String, dynamic>>
      (data) => Right(List<Map<String, dynamic>>.from(data)),
    );
  }
@override
Future<Either<Failure, List<LevelModel>>> getLevels() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await datasource.getLevels(token);
    return result.fold(
      (failure) => Left(failure),
      (levels) => Right(levels),
    );
  }
   @override
   Future<Either<Failure, Map<String, dynamic>>> addStudent({
   // required String token,
    required AddStudentModel studentData,
  }) async {
    final result = await datasource.addStudent(
      // token: token,
      studentData: studentData,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }
 Future<String?> _getToken() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) return null;
    return jsonDecode(userDataJson)['token'];
  }
   @override
  Future<Either<Failure, List<Halaqa>>> getHalaqasForSelection() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

    final result = await datasource.getHalaqasForSelection(token: token);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          final List<dynamic> listJson = data;
          final halaqas = listJson.map((json) => Halaqa.fromJson(json)).toList();
          return Right(halaqas);
        } catch (e) {
          return Left(ParsingFailure(message: 'فشل تحليل بيانات الحلقات', details: e.toString()));
        }
      },
    );
  }

    @override
  Future<Either<Failure, void>> deleteStudent(int studentId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.deleteStudent(token: token, studentId: studentId);
  }
  // ... (أضف باقي الدوال بنفس الطريقة لـ update, transfer, getFiltersData)
  // =======================================================

  // تعديل الدالة الحالية
  @override
  Future<Either<Failure, Map<String, dynamic>>> getStudents({
    required int page,
    String? searchQuery,
    int? halaqaId,
    int? levelId,
  }) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.getStudents(
      token: token,
      page: page,
      searchQuery: searchQuery,
      halaqaId: halaqaId,
      levelId: levelId,
    );
  }

    @override
    Future<Either<Failure, void>> addHalaqa(Map<String, dynamic> halaqaData) async {
        final token = await _getToken();
        if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
        final result = await datasource.addHalaqa(token: token, halaqaData: halaqaData);
        // لا نهتم بالبيانات المرجعة، فقط بنجاح العملية
        return result.fold((l) => Left(l), (_) => const Right(null));
    }

    @override
    Future<Either<Failure, void>> deleteHalaqa(int halaqaId) async {
        final token = await _getToken();
        if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
        return await datasource.deleteHalaqa(token: token, halaqaId: halaqaId);
    }

    @override
    Future<Either<Failure, List<Map<String, dynamic>>>> getTeachersForSelection() async {
        final token = await _getToken();
        if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
        return await datasource.getTeachersForSelection(token: token);
    }

     @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReportData({
    required DateTime startDate,
    required DateTime endDate,
    int? halaqaId,
  }) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    
    // تحويل التواريخ إلى نص بصيغة yyyy-MM-dd
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedStartDate = formatter.format(startDate);
    final formattedEndDate = formatter.format(endDate);

    return await datasource.getAttendanceReport(
      token: token,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      halaqaId: halaqaId,
    );
  }
   @override
  Future<Either<Failure, Map<String, dynamic>>> updateStudent({
    required int studentId,
    required Map<String, dynamic> studentData,
  }) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.updateStudent(
      token: token,
      studentId: studentId,
      studentData: studentData,
    );
  }
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData() {
    // TODO: implement getFiltersData
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> transferStudent({required int studentId, required int newHalaqaId}) {
    // TODO: implement transferStudent
    throw UnimplementedError();
  }
}
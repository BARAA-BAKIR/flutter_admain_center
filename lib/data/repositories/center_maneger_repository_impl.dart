import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/center_maneger_api_datasource.dart';
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
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CenterManegerRepositoryImpl implements CenterManagerRepository {
  final CenterManegerApiDatasource datasource;
  final FlutterSecureStorage storage;
  CenterManegerRepositoryImpl({
    required this.datasource,
    required this.storage,
  });

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
  Future<Either<Failure, Map<String, dynamic>>> getHalaqas({
    required int page,
    String? searchQuery,
  }) async {
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
  Future<Either<Failure, Map<String, dynamic>>> getTeachers({
    required int page,
    String? searchQuery,
  }) async {
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
  Future<Either<Failure, DashboardSummaryCenter>> getDashboardSummary() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final userToken = jsonDecode(userDataJson)['token'];

    final result = await datasource.getDashboardSummary(token: userToken);
    print("🔵 [REPOSITORY] 3. Data received from Datasource. Result: $result");
    return result.fold(
      (failure) {
        // ==================== DEBUGGING CODE ====================
        print(
          "❌ [REPOSITORY] 4a. API call failed. Failure: ${failure.message}",
        );
        // ========================================================
        return Left(failure);
      },
      (data) {
        // ==================== DEBUGGING CODE ====================
        print(
          "🔵 [REPOSITORY] 4b. API call successful. Raw data to be parsed: $data",
        );
        // ========================================================
        try {
          final summary = DashboardSummaryCenter.fromJson(data);
          // ==================== DEBUGGING CODE ====================
          print(
            "✅ [REPOSITORY] 5. Parsing successful. Parsed Object: student_count=${summary.studentCount}, present=${summary.presentPercentage}",
          );
          // ========================================================
          return Right(summary);
        } catch (e, stacktrace) {
          // ==================== DEBUGGING CODE ====================
          print("❌ [REPOSITORY] 5. PARSING FAILED! Error: $e");
          print("   Stacktrace: $stacktrace");
          // ========================================================
          return Left(
            ParsingFailure(
              message: 'فشل في تحليل بيانات لوحة التحكم.',
              details: e.toString(),
            ),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getAllStudentsForReport() async {
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
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await datasource.getLevels(token);
    return result.fold((failure) => Left(failure), (levels) => Right(levels));
  }

  @override
  Future<Either<Failure, List<HalaqaNameModel>>>
  getHalaqasForSelection() async {
    // 1. احصل على التوكن
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    }

    // 2. استدعِ الـ datasource
    final result = await datasource.getHalaqasForSelection(token: token);

    // 3. قم بتمرير النتيجة مباشرة كما هي، بدون أي try-catch أو fold أو map
    return result;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required AddStudentModel studentData,
  }) async {
    final token = await _getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    }
    final result = await datasource.addStudent(
      token: token,
      studentData: studentData,
    );
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  Future<String?> _getToken() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) return null;
    return jsonDecode(userDataJson)['token'];
  }

  @override
  Future<Either<Failure, void>> deleteStudent(int studentId) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
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
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.getStudents(
      token: token,
      page: page,
      searchQuery: searchQuery,
      halaqaId: halaqaId,
      levelId: levelId,
    );
  }

  // @override
  // Future<Either<Failure, void>> addHalaqa(
  //   Map<String, dynamic> halaqaData,
  // ) async {
  //   final token = await _getToken();
  //   if (token == null)
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
  //   final result = await datasource.addHalaqa(
  //     token: token,
  //     halaqaData: halaqaData,
  //   );
  //   // لا نهتم بالبيانات المرجعة، فقط بنجاح العملية
  //   return result.fold((l) => Left(l), (_) => const Right(null));
  // }

  @override
  Future<Either<Failure, void>> deleteHalaqa(int halaqaId) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.deleteHalaqa(token: token, halaqaId: halaqaId);
  }

  // @override
  // Future<Either<Failure, List<TeacherSelectionModel>>>
  // getTeachersForSelection() async {
  //   final token = await _getToken();
  //   if (token == null)
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
  //   return await datasource.getTeachersForSelection(token: token);
  // }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReportData({
    required DateTime startDate,
    required DateTime endDate,
    int? halaqaId,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

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
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.updateStudent(
      token: token,
      studentId: studentId,
      studentData: studentData,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

    final result = await datasource.getFiltersData(token: token);
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> transferStudent({
    required int studentId,
    required int newHalaqaId,
  }) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.transferStudent(
      token: token,
      studentId: studentId,
      newHalaqaId: newHalaqaId,
    );
  }
  // في ملف: lib/data/repositories/center_manager_repository_impl.dart

  @override
  Future<Either<Failure, StudentDetails>> getStudentDetails(
    int studentId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

    final result = await datasource.getStudentDetails(
      token: token,
      studentId: studentId,
    );

    return result.fold(
      (failure) {
        print("❌ [Repository] API call failed: ${failure.message}");
        return Left(failure);
      },
      (data) {
        // ==================== هنا هو التعديل الأهم ====================
        print("✅ [Repository] Received JSON data from API:");
        // طباعة الـ JSON بشكل منسق وواضح
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(data);
        print(prettyprint);
        // =============================================================

        try {
          print("  ▶️ Attempting to parse JSON into StudentDetails model...");
          final studentDetails = StudentDetails.fromJson(data);
          print("  ✅ Parsing successful!");
          return Right(studentDetails);
        } catch (e, stackTrace) {
          print("❌❌❌ [Repository] CRITICAL PARSING ERROR: $e");
          print(stackTrace);
          return Left(
            ParsingFailure(message: 'فشل تحليل تفاصيل الطالب: ${e.toString()}'),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<TeacherSelectionModel>>>
  getTeachersForSelection() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    // ✅ ببساطة قم باستدعاء الدالة وتمرير نتيجتها
    return await datasource.getTeachersForSelection(token: token);
  }

  @override
  Future<Either<Failure, List<MosqueSelectionModel>>>
  getMosquesForSelection() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    // ✅ ببساطة قم باستدعاء الدالة وتمرير نتيجتها
    return await datasource.getMosquesForSelection(token: token);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getHalaqaTypesForSelection() async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    // ✅ ببساطة قم باستدعاء الدالة وتمرير نتيجتها
    return await datasource.getHalaqaTypesForSelection(token: token);
  }

  @override
  Future<Either<Failure, void>> addHalaqa(AddHalaqaModel halaqaData) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    // ✅ ببساطة قم باستدعاء الدالة وتمرير نتيجتها
    final result = await datasource.addHalaqa(
      token: token,
      halaqaData: halaqaData,
    );
    // لا نهتم بالبيانات المرتجعة، فقط بنجاح العملية
    return result.fold((l) => Left(l), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getHalaqaForEdit(
    int halaqaId,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.getHalaqaForEdit(halaqaId, token);
  }

  @override
  Future<Either<Failure, void>> updateHalaqa(
    int halaqaId,
    AddHalaqaModel halaqaData,
  ) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.updateHalaqa(halaqaId, halaqaData, token);
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(int teacherId) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));
    return await datasource.deleteTeacher(token: token, teacherId: teacherId);
  }
  @override
  Future<Either<Failure, Teacher>> addTeacher(AddTeacherModel teacherData) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

    // 1. استدعاء مصدر البيانات الذي يرجع Map<String, dynamic>
    final result = await datasource.addTeacher(teacherData, token);

    // 2. استخدام fold لمعالجة النتيجة
    return result.fold(
      // في حالة الفشل، أرجع الخطأ كما هو
      (failure) => Left(failure),
      // في حالة النجاح، تعامل مع الاستجابة مباشرة
      (data) {
        try {
          // ==================== هنا هو الإصلاح الكامل والنهائي ====================
          // الخادم يرجع بيانات الأستاذ مباشرة، وليس داخل مفتاح 'teacher'
          // لذلك، نمرر 'data' كلها إلى fromJson
          return Right(Teacher.fromJson(data));
          // ====================================================================
        } catch (e) {
          // في حالة فشل التحويل، أرجع خطأ واضح
          return Left(
            ParsingFailure(
              message: 'فشل تحليل بيانات الأستاذ الجديد من الخادم.',
              details: e.toString(),
            ),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, TeacherDetailsModel>> getTeacherDetails(
    int teacherId,
  ) async {
    final token = await _getToken();
    final result = await datasource.getTeacherDetails(teacherId, token ?? '');
    return result.fold(
      (f) => Left(f),
      (data) => Right(TeacherDetailsModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, TeacherDetailsModel>> updateTeacherDetails(
    int teacherId,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final result = await datasource.updateTeacherDetails(
      teacherId,
      data,
      token ?? '',
    );
    return result.fold(
      (f) => Left(f),
      (data) => Right(TeacherDetailsModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, Halaqa>> getHalaqaDetails(int halaqaId) async {
    final token = await _getToken();
    if (token == null)
      return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

    final result = await datasource.getHalaqaDetails(
      token: token,
      halaqaId: halaqaId,
    );

    return result.fold((failure) => Left(failure), (data) {
      try {
        // الـ API يرجع بيانات الحلقة مباشرة، نقوم بتحويلها إلى مودل
        return Right(Halaqa.fromJson(data));
      } catch (e) {
        return Left(
          ParsingFailure(
            message: 'فشل تحليل بيانات تفاصيل الحلقة',
            details: e.toString(),
          ),
        );
      }
    });
  }

  // @override
  // Future<Either<Failure, Map<String, dynamic>>> addTeacher(AddTeacherModel teacherData) async {
  //   final token = await _getToken();
  //   if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل'));

  //   return await datasource.addTeacher(token: token, teacherData: teacherData);
  // }
}

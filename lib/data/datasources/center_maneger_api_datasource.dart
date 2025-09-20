import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_teacher_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/halaqa_name_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';

class CenterManegerApiDatasource {
  final Dio _dio;
  static final String _baseUrl = AppRoutes.url;
  CenterManegerApiDatasource()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  ///جلب الحلقات من اجل اختيار حلقة لاضافة طالب
  // في CenterManagerDatasource

  Future<Either<Failure, List<HalaqaNameModel>>> getHalaqasForSelection({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/halaqas-selection',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // ==================== DEBUGGING CODE ====================
      log("--- DATASOURCE CHECK ---");
      log(
        "1. Raw response data type: ${response.data.runtimeType}",
      ); // يجب أن يكون List
      log("2. Raw response data: ${response.data}");
      // ========================================================

      final List<dynamic> data = response.data;
      final result =
          data.map((json) => HalaqaNameModel.fromJson(json)).toList();

      // ==================== DEBUGGING CODE ====================
      log(
        "3. Parsed result type: ${result.runtimeType}",
      ); // يجب أن يكون List<HalaqaNameModel>
      log(
        "4. Parsed result count: ${result.length}",
      ); // يجب أن يكون أكبر من 0
      if (result.isNotEmpty) {
        log(
          "5. First item name: ${result.first.name}",
        ); // يجب أن يطبع اسم الحلقة
      }
      log("--- END DATASOURCE CHECK ---");
      // ========================================================

      return result;
    });
  }

  Future<Either<Failure, List<LevelModel>>> getLevels(String token) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/studentprogressstages/get',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      log('levels : ${response.data['data']}');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LevelModel.fromJson(json)).toList();
    });
  }  

  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required AddStudentModel studentData,
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/center/students',
        data: studentData.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // // الدالة الجديدة لجلب الطلاب
  // Future<Either<Failure, Map<String, dynamic>>> getStudents({
  //   required String token,
  //   required int page,
  //   String? searchQuery,
  // }) async {
  //   return await safeApiCall(() async {
  //     final response = await _dio.get(
  //       '/center/students', // المسار الذي عرفناه في Laravel
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       queryParameters: {
  //         'page': page, // لإرسال رقم الصفحة المطلوبة
  //         if (searchQuery != null) 'search': searchQuery, // لإرسال نص البحث
  //       },
  //     );
  //     return response.data;
  //   });
  // }

  Future<Either<Failure, Map<String, dynamic>>> getCenterData() async {
    try {
      final response = await _dio.get('/center/data');
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateCenterData(
    Map<String, dynamic> data,
  ) async {
    try {
      await _dio.put('/center/update', data: data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // --- الدالة الجديدة لجلب الحلقات ---
  Future<Either<Failure, Map<String, dynamic>>> getHalaqas({
    required String token,
    required int page,
    String? searchQuery,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/halaqas', // المسار الذي عرفناه في Laravel
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );
      return response.data;
    });
  }

  // --- الدالة الجديدة لجلب الأساتذة ---
  Future<Either<Failure, Map<String, dynamic>>> getTeachers({
    required String token,
    required int page,
    String? searchQuery,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/teachers', // المسار الذي عرفناه في Laravel
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );
      return response.data;
    });
  }

  // --- الدالة الجديدة لجلب ملخص لوحة التحكم ---
  Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary({
    required String token,
  }) async {
    log("🔵 [DATASOURCE] 1. Calling getDashboardSummary API...");
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/dashboard-summary',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      log("✅ [DATASOURCE] 2. API Response Received. Data: ${response.data}");
      return response.data;
    });
  }

  // --- الدالة الجديدة لجلب بيانات تقرير الطلاب ---
  Future<Either<Failure, List<dynamic>>> getAllStudentsForReport({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/reports/all-students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // هنا نتوقع قائمة مباشرة، وليس Map
      return response.data as List<dynamic>;
    });
  }

  // 1. جلب بيانات الفلاتر
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/filters-data',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // 2. تعديل الطالب
  Future<Either<Failure, Map<String, dynamic>>> updateStudent({
    required String token,
    required int studentId,
    required Map<String, dynamic> studentData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.put(
        '/center/students/$studentId',
        data: studentData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // 3. نقل الطالب
  Future<Either<Failure, Map<String, dynamic>>> transferStudent({
    required String token,
    required int studentId,
    required int newHalaqaId,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/center/students/$studentId/transfer',
        data: {'new_halaqa_id': newHalaqaId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // 4. حذف الطالب
  Future<Either<Failure, void>> deleteStudent({
    required String token,
    required int studentId,
  }) async {
    return await safeApiCall(() async {
      await _dio.delete(
        '/center/students/$studentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }
  // =======================================================

  // تعديل الدالة الحالية لتقبل الفلاتر
  Future<Either<Failure, Map<String, dynamic>>> getStudents({
    required String token,
    required int page,
    String? searchQuery,
    int? halaqaId, // فلتر الحلقة
    int? levelId, // فلتر المستوى
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/students/for/center/maneger',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'page': page,
          if (searchQuery != null) 'search': searchQuery,
          if (halaqaId != null) 'halaqa_id': halaqaId, // إرسال الفلتر
          if (levelId != null) 'level_id': levelId, // إرسال الفلتر
        },
      );
      log('student : ${response.data}');
      return response.data;
    });
  }

  // Future<Either<Failure, Map<String, dynamic>>> addHalaqa({
  //   required String token,
  //   required Map<String, dynamic> halaqaData,
  // }) async {
  //   return await safeApiCall(() async {
  //     final response = await _dio.post(
  //       '/center/halaqas/add',
  //       data: halaqaData,
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );
  //     return response.data;
  //   });
  // }

  Future<Either<Failure, void>> deleteHalaqa({
    required String token,
    required int halaqaId,
  }) async {
    return await safeApiCall(() async {
      await _dio.delete(
        '/center/halaqas/$halaqaId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getAttendanceReport({
    required String token,
    required String startDate,
    required String endDate,
    int? halaqaId,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/reports/attendance',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
          if (halaqaId != null) 'halaqa_id': halaqaId,
        },
      );
      // الـ API يرجع قائمة مباشرة
      return List<Map<String, dynamic>>.from(response.data);
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getStudentDetails({
    required String token,
    required int studentId,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/students/$studentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // ✅ أصبح يعيد قائمة من النماذج الجاهزة
  Future<Either<Failure, List<TeacherSelectionModel>>> getTeachersForSelection({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/teachers-for-selection',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data;
      // التحويل إلى نماذج يتم هنا فقط
      return data.map((json) => TeacherSelectionModel.fromJson(json)).toList();
    });
  }

  // ✅ أصبح يعيد قائمة من النماذج الجاهزة
  Future<Either<Failure, List<MosqueSelectionModel>>> getMosquesForSelection({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/mosques-for-selection',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data;
      // التحويل إلى نماذج يتم هنا فقط
      return data.map((json) => MosqueSelectionModel.fromJson(json)).toList();
    });
  }

  // ✅ هذه الدالة لا تزال تعيد Map لأنها عامة
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getHalaqaTypesForSelection({required String token}) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/halaqa-types-selection',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return List<Map<String, dynamic>>.from(response.data);
    });
  }

  // ✅ هذه الدالة يجب أن تستقبل المودل مباشرة
  Future<Either<Failure, Map<String, dynamic>>> addHalaqa({
    required String token,
    required AddHalaqaModel halaqaData, // <-- يستقبل المودل
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/center/halaqas/add',
        data: halaqaData.toJson(), // <-- يستخدم دالة toJson
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // دالة لجلب بيانات الحلقة للتعديل
  Future<Either<Failure, Map<String, dynamic>>> getHalaqaForEdit(
    int halaqaId,
    String token,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/halaqas/$halaqaId/edit',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  // دالة لإرسال التحديثات
  Future<Either<Failure, void>> updateHalaqa(
    int halaqaId,
    AddHalaqaModel halaqaData,
    String token,
  ) async {
    return await safeApiCall(() async {
      await _dio.put(
        // استخدام PUT للتحديث
        '/center/halaqas/$halaqaId',
        data: halaqaData.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }

  Future<Either<Failure, void>> deleteTeacher({
    required String token,
    required int teacherId,
  }) async {
    return await safeApiCall(() async {
      await _dio.delete(
        '/center/teachers/$teacherId', // افترض أن هذا هو المسار الصحيح
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> addTeacher(
    AddTeacherModel data,
    String token,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/center/teacher/add',
        data: data.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      log(
        "✅ [DATASOURCE] Success! Status: ${response.statusCode}, Response: ${response.data}",
      );

      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getTeacherDetails(
    int teacherId,
    String token,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/teachers/$teacherId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> updateTeacherDetails(
    int teacherId,
    Map<String, dynamic> data,
    String token,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.put(
        '/center/teacher/update/$teacherId',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }
// In lib/data/datasources/center_maneger_api_datasource.dart
// In lib/data/datasources/center_maneger_api_datasource.dart

Future<Either<Failure, Map<String, dynamic>>> getHalaqaDetails({
  required String token,
  required int halaqaId,
}) async {
  // ✅ safeApiCall يجب أن يغلف كل شيء، بما في ذلك الوصول إلى response.data
  return await safeApiCall<Map<String, dynamic>>(() async {
    final response = await _dio.get(
      '/center/halaqas/$halaqaId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // 🔴 الخطأ المحتمل يحدث هنا. إذا لم يكن response.data من نوع Map<String, dynamic>
    // أو إذا لم يكن يحتوي على مفتاح 'data', سيحدث Exception.
    
    // ✅ الحل: تحقق من النوع قبل إرجاعه
    if (response.data is Map<String, dynamic>) {
      // افترض أن البيانات الفعلية موجودة داخل مفتاح 'data'
      final responseData = response.data;
      if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
        // print('✅ RAW JSON (data key): ${responseData['data']}');
        return responseData['data'] as Map<String, dynamic>;
      } else {
        // إذا لم يكن هناك مفتاح 'data', افترض أن البيانات هي الكائن بأكمله
        print('✅ RAW JSON (root): ${response.data}');
        return response.data;
      }
    } else {
      // إذا كانت البيانات ليست Map, فهذا خطأ في التنسيق من الخادم
      throw const ParsingFailure(message: 'تنسيق البيانات المستلمة من الخادم غير صحيح.');
    }
  });
}


  // دالة لجلب تقرير الطلاب
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudentsReport({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/reports/students', // تأكد من أن المسار يبدأ بـ '/'
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // بما أن الـ API يرجع قائمة، نقوم بتحويلها مباشرة
      return List<Map<String, dynamic>>.from(response.data);
    });
  }

  // دالة لجلب تقرير الأساتذة
  Future<Either<Failure, List<Map<String, dynamic>>>> getTeachersReport({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/reports/teachers', // تأكد من أن المسار يبدأ بـ '/'
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // بما أن الـ API يرجع قائمة، نقوم بتحويلها مباشرة
      return List<Map<String, dynamic>>.from(response.data);
    });
  }
  // ... (داخل CenterManegerApiDatasource)

  Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForFilter({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/filters/halaqas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return List<Map<String, dynamic>>.from(response.data);
    });
  }

  /// ✅ جلب قائمة المساجد مع ترقيم الصفحات والبحث
  Future<Either<Failure, Map<String, dynamic>>> getMosques({
    required String token,
    required int page,
    String? searchQuery,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/mosques',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );
      return response.data;
    });
  }

  /// ✅ إنشاء مسجد جديد
  Future<Either<Failure, Map<String, dynamic>>> createMosque({
    required String token,
    required Map<String, dynamic> mosqueData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/center/mosques/create',
        data: mosqueData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  /// ✅ حذف مسجد
  Future<Either<Failure, Map<String, dynamic>>> deleteMosque({
    required String token,
    required int mosqueId,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.delete(
        '/center/mosques/$mosqueId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }
    Future<Either<Failure, Map<String, dynamic>>> updateMosque({
    required String token,
    required int mosqueId,
    required Map<String, dynamic> mosqueData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.put(
        '/center/mosques/$mosqueId', // استخدام PUT للتحديث
        data: mosqueData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }
}

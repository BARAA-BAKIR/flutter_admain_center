import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';

class CenterManegerApiDatasource {
  final Dio _dio;
  static const String _baseUrl = "http://192.168.1.10:8000/api";
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

  Future<Either<Failure, List<LevelModel>>> getLevels(String token) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/studentprogressstages/get',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LevelModel.fromJson(json)).toList();
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required AddStudentModel studentData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/add/student/to/center',
        data: studentData.toJson(),
        // options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/dashboard-summary',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
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

  ///جلب الحلقات من اجل اختيار حلقة لاضافة طالب
  Future<Either<Failure, List<Map<String, dynamic>>>> getHalaqasForSelection({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/halaqas-selection',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    });
  }


   // 1. جلب بيانات الفلاتر
  Future<Either<Failure, Map<String, dynamic>>> getFiltersData({required String token}) async {
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
    int? levelId,  // فلتر المستوى
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/center/students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'page': page,
          if (searchQuery != null) 'search': searchQuery,
          if (halaqaId != null) 'halaqa_id': halaqaId, // إرسال الفلتر
          if (levelId != null) 'level_id': levelId,   // إرسال الفلتر
        },
      );
      return response.data;
    });
  }

      // ==================== دوال إدارة الحلقات ====================
    Future<Either<Failure, Map<String, dynamic>>> addHalaqa({
        required String token,
        required Map<String, dynamic> halaqaData,
    }) async {
        return await safeApiCall(() async {
            final response = await _dio.post('/center/halaqas', data: halaqaData, options: Options(headers: {'Authorization': 'Bearer $token'}));
            return response.data;
        });
    }

    Future<Either<Failure, void>> deleteHalaqa({
        required String token,
        required int halaqaId,
    }) async {
        return await safeApiCall(() async {
            await _dio.delete('/center/halaqas/$halaqaId', options: Options(headers: {'Authorization': 'Bearer $token'}));
        });
    }

    Future<Either<Failure, List<Map<String, dynamic>>>> getTeachersForSelection({required String token}) async {
        return await safeApiCall(() async {
            final response = await _dio.get('/center/teachers-for-selection', options: Options(headers: {'Authorization': 'Bearer $token'}));
            // نفترض أن الـ API يرجع قائمة مباشرة
            return List<Map<String, dynamic>>.from(response.data['data']);
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
  
}

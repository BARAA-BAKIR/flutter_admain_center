// lib/data/datasources/teacher_api_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:dartz/dartz.dart';

class TeacherApiDatasource {
  final Dio _dio;

  static final String _baseUrl =AppRoutes.url;

  TeacherApiDatasource()
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

  Future<Either<Failure, Map<String, dynamic>>> getMyHalaqa(String token) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/get/myhalaqa/full/for/teacher/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

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
    required String token,
    required AddStudentModel studentData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/add/student/to/halaqa',
        data: studentData.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> storeFollowUp({
    required String token,
    required Map<String, dynamic> followUpData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/followup/store',
        data: followUpData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> storeDuty({
    required String token,
    required Map<String, dynamic> dutyData,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/duty/store',
        data: dutyData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> syncBulkData({
    required String token,
    required List<Map<String, dynamic>> followUps,
    required List<Map<String, dynamic>> duties,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/sync/bulk',
        data: {
          'follow_ups': followUps,
          'duties': duties,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getStudentProfile(String token, int studentId) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/student/$studentId/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchHalaqaInfo(String token, int halaqaId) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/halaqa/$halaqaId/info',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchLatestStudentData({
    required String token,
    required int studentId,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/student/$studentId/latest-data',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final responseData = response.data as Map<String, dynamic>;
      final DailyFollowUpModel? followUp = responseData['followUp'] != null
          ? DailyFollowUpModel.fromJson(responseData['followUp'])
          : null;
      final DutyModel? duty = responseData['duty'] != null
          ? DutyModel.fromJson(responseData['duty'])
          : null;

      // هنا يمكنك إرجاع الـ Map مباشرةً، والمستودع يقوم بالتحويل لاحقاً
      return {'followUp': followUp, 'duty': duty};
    });
  }
Future<Either<Failure, Map<String, dynamic>>> getDashboardSummary({
  required String token,
  required int halaqaId,
}) async {
  print("🌐 [Datasource] إرسال GET إلى /halaqa/$halaqaId/dashboard-summary");
  print("📌 [Datasource] Header: Bearer $token");
  return await safeApiCall(() async {
    final response = await _dio.get(
      '/halaqa/$halaqaId/dashboard-summary',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print("📩 [Datasource] الاستجابة من السيرفر: ${response.data}");
    return response.data;
  });
}
  /// يجلب الملف الشخصي للأستاذ من الـ API
  Future<Either<Failure, Map<String, dynamic>>> getTeacherProfile(String token) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/teacher/profile', // المسار الجديد
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // الـ API الجديد يرجع البيانات داخل مفتاح 'data'
      return response.data['data']; 
    });
  }

  /// يرسل بيانات الملف الشخصي المحدثة إلى الـ API
  Future<Either<Failure, Map<String, dynamic>>> updateTeacherProfile({
    required String token,
    String? firstName, // اجعلها اختيارية
    String? lastName,
    String? phone,
    String? address,
    required String currentPassword, // كلمة المرور الحالية مطلوبة
  }) async {
    return await safeApiCall(() async {
      final Map<String, dynamic> data = {
        'current_password': currentPassword,
      };
      // أضف الحقول فقط إذا لم تكن فارغة
      if (firstName != null && firstName.isNotEmpty) data['first_name'] = firstName;
      if (lastName != null && lastName.isNotEmpty) data['last_name'] = lastName;
      if (phone != null && phone.isNotEmpty) data['phone_number'] = phone;
      if (address != null && address.isNotEmpty) data['address'] = address;

      final response = await _dio.post(
        '/teacher/profile', // المسار الجديد
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: data,
      );
      // الـ API الجديد يرجع البيانات المحدثة داخل مفتاح 'data'
      return response.data['data'];
    });
  }

   Future<Either<Failure, Map<String, dynamic>>> getNotifications(String token) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/teacher/notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, void>> markNotificationAsRead(String token, String notificationId) async {
    return await safeApiCall(() async {
      await _dio.post(
        '/notifications/$notificationId/mark-as-read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }
}
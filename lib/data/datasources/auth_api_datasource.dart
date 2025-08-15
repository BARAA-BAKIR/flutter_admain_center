// lib/data/datasources/auth_api_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart'; // تأكد من استيراد كلاسات الأخطاء
import 'package:flutter_admain_center/core/utils/safe_api_call.dart'; // استيراد الدالة المساعدة
import 'package:flutter_admain_center/data/models/teacher/center_model.dart';
import 'package:flutter_admain_center/data/models/teacher/registration_model.dart';
import 'package:dartz/dartz.dart';

class AuthApiDatasource {
  final Dio _dio;

  static final String _baseUrl =AppRoutes.url;

  AuthApiDatasource()
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

   Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password, 'fcm_token': fcmToken},
      );
      
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      // هذا الخطأ يظهر إذا لم تكن الاستجابة من نوع JSON Map
      throw Exception('Invalid data format from login response.');
    });
  }
  Future<Either<Failure, List<CenterModel>>> getCenters() async {
    return await safeApiCall(() async {
      final response = await _dio.get('/centers');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CenterModel.fromJson(json)).toList();
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> registerTeacher(
    RegistrationModel registrationData,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/register/teacher',
        data: registrationData.toJson(),
      );
      return response.data;
    });
  }

  Future<Either<Failure, void>> forgotPassword(String email) async {
    return await safeApiCall(() async {
      await _dio.post('/forgot-password', data: {'email': email});
      return;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/student/auth/change-password',
        data: {
         
          'password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchProfile(
    String token,
  ) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/teacher/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    required String passwordConfirm,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.post(
        '/teacher/profile/update',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'name': name,
          'phone_number': phone,
          'address': address,
          'password_confirm': passwordConfirm,
        },
      );
      return response.data;
    });
  }

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dio.post(
        '/reset-password', // هذا هو المسار في Laravel
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return const Right(null); // نجح الأمر
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

 Future<Either<Failure, void>> logout({required String token}) async {
    return await safeApiCall(() async {
      await _dio.post(
        '/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return;
    });
  }
Future<Either<Failure, void>> updateNotificationStatus({
    required bool status,
    required String token,
  }) async {
    return await safeApiCall(() async {
      // ignore: unused_local_variable
      final response = await _dio.put( // استخدام _dio.put بدلاً من http.put
        '/settings/notifications', // المسار الصحيح بدون baseUrl لأنه موجود في BaseOptions
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'enabled': status}, // تمرير البيانات مباشرة كـ Map
      );
      return; // لا نحتاج لإرجاع بيانات، فقط void
    });
  }
}

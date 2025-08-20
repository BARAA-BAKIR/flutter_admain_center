// في lib/data/datasources/notifications_api_datasource.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/core/utils/safe_api_call.dart';

class NotificationsApiDatasource {
  final Dio _dio;

  NotificationsApiDatasource()
    : _dio = Dio(BaseOptions(baseUrl: AppRoutes.url));

  Future<Either<Failure, int>> getUnreadCount({required String token}) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/notifications/unread-count',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['unread_count'] as int;
    });
  }

  Future<Either<Failure, List<dynamic>>> getNotifications({
    required String token,
  }) async {
    return await safeApiCall(() async {
      final response = await _dio.get(
        '/notifications', // المسار الذي عرفناه في Laravel
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // الـ API يرجع Map يحتوي على 'data' التي هي قائمة الإشعارات
      return response.data['data'] as List<dynamic>;
    });
  }

  // دالة لإرسال طلب تحديد إشعار كمقروء
  Future<Either<Failure, void>> markAsRead({
    required String token,
    required String notificationId,
  }) async {
    return await safeApiCall(() async {
      await _dio.post(
        '/notifications/$notificationId/mark-as-read', // المسار الديناميكي
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }

  
  Future<Either<Failure, void>> approveTeacher({
    required String token, required int teacherId
  }) async {
    return await safeApiCall(() async {
      await _dio.post(
        '/teachers/$teacherId/approve',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }

  Future<Either<Failure, void>> rejectTeacher({
    required String token, required int teacherId
  }) async {
    return await safeApiCall(() async {
      await _dio.post(
        '/teachers/$teacherId/reject',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    });
  }
}

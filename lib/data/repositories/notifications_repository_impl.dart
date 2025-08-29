// في lib/data/repositories/notifications_repository_impl.dart
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/notifications_api_datasource.dart';
import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart'as NotificationModelcenter;
import 'package:flutter_admain_center/data/models/super_admin/notification_model.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsApiDatasource datasource;
  final FlutterSecureStorage storage;

  NotificationsRepositoryImpl({required this.datasource, required this.storage});

  Future<String?> _getToken() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) return null;
    return jsonDecode(userDataJson)['token'];
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.getUnreadCount(token: token);
  }


@override
Future<Either<Failure, List<NotificationModelcenter.NotificationModel>>> getNotifications() async {
  final token = await _getToken();
  if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
  
  final result = await datasource.getNotifications(token: token);
  
  return result.fold(
    (failure) => Left(failure),
    (data) {
      // ==================== هنا هو الإصلاح ====================
      // سنقوم بلف عملية التحليل داخل try-catch
      try {
        // التأكد من أن 'data' هي قائمة قبل محاولة استخدام map
        // ignore: unnecessary_type_check
        if (data is! List) {
          return Left(ParsingFailure(message: 'Invalid data format received from server. Expected a List.'));
        }
        final notifications = data.map((json) => NotificationModelcenter.NotificationModel.fromJson(json)).toList();
        return Right(notifications);
      } catch (e, stacktrace) {
        // إذا حدث أي خطأ أثناء التحليل، سنرجعه كـ Failure
        print("Error parsing notifications: $e");
        print(stacktrace);
        return Left(ParsingFailure(message: 'Failed to parse notifications: ${e.toString()}'));
      }
      // =======================================================
    },
  );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.markAsRead(token: token, notificationId: notificationId);
  }
  @override
  Future<Either<Failure, void>> approveTeacher(int teacherId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.approveTeacher(token: token, teacherId: teacherId);
  }

  @override
  Future<Either<Failure, void>> rejectTeacher(int teacherId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.rejectTeacher(token: token, teacherId: teacherId);
  }
  @override
  Future<Either<Failure, int>> getUnreadCountforadmin() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.getUnreadCount(token: token);
  }


@override
Future<Either<Failure, List<NotificationModel>>> getNotificationsforadmin() async {
  final token = await _getToken();
  if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
  
  final result = await datasource.getNotifications(token: token);
  
  return result.fold(
    (failure) => Left(failure),
    (data) {
      // ==================== هنا هو الإصلاح ====================
      // سنقوم بلف عملية التحليل داخل try-catch
      try {
        // التأكد من أن 'data' هي قائمة قبل محاولة استخدام map
        // ignore: unnecessary_type_check
        if (data is! List) {
          return Left(ParsingFailure(message: 'Invalid data format received from server. Expected a List.'));
        }
        final notifications = data.map((json) => NotificationModel.fromJson(json)).toList();
        return Right(notifications);
      } catch (e, stacktrace) {
        // إذا حدث أي خطأ أثناء التحليل، سنرجعه كـ Failure
        print("Error parsing notifications: $e");
        print(stacktrace);
        return Left(ParsingFailure(message: 'Failed to parse notifications: ${e.toString()}'));
      }
      // =======================================================
    },
  );
  }

  @override
  Future<Either<Failure, void>> markAsReadforadmin(String notificationId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.markAsRead(token: token, notificationId: notificationId);
  }
  @override
  Future<Either<Failure, void>> approveTeacherforadmin(int teacherId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.approveTeacher(token: token, teacherId: teacherId);
  }

  @override
  Future<Either<Failure, void>> rejectTeacherforadmin(int teacherId) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));
    return await datasource.rejectTeacher(token: token, teacherId: teacherId);
  }

}

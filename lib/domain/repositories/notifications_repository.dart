// في lib/domain/repositories/notifications_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';

abstract class NotificationsRepository {
  // دالة لجلب عدد الإشعارات غير المقروءة
  Future<Either<Failure, int>> getUnreadCount();

  // دالة لجلب قائمة الإشعارات
  Future<Either<Failure, List<NotificationModel>>> getNotifications();

  // دالة لتحديد إشعار كمقروء
  Future<Either<Failure, void>> markAsRead(String notificationId);
   Future<Either<Failure, void>> approveTeacher(int teacherId);
  Future<Either<Failure, void>> rejectTeacher(int teacherId);

}

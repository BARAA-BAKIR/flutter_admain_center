part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object> get props => [];
}

class LoadNotificationsCount extends NotificationsEvent {}

class LoadNotificationDetails extends NotificationsEvent {}

// ✅ 3. تعديل الأحداث لتكون صحيحة
class ApproveRequest extends NotificationsEvent {
  final String notificationId;
  final int userId;

  const ApproveRequest({required this.notificationId, required this.userId});

  @override
  List<Object> get props => [notificationId, userId];
}

class RejectRequest extends NotificationsEvent {
  final String notificationId;
  final int userId;

  const RejectRequest({required this.notificationId, required this.userId});

  @override
  List<Object> get props => [notificationId, userId];
}

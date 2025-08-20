// في lib/features/center_manager/bloc/notifications_event.dart

part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object> get props => [];
}

class FetchUnreadCount extends NotificationsEvent {}
class FetchNotifications extends NotificationsEvent {}
class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;
  const MarkNotificationAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

// ==================== هنا هي الإضافات الجديدة ====================
class ApproveTeacherRequest extends NotificationsEvent {
  final String notificationId;
  final int teacherId;

  const ApproveTeacherRequest(this.notificationId, this.teacherId);

  @override
  List<Object> get props => [notificationId, teacherId];
}

class RejectTeacherRequest extends NotificationsEvent {
  final String notificationId;
  final int teacherId;

  const RejectTeacherRequest(this.notificationId, this.teacherId);

  @override
  List<Object> get props => [notificationId, teacherId];
}
// ===============================================================

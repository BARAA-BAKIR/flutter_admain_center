// part of 'notification_bloc.dart';

// abstract class NotificationEvent extends Equatable {
//   const NotificationEvent();
//   @override
//   List<Object> get props => [];
// }

// class FetchNotifications extends NotificationEvent {}
// class MarkAsRead extends NotificationEvent {
//   final String notificationId;
//   const MarkAsRead(this.notificationId);
// }
part of 'notification_bloc.dart';

abstract class NotificationsEvent {}

class FetchNotifications extends NotificationsEvent {}

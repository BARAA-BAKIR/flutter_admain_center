// part of 'notification_bloc.dart';

// // مودل لتمثيل الإشعار في الواجهة
// class AppNotification extends Equatable {
//   final String id;
//   final String title;
//   final String body;
//   final DateTime createdAt;
//   final bool isRead;

//   const AppNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.createdAt,
//     required this.isRead,
//   });

//   factory AppNotification.fromJson(Map<String, dynamic> json) {
//     return AppNotification(
//       id: json['id'],
//       title: json['data']['title'], // البيانات تكون داخل حقل 'data' في Laravel
//       body: json['data']['body'],
//       createdAt: DateTime.parse(json['created_at']),
//       isRead: json['read_at'] != null,
//     );
//   }
  
//   @override
//   List<Object?> get props => [id, isRead];
// }

// enum NotificationStatus { initial, loading, success, failure }

// class NotificationState extends Equatable {
//   final NotificationStatus status;
//   final List<AppNotification> notifications;
//   final bool hasReachedMax;
//   final String? errorMessage;

//   const NotificationState({
//     this.status = NotificationStatus.initial,
//     this.notifications = const [],
//     this.hasReachedMax = false,
//     this.errorMessage,
//   });

//   NotificationState copyWith({
//     NotificationStatus? status,
//     List<AppNotification>? notifications,
//     bool? hasReachedMax,
//     String? errorMessage,
//   }) {
//     return NotificationState(
//       status: status ?? this.status,
//       notifications: notifications ?? this.notifications,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//       errorMessage: errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [status, notifications, hasReachedMax, errorMessage];
// }
part of 'notification_bloc.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  final NotificationsStatus status;
  final List<NotificationModel> notifications;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}

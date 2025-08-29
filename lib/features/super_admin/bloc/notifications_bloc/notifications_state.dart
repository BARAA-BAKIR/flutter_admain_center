part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState {
  const NotificationsState();
}

// الحالة الأولية
class NotificationsInitial extends NotificationsState {}

// حالة جاري التحميل
class NotificationsLoading extends NotificationsState {}

// حالة النجاح بعد تحميل العدد فقط (يمكن استخدامها في شاشة الإعدادات)
class NotificationsCountLoaded extends NotificationsState {
  final int unreadCount;
  const NotificationsCountLoaded({required this.unreadCount});
}

// *** الحالة الجديدة: النجاح بعد تحميل القائمة الكاملة للطلبات ***
class NotificationsDetailsLoaded extends NotificationsState {
  final List<NotificationModel> notifications; // قائمة من موديل الإشعارات
  const NotificationsDetailsLoaded({required this.notifications});
}

// حالة الفشل
class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError({required this.message});
}

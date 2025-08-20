import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/notification_model.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  NotificationsBloc({required NotificationsRepository notificationsRepository})
      : _notificationsRepository = notificationsRepository,
        super(const NotificationsState()) {
    on<FetchUnreadCount>(_onFetchUnreadCount);
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
     on<ApproveTeacherRequest>(_onApproveTeacherRequest);
    on<RejectTeacherRequest>(_onRejectTeacherRequest);

  }
Future<void> _onApproveTeacherRequest(
    ApproveTeacherRequest event, Emitter<NotificationsState> emit
  ) async {
    // أضف حالة تحميل مؤقتة إذا أردت
    final result = await _notificationsRepository.approveTeacher(event.teacherId);
    result.fold(
      (failure) {  print("❌ FAILED TO APPROVE TEACHER: ${failure.message}");},
      (_) {print("✅ SUCCESSFULLY APPROVED TEACHER on server.");
        // عند النجاح، قم بتحديث القائمة لإزالة الإشعار
        final updatedList = state.notifications.where((n) => n.id != event.notificationId).toList();
        emit(state.copyWith(notifications: updatedList));
        // ثم قم بتحديث العدد
        add(FetchUnreadCount());
      },
    );
  }

  // دالة لمعالجة حدث الرفض
  Future<void> _onRejectTeacherRequest(
    RejectTeacherRequest event, Emitter<NotificationsState> emit
  ) async {
    // أضف حالة تحميل مؤقتة إذا أردت
    final result = await _notificationsRepository.rejectTeacher(event.teacherId);
    result.fold(
      (failure) {  print("❌ FAILED TO REJECT TEACHER: ${failure.message}"); },
      (_) { print("✅ SUCCESSFULLY REJECTED TEACHER on server.");
        // عند النجاح، قم بتحديث القائمة لإزالة الإشعار
        final updatedList = state.notifications.where((n) => n.id != event.notificationId).toList();
        emit(state.copyWith(notifications: updatedList));
        // ثم قم بتحديث العدد
        add(FetchUnreadCount());
      },
    );
  }

  Future<void> _onFetchUnreadCount(
    FetchUnreadCount event, Emitter<NotificationsState> emit
  ) async {
    final result = await _notificationsRepository.getUnreadCount();
    result.fold(
      (failure) { /* يمكنك معالجة الخطأ هنا */ },
      (count) => emit(state.copyWith(unreadCount: count)),
    );
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event, Emitter<NotificationsState> emit
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await _notificationsRepository.getNotifications();
    result.fold(
      (failure) => emit(state.copyWith(status: NotificationsStatus.failure, errorMessage: failure.message)),
      (notifications) => emit(state.copyWith(status: NotificationsStatus.success, notifications: notifications)),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event, Emitter<NotificationsState> emit
  ) async {
    // أولاً، نحدث الحالة في الواجهة فوراً لتجربة مستخدم أفضل
    final updatedList = state.notifications.map((n) {
      return n.id == event.notificationId ? n.copyWith(isRead: true) : n;
    }).toList();
    emit(state.copyWith(notifications: updatedList));

    // ثانياً، نرسل الطلب إلى الخادم في الخلفية
    final result = await _notificationsRepository.markAsRead(event.notificationId);
    result.fold(
      (failure) { /* يمكنك معالجة الخطأ هنا إذا فشل الطلب */ },
      (_) {
        // ثالثاً، نعيد جلب العدد غير المقروء لتحديث الأيقونة في AppBar
        add(FetchUnreadCount());
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // ✅ استيراد foundation
import 'package:flutter_admain_center/data/models/super_admin/notification_model.dart' show NotificationModel;
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository repository;

  NotificationsBloc({required this.repository}) : super(NotificationsInitial()) {
    on<LoadNotificationsCount>(_onLoadCount);
    on<LoadNotificationDetails>(_onLoadDetails);
    on<ApproveRequest>(_onApprove);
    on<RejectRequest>(_onReject);
  }

  Future<void> _onLoadCount(LoadNotificationsCount event, Emitter<NotificationsState> emit) async {
    final result = await repository.getUnreadCountforadmin();
    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (count) => emit(NotificationsCountLoaded(unreadCount: count)),
    );
  }

  Future<void> _onLoadDetails(LoadNotificationDetails event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    final result = await repository.getNotificationsforadmin();
    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) => emit(NotificationsDetailsLoaded(notifications: notifications.cast<NotificationModel>())),
    );
  }

  Future<void> _onApprove(ApproveRequest event, Emitter<NotificationsState> emit) async {
    final result = await repository.approveTeacherforadmin(event.userId);
    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (_) => add(LoadNotificationDetails()),
    );
  }

  Future<void> _onReject(RejectRequest event, Emitter<NotificationsState> emit) async {
    final result = await repository.rejectTeacherforadmin(event.userId);
    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (_) => add(LoadNotificationDetails()),
    );
  }
}

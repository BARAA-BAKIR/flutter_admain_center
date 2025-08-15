// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

// part 'notification_event.dart';
// part 'notification_state.dart';

// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   final TeacherRepository _teacherRepository;
//   int _currentPage = 1;

//   NotificationBloc({required TeacherRepository teacherRepository})
//       : _teacherRepository = teacherRepository,
//         super(const NotificationState()) {
//     on<FetchNotifications>(_onFetchNotifications);
//     on<MarkAsRead>(_onMarkAsRead);
//   }

//   Future<void> _onFetchNotifications(FetchNotifications event, Emitter<NotificationState> emit) async {
//     if (state.hasReachedMax) return;

//     emit(state.copyWith(status: NotificationStatus.loading));

//     final result = await _teacherRepository.getNotifications(_currentPage);

//     result.fold(
//       (failure) => emit(state.copyWith(status: NotificationStatus.failure, errorMessage: failure.message)),
//       (data) {
//         final List<dynamic> notificationsJson = data['data'];
//         final newNotifications = notificationsJson.map((json) => AppNotification.fromJson(json)).toList();
        
//         emit(state.copyWith(
//           status: NotificationStatus.success,
//           notifications: List.of(state.notifications)..addAll(newNotifications),
//           hasReachedMax: data['next_page_url'] == null,
//         ));
//         _currentPage++;
//       },
//     );
//   }

//   Future<void> _onMarkAsRead(MarkAsRead event, Emitter<NotificationState> emit) async {
//     // تحديث الواجهة فوراً لتجربة مستخدم أفضل
//     final updatedList = state.notifications.map((n) {
//       if (n.id == event.notificationId) {
//         return AppNotification(id: n.id, title: n.title, body: n.body, createdAt: n.createdAt, isRead: true);
//       }
//       return n;
//     }).toList();
//     emit(state.copyWith(notifications: updatedList));

//     // إرسال الطلب للخادم في الخلفية
//     await _teacherRepository.markNotificationAsRead(event.notificationId);
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/data/models/teacher/notification_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final TeacherRepository _teacherRepository;

  NotificationsBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const NotificationsState()) {
    on<FetchNotifications>(_onFetchNotifications);
  }

  Future<void> _onFetchNotifications(FetchNotifications event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await _teacherRepository.getNotifications(1);
    result.fold(
      (failure) => emit(state.copyWith(status: NotificationsStatus.failure, errorMessage: failure.message)),
      (notifications) => emit(state.copyWith(status: NotificationsStatus.success, notifications: notifications as List<NotificationModel>)),
    );
  }
}

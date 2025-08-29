
// import 'package:bloc/bloc.dart';
// import 'package:flutter_admain_center/data/models/teacher/notification_model.dart';
// import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

// part 'notification_event.dart';
// part 'notification_state.dart';

// class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
//   final TeacherRepository _teacherRepository;

//   NotificationsBloc({required TeacherRepository teacherRepository})
//       : _teacherRepository = teacherRepository,
//         super(const NotificationsState()) {
//     on<FetchNotifications>(_onFetchNotifications);
//   }

//   Future<void> _onFetchNotifications(FetchNotifications event, Emitter<NotificationsState> emit) async {
//     emit(state.copyWith(status: NotificationsStatus.loading));
//     final result = await _teacherRepository.getNotifications(1);
//     result.fold(
//       (failure) => emit(state.copyWith(status: NotificationsStatus.failure, errorMessage: failure.message)),
//       (notifications) => emit(state.copyWith(status: NotificationsStatus.success, notifications: notifications as List<NotificationModel>)),
//     );
//   }
// }
// في lib/features/teacher/bloc/notifications/notification_bloc.dart

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

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    // يمكنك إضافة التعامل مع رقم الصفحة لاحقًا إذا أردت عمل pagination
    if (state.status == NotificationsStatus.loading) return;

    emit(state.copyWith(status: NotificationsStatus.loading));

    // استدعاء الـ repository (يمكنك تمرير رقم الصفحة هنا لاحقًا)
    final result = await _teacherRepository.getNotifications(1);

    result.fold(
      // حالة الفشل
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: failure.message,
      )),
      // حالة النجاح
      (data) {
        // ====================  هنا هو الحل الكامل والنهائي ====================
        try {
          // 1. استخرج قائمة الإشعارات من الـ Map باستخدام المفتاح 'notifications'
          final List<NotificationModel> notifications = data['notifications'];
          
          // 2. (اختياري) يمكنك استخراج بيانات الـ meta إذا احتجتها للـ pagination
          // final Map<String, dynamic> meta = data['meta'];

          // 3. قم بإصدار حالة النجاح مع القائمة الصحيحة
          emit(state.copyWith(
            status: NotificationsStatus.success,
            notifications: notifications,
          ));
        } catch (e) {
          // إذا حدث خطأ أثناء استخراج البيانات (مثلاً، المفتاح غير موجود)
          emit(state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: 'خطأ في تحليل بيانات الإشعارات: ${e.toString()}',
          ));
        }
        // =====================================================================
      },
    );
  }
}

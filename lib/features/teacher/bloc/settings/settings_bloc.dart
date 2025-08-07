import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
 final AuthRepository authRepository; // **أضف هذا**

  SettingsBloc({required this.authRepository}) : super(const SettingsState()) {
    on<LoadSettings>((event, emit) async {
      // قم بجلب حالة الإشعارات من الـ API عند بدء تشغيل التطبيق أو البلوك
      // هذا يتطلب دالة إضافية لجلب إعدادات المستخدم من الخادم
      // ولكن للتبسيط يمكنك افتراض أنها مفعلة في البداية
    });

    on<ToggleNotifications>((event, emit) async {
      final newStatus = !state.isNotificationsEnabled;
      emit(state.copyWith(isNotificationsEnabled: newStatus));

      // **استدعاء Repository هنا**
      final result = await authRepository.updateNotificationStatus(newStatus);
      result.fold(
        (failure) {
          // في حال فشل الطلب، يمكنك إعادة الحالة إلى وضعها السابق
          emit(state.copyWith(isNotificationsEnabled: !newStatus));
          // وعرض رسالة خطأ للمستخدم
        },
        (success) {
          // النجاح، لا تفعل شيئاً
        },
      );
    });
  }
}
// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_admain_center/data/models/teacher/user_model.dart';
// import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;

//   AuthBloc({required this.authRepository}) : super(AuthInitial()) {
//     on<AppStarted>(_onAppStarted);
//     on<LoggedIn>(_onLoggedIn);
//     on<LoggedOut>(_onLoggedOut);
//   }

//   Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
//     final userJson = await authRepository.getUserData();
//     if (userJson != null) {
//       try {
//         final data = jsonDecode(userJson);
//         final user = UserModel(
//           id: data['id'],
//           name: data['name'],
//           email: data['email'],
//           token: data['token'],
//           roles: List<String>.from(data['roles']),
//         );
//         emit(AuthAuthenticated(user: user));
//       } catch (e) {
//         emit(AuthUnauthenticated());
//       }
//     } else {
//       emit(AuthUnauthenticated());
//     }
//   }

//   void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
//     emit(AuthAuthenticated(user: event.user));
//   }

//   Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
//     await authRepository.logout();
//     emit(AuthUnauthenticated());
//   }
// }
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/teacher/user_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
// استيراد خدمة الإشعارات
import 'package:flutter_admain_center/core/services/notification_service.dart'; 

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  // إضافة خدمة الإشعارات
  final NotificationService notificationService;

  AuthBloc({
    required this.authRepository,
    required this.notificationService, // <-- إضافة هنا
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final userJson = await authRepository.getUserData();
    if (userJson != null) {
      try {
        final data = jsonDecode(userJson);
        final user = UserModel.fromJson(data); // استخدام fromJson أفضل
        emit(AuthAuthenticated(user: user));
        // عند بدء التطبيق والمستخدم مسجل دخوله، نرسل التوكن أيضاً
        _updateFcmToken(); 
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // ==================== هنا هو التعديل الأهم ====================
  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(user: event.user));
    // بعد تسجيل الدخول مباشرة، قم بتحديث التوكن في الخادم
    _updateFcmToken();
  }
  // =============================================================

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    // يمكنك هنا إضافة منطق لحذف التوكن من الخادم إذا أردت
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  // دالة مساعدة لتجنب تكرار الكود
  Future<void> _updateFcmToken() async {
    try {
      final fcmToken = await notificationService.getFcmToken();
      if (fcmToken != null) {
        await authRepository.updateFcmToken(fcmToken);
        print("FCM Token sent to server: $fcmToken");
      }
    } catch (e) {
      print("Failed to send FCM token to server: $e");
    }
  }
}

// lib/features/auth/bloc/login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // <-- استيراد مهم
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthBloc _authBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // <-- إنشاء نسخة

  LoginBloc({
    required LoginUseCase loginUseCase,
    required AuthBloc authBloc,
  })  : _loginUseCase = loginUseCase,
        _authBloc = authBloc,
        super(const LoginState()) {
    on<LoginRequested>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.loading));
      try {
        // --- تعديل هنا: جلب التوكن قبل إرسال الطلب ---
        String? fcmToken;
        try {
          fcmToken = await _firebaseMessaging.getToken();
          print("Obtained FCM Token for login: $fcmToken");
        } catch (e) {
          print("Failed to get FCM token: $e");
          // يمكن الاستمرار بدون التوكن إذا فشل جلبه
        }

        // إرسال الطلب مع التوكن
        final result = await _loginUseCase(event.email, event.password, fcmToken);

        if (result['success']) {
          final String token = result['data']['token'];
          
          // await _storage.write(key: 'auth_token', value: event.token);
          _authBloc.add(LoggedIn(token: token));
          emit(state.copyWith(status: LoginStatus.success));
        } else {
          emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: result['message'],
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'حدث خطأ غير متوقع: ${e.toString()}',
        ));
      }
    });
  }
}

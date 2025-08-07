import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthBloc authBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  LoginBloc({
    required this.loginUseCase,
    required this.authBloc,
  }) : super(const LoginState()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      
      // الإصلاح: استدعاء الـ UseCase باستخدام named arguments
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
        fcmToken: fcmToken,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: LoginStatus.failure, errorMessage: failure.message));
        },
        (user) { // <-- النتيجة هنا هي UserModel مباشرة
          authBloc.add(LoggedIn(user: user));
          emit(state.copyWith(status: LoginStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: 'حدث خطأ غير متوقع'));
    }
  }
}

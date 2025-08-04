// lib/features/auth/bloc/login_state.dart
part of 'login_bloc.dart';

// استخدام enum لتحديد الحالة بشكل أوضح
enum LoginStatus { initial, loading, success, failure }

final class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

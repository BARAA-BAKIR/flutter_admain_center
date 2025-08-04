// lib/features/auth/bloc/login_event.dart
part of 'login_bloc.dart';

sealed class LoginEvent {}

// --- الحدث الرئيسي: عند الضغط على زر تسجيل الدخول ---
// يحمل هذا الحدث البريد الإلكتروني وكلمة المرور التي أدخلها المستخدم
final class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

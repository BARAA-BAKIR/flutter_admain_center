// lib/features/auth/bloc/auth_state.dart
part of 'auth_bloc.dart';

sealed class AuthState {}

// --- الحالة الأولى: الحالة الابتدائية قبل التحقق ---
// يمكن استخدامها لعرض شاشة Splash Screen
final class AuthInitial extends AuthState {}

// --- الحالة الثانية: المستخدم مسجل دخوله بنجاح ---
// يمكن أن تحمل بيانات المستخدم إذا أردنا
final class AuthAuthenticated extends AuthState {
  // final UserModel user;
  // AuthAuthenticated({required this.user});
}

// --- الحالة الثالثة: المستخدم غير مسجل دخوله ---
final class AuthUnauthenticated extends AuthState {}

// --- الحالة الرابعة: جاري التحميل (مثل عند تسجيل الدخول أو الخروج) ---
final class AuthLoading extends AuthState {}

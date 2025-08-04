// lib/features/auth/bloc/auth_event.dart
part of 'auth_bloc.dart';

sealed class AuthEvent {}
 
// --- الحدث الأول: يتم إرساله عند بدء تشغيل التطبيق ---
// ليقوم الـ Bloc بالتحقق من وجود توكن محفوظ
final class AppStarted extends AuthEvent {}

// --- الحدث الثاني: يتم إرساله عند نجاح تسجيل الدخول ---
// يحمل هذا الحدث التوكن الذي تم استلامه من الـ API
final class LoggedIn extends AuthEvent {
  final String token;
//   final _storage = const FlutterSecureStorage();
//  await _storage.write(key: 'auth_token', value: event.token);
    
  LoggedIn({required this.token});
}

// --- الحدث الثالث: يتم إرساله عند الضغط على زر تسجيل الخروج ---
final class LoggedOut extends AuthEvent {}

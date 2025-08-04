// lib/features/auth/bloc/auth_bloc.dart
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ستحتاج إلى خدمة لتخزين التوكن بشكل آمن، مثل flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // مثال على استخدام التخزين الآمن
  final _storage = const FlutterSecureStorage();

  AuthBloc({required AuthRepository authRepository}) : super(AuthInitial()) {
    // --- معالج حدث بدء التطبيق ---
    on<AppStarted>((event, emit) async {
      // هنا تضع منطق التحقق من وجود توكن محفوظ
      final String? token = await _storage.read(key: 'auth_token');

      if (token != null && token.isNotEmpty) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    // --- معالج حدث تسجيل الدخول ---
    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      // حفظ التوكن في التخزين الآمن
      await _storage.write(key: 'auth_token', value: event.token);
      emit(AuthAuthenticated());
    });

    // --- معالج حدث تسجيل الخروج ---
    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      // حذف التوكن من التخزين الآمن
      await _storage.delete(key: 'auth_token');
      emit(AuthUnauthenticated());
    });
  }
}

// // class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
// //   final Dio dio;

// //   LogoutBloc(this.dio) : super(LogoutInitial()) {
// //     on<PerformLogout>((event, emit) async {
// //       emit(LogoutLoading());
// //       try {
// //         final response = await dio.post('/logout', data: {'email': event.email});
// //         if (response.statusCode == 200) {
// //           emit(LogoutSuccess());
// //         } else {
// //           emit(LogoutFailure('فشل تسجيل الخروج'));
// //         }
// //       } catch (e) {
// //         emit(LogoutFailure('حدث خطأ: ${e.toString()}'));
// //       }
// //     });
// //   }
// // }

import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/features/auth/bloc/logout/logout_event.dart';
import 'package:flutter_admain_center/features/auth/bloc/logout/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository authRepository;

  LogoutBloc(this.authRepository) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}

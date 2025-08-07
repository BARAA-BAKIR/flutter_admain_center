import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// تأكد من أن هذا المسار صحيح
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

// هنا نخبر Dart أن ملفات الحدث والحالة هي أجزاء من هذا الملف
part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordBloc({required this.authRepository}) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.resetPassword(
      email: event.email,
      token: event.token,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );

    result.fold(
      (failure) => emit(ResetPasswordFailure(error: failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}

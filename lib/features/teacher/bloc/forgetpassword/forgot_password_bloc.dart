import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc(this.authRepository) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await authRepository.forgotPassword(event.email);
      result.fold(
        (failure) => emit(ForgotPasswordFailure(error: failure.message)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    });
  }
}

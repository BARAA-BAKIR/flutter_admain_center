// change_password_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthRepository repository;

  ChangePasswordBloc({required this.repository})
      : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    // validation already في الواجهة
    emit(ChangePasswordLoading());
    final result = await repository.changePassword(
      current: event.current,
      newPassword: event.newPassword,
      confirm: event.confirm,
    );

    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}

// change_password_state.dart

part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  ChangePasswordFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// هذا هو السطر الأهم. يخبر Dart أن هذا الملف هو "جزء من" ملف البلوك الرئيسي.
part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  const ResetPasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
}

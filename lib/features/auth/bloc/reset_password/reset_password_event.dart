// هذا هو السطر الأهم. يخبر Dart أن هذا الملف هو "جزء من" ملف البلوك الرئيسي.
part of 'reset_password_bloc.dart';

// اجعل الكلاس الأساسي تجريدياً
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

// هذا الكلاس يرث من الكلاس الأساسي
class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordSubmitted({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [email, token, password, passwordConfirmation];
}

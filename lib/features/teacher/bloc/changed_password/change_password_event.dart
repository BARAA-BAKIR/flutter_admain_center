// change_password_event.dart

part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String current;
  final String newPassword;
  final String confirm;

  ChangePasswordSubmitted({
    required this.current,
    required this.newPassword,
    required this.confirm,
  });

  @override
  List<Object?> get props => [current, newPassword, confirm];
}

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

// الإصلاح: يستقبل كائن UserModel
class LoggedIn extends AuthEvent {
  final UserModel user;
  const LoggedIn({required this.user});
  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthEvent {}

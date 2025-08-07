part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

// الإصلاح: يحتوي على كائن UserModel
class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated({required this.user});
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}
class LoggedIn extends AuthEvent {
  final UserModel user;
  const LoggedIn({required this.user});
}

// ❌ احذف هذا الحدث، لم نعد بحاجته هنا
// class LoggedOut extends AuthEvent {}

// ✅ --- أضف هذا الحدث الجديد والمحسن --- ✅
// هذا الحدث سيتم إرساله من واجهة المستخدم لطلب الخروج
class AuthLogoutRequested extends AuthEvent {}

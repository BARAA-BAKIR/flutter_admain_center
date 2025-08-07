abstract class LogoutEvent {}

class PerformLogout extends LogoutEvent {
  final String email;
  PerformLogout(this.email);
}
class LogoutRequested extends LogoutEvent {}
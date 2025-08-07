part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isNotificationsEnabled;

  const SettingsState({this.isNotificationsEnabled = true});

  @override
  List<Object> get props => [isNotificationsEnabled];

  SettingsState copyWith({
    bool? isNotificationsEnabled,
  }) {
    return SettingsState(
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }
}
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class ProfileFetched extends ProfileEvent {}

class PasswordVerifiedForEdit extends ProfileEvent {
  final String password;
  const PasswordVerifiedForEdit({required this.password});
  @override
  List<Object> get props => [password];
}

class ProfileInfoUpdated extends ProfileEvent {
  final Map<String, dynamic> data;
  const ProfileInfoUpdated({required this.data});
  @override
  List<Object> get props => [data];
}

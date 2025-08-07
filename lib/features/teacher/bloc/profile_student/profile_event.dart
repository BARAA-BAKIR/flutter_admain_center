part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class FetchProfileData extends ProfileEvent {
  final int studentId;
  FetchProfileData(this.studentId);
}
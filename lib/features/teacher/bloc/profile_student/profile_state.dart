part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final ProfileStatus status;
  final StudentProfileModel? profile;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    StudentProfileModel? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
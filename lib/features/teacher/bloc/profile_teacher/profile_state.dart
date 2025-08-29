// In lib/features/teacher/bloc/profile_teacher/profile_state.dart

part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }
enum ProfileActionStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileActionStatus actionStatus;
  final TeacherProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.actionStatus = ProfileActionStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileActionStatus? actionStatus,
    TeacherProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, actionStatus, profile, errorMessage];
}

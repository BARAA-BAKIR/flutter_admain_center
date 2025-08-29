part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, submitting, passwordVerified, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileModel? userProfile;
  final String? errorMessage;
  final String? currentPassword; // لحفظ كلمة المرور بعد التحقق

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userProfile,
    this.errorMessage,
    this.currentPassword,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? userProfile,
    String? errorMessage,
    String? currentPassword,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPassword: currentPassword ?? this.currentPassword,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, errorMessage, currentPassword];
}

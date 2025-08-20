// في lib/features/profile/bloc/profile_state.dart

part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure, verifying, updating }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileDetailsModel? profileData;
  final bool isEditModeEnabled;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profileData,
    this.isEditModeEnabled = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileDetailsModel? profileData,
    bool? isEditModeEnabled,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profileData: profileData ?? this.profileData,
      isEditModeEnabled: isEditModeEnabled ?? this.isEditModeEnabled,
      errorMessage: errorMessage, // لا تستخدم القيمة القديمة عند تحديث الحالة
    );
  }

  @override
  List<Object?> get props => [status, profileData, isEditModeEnabled, errorMessage];
}

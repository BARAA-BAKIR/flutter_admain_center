part of 'profile_bloc.dart';

// ✅✅✅ أضف الحالة الجديدة هنا ✅✅✅
enum ProfileActionStatus { initial, loading, success, failure, passwordVerified }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileActionStatus actionStatus; // <-- تم التغيير هنا
  final TeacherProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.actionStatus = ProfileActionStatus.initial, // <-- تم التغيير هنا
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileActionStatus? actionStatus, // <-- تم التغيير هنا
    TeacherProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus, // <-- تم التغيير هنا
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, actionStatus, profile, errorMessage];
}

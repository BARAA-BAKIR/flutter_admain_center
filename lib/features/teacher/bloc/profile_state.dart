part of 'profile_bloc.dart';

// نستخدم enum لتمثيل الحالات المختلفة للواجهة بشكل واضح
enum ProfileStatus { initial, loading, success, failure }

@immutable
class ProfileState {
  final ProfileStatus status;
  final StudentProfileModel? profile;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.error,
  });

  // دالة مساعدة لنسخ الحالة وتحديثها بسهولة
  ProfileState copyWith({
    ProfileStatus? status,
    StudentProfileModel? profile,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error, // لا نستخدم ?? هنا للسماح بمسح الخطأ (جعله null)
    );
  }
}

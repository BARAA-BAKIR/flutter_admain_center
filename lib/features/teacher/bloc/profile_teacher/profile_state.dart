// هذا السطر يخبر Dart أن هذا الملف هو جزء من مكتبة profile_bloc
part of 'profile_bloc.dart';

// هذا هو المكان الأفضل لتعريف حالات الـ enum
enum ProfileStatus { initial, loading, success, failure }
enum ProfileActionStatus { initial, loading, success, failure }

class ProfileState {
  final ProfileStatus status;
  final ProfileActionStatus actionStatus;
  final TeacherProfile? profile; // استخدم موديل الأستاذ
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
      // اسمح بإعادة تعيين رسالة الخطأ إلى null
      errorMessage: errorMessage,
    );
  }
}

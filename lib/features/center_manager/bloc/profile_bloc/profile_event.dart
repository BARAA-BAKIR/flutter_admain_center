// في lib/features/profile/bloc/profile_event.dart

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

// لجلب البيانات عند فتح الشاشة
class FetchProfile extends ProfileEvent {}

// للتحقق من كلمة المرور وتفعيل وضع التعديل
class VerifyPasswordAndEnableEdit extends ProfileEvent {
  final String password;
  const VerifyPasswordAndEnableEdit(this.password);
  @override
  List<Object> get props => [password];
}

// لإرسال التحديثات إلى الخادم
class SubmitProfileUpdate extends ProfileEvent {
  final Map<String, String> data;
  const SubmitProfileUpdate(this.data);
  @override
  List<Object> get props => [data];
}

part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

// هذا هو الحدث الذي يتم إرساله من الواجهة لطلب بيانات الطالب
class FetchProfileData extends ProfileEvent {
  final int studentId;

  FetchProfileData(this.studentId);
}

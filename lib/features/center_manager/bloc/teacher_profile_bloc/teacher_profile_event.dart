part of 'teacher_profile_bloc.dart';

abstract class TeacherProfileEvent extends Equatable {
  const TeacherProfileEvent();

  @override
  List<Object> get props => [];
}

// هذا الحدث سيتم إرساله لجلب بيانات الأستاذ
class FetchTeacherProfile extends TeacherProfileEvent {
  final int teacherId;

  const FetchTeacherProfile(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}

part of 'teacher_profile_bloc.dart';

enum TeacherProfileStatus { initial, loading, success, failure }

class TeacherProfileState extends Equatable {
  const TeacherProfileState({
    this.status = TeacherProfileStatus.initial,
    this.teacherDetails,
    this.errorMessage,
  });

  final TeacherProfileStatus status;
  final TeacherDetailsModel? teacherDetails; // سيحتوي على بيانات الأستاذ التفصيلية
  final String? errorMessage;

  TeacherProfileState copyWith({
    TeacherProfileStatus? status,
    TeacherDetailsModel? teacherDetails,
    String? errorMessage,
  }) {
    return TeacherProfileState(
      status: status ?? this.status,
      teacherDetails: teacherDetails ?? this.teacherDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, teacherDetails, errorMessage];
}

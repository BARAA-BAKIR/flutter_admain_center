part of 'center_add_student_bloc.dart';

abstract class CenterAddStudentEvent extends Equatable {
  const CenterAddStudentEvent();
  @override
  List<Object> get props => [];
}

class FetchCenterInitialData extends CenterAddStudentEvent {}

class CenterStepChanged extends CenterAddStudentEvent {
  final int step;
  const CenterStepChanged(this.step);
}

class CenterGenderChanged extends CenterAddStudentEvent {
  final String gender;
  const CenterGenderChanged(this.gender);
}

class CenterSocialStatusChanged extends CenterAddStudentEvent {
  final String socialStatus;
  const CenterSocialStatusChanged(this.socialStatus);
}

class CenterLevelChanged extends CenterAddStudentEvent {
  final int levelId;
  const CenterLevelChanged(this.levelId);
}

class CenterHalaqaChanged extends CenterAddStudentEvent {
  final int halaqaId;
  const CenterHalaqaChanged(this.halaqaId);
}

class SubmitCenterStudentData extends CenterAddStudentEvent {
  final AddStudentModel studentData;
  const SubmitCenterStudentData(this.studentData);
}

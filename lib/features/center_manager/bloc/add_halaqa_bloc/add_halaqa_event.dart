part of 'add_halaqa_bloc.dart';

abstract class AddHalaqaEvent extends Equatable {
  // ====================  هنا هو الإصلاح ====================
  // إضافة المُنشئ المطلوب من Equatable
  const AddHalaqaEvent();

  @override
  List<Object> get props => [];
  // =======================================================
}

class LoadHalaqaPrerequisites extends AddHalaqaEvent {}

class SubmitNewHalaqa extends AddHalaqaEvent {
  final Map<String, dynamic> data;
  const SubmitNewHalaqa(this.data);

  // ====================  هنا هو الإصلاح ====================
  // إضافة props لـ Equatable
  @override
  List<Object> get props => [data];
  // =======================================================
}

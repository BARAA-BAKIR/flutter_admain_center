part of 'add_halaqa_bloc.dart';

abstract class AddHalaqaEvent extends Equatable {
  const AddHalaqaEvent();
  @override
  List<Object?> get props => [];
}

class LoadHalaqaPrerequisites extends AddHalaqaEvent {}
class AddHalaqaSelectionChanged extends AddHalaqaEvent {
  final TeacherSelectionModel? selectedTeacher;
  final MosqueSelectionModel? selectedMosque;
  final Map<String, dynamic>? selectedHalaqaType;
  // متغير خاص لإلغاء اختيار الأستاذ
  final bool unselectTeacher;

  const AddHalaqaSelectionChanged({
    this.selectedTeacher,
    this.selectedMosque,
    this.selectedHalaqaType,
    this.unselectTeacher = false,
  });
}


class SubmitNewHalaqa extends AddHalaqaEvent {
  final AddHalaqaModel halaqaData;
  const SubmitNewHalaqa(this.halaqaData);
}

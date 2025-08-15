part of 'edit_halaqa_bloc.dart';

abstract class EditHalaqaEvent extends Equatable {
  const EditHalaqaEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllEditData extends EditHalaqaEvent {
  final int halaqaId;
  const LoadAllEditData(this.halaqaId);
}

// حدث جديد وموحد لتغيير أي اختيار في الواجهة
class SelectionChanged extends EditHalaqaEvent {
  final TeacherSelectionModel? selectedTeacher;
  final MosqueSelectionModel? selectedMosque;
  final Map<String, dynamic>? selectedHalaqaType;
  // متغير خاص لإلغاء اختيار الأستاذ
  final bool unselectTeacher;

  const SelectionChanged({
    this.selectedTeacher,
    this.selectedMosque,
    this.selectedHalaqaType,
    this.unselectTeacher = false,
  });
}

class SubmitHalaqaUpdate extends EditHalaqaEvent {
  final int halaqaId;
  final AddHalaqaModel halaqaData;
  const SubmitHalaqaUpdate({required this.halaqaId, required this.halaqaData});
}

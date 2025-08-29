part of 'add_edit_halaqa_bloc.dart';
abstract class AddEditHalaqaEvent extends Equatable {
  const AddEditHalaqaEvent();
  @override
  List<Object> get props => [];
}
class LoadHalaqaPrerequisites extends AddEditHalaqaEvent {}
class CenterSelected extends AddEditHalaqaEvent {
  final int centerId;
  const CenterSelected(this.centerId);
}
class SubmitHalaqa extends AddEditHalaqaEvent {
  final Map<String, dynamic> data;
  const SubmitHalaqa(this.data);
}
class SubmitHalaqaUpdate extends AddEditHalaqaEvent {
  final int halaqaId;
  final Map<String, dynamic> data;
  const SubmitHalaqaUpdate(this.halaqaId, this.data);
}
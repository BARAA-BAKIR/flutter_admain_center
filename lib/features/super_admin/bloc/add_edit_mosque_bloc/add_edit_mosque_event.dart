part of 'add_edit_mosque_bloc.dart';

abstract class AddEditMosqueEvent extends Equatable {
  const AddEditMosqueEvent();
  @override
  List<Object> get props => [];
}

// ✅ 1. حدث جديد لجلب البيانات المطلوبة (المراكز)
class LoadMosquePrerequisites extends AddEditMosqueEvent {}

class SubmitNewMosque extends AddEditMosqueEvent {
  final Map<String, dynamic> data;
  const SubmitNewMosque(this.data);
}

class SubmitMosqueUpdate extends AddEditMosqueEvent {
  final Map<String, dynamic> data;
  const SubmitMosqueUpdate(this.data);
}

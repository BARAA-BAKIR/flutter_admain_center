part of 'add_edit_center_bloc.dart';

abstract class AddEditCenterEvent extends Equatable {
  const AddEditCenterEvent();
  @override
  List<Object?> get props => [];
}

// class LoadCenterPrerequisites extends AddEditCenterEvent {
//   final CenterModel? centerToEdit;
//   const LoadCenterPrerequisites({this.centerToEdit});
// }
class LoadCenterPrerequisites extends AddEditCenterEvent {
  final int? centerIdToEdit; // ✅ تعديل: نمرر الـ ID فقط
  const LoadCenterPrerequisites({this.centerIdToEdit});
}
class SubmitNewCenter extends AddEditCenterEvent {
  final Map<String, dynamic> data;
  const SubmitNewCenter({required this.data});
}

class SubmitCenterUpdate extends AddEditCenterEvent {
  final Map<String, dynamic> data;
  const SubmitCenterUpdate({required this.data});
}

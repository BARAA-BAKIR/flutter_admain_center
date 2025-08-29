part of 'add_edit_manager_bloc.dart';

abstract class AddEditManagerEvent extends Equatable {
  const AddEditManagerEvent();
  @override
  List<Object?> get props => [];
}

// حدث لجلب البيانات الأولية (المستخدمون المرشحون، المراكز الشاغرة)
// class LoadManagerPrerequisites extends AddEditManagerEvent {
//   final CenterManagerModel? managerToEdit;
//   const LoadManagerPrerequisites({this.managerToEdit});
// }
class LoadManagerPrerequisites extends AddEditManagerEvent {
  final CenterManagerModel? managerToEdit; // Add this property

  const LoadManagerPrerequisites({this.managerToEdit}); // Update constructor

  @override
  List<Object?> get props => [managerToEdit];
}
// حدث لإنشاء مدير جديد
class SubmitNewManager extends AddEditManagerEvent {
  final Map<String, dynamic> data;
  const SubmitNewManager({required this.data});
}

// حدث لتحديث بيانات مدير حالي
class SubmitManagerUpdate extends AddEditManagerEvent {
  final int managerId;
  final Map<String, dynamic> data;
  const SubmitManagerUpdate({required this.managerId, required this.data});
}

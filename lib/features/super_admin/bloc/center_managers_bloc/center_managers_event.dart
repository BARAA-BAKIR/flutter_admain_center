// // part of 'center_managers_bloc.dart';

// // abstract class CenterManagersEvent extends Equatable {
// //   const CenterManagersEvent();

// //   @override
// //   List<Object> get props => [];
// // }

// // class LoadCenterManagers extends CenterManagersEvent {}

// // class AddCenterManager extends CenterManagersEvent {
// //   final Map<String, dynamic> data;

// //   const AddCenterManager(this.data);

// //   @override
// //   List<Object> get props => [data];
// // }

// // class UpdateCenterManager extends CenterManagersEvent {
// //   final int id;
// //   final Map<String, dynamic> data;

// //   const UpdateCenterManager(this.id, this.data);

// //   @override
// //   List<Object> get props => [id, data];
// // }

// // class DeleteCenterManager extends CenterManagersEvent {
// //   final int id;

// //   const DeleteCenterManager(this.id);

// //   @override
// //   List<Object> get props => [id];
// // }
// // center_managers_event.dart
// part of 'center_managers_bloc.dart';

// abstract class CenterManagersEvent extends Equatable {
//   const CenterManagersEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadCenterManagers extends CenterManagersEvent {}

// class AddCenterManager extends CenterManagersEvent {
//   final Map<String, dynamic> data;

//   const AddCenterManager(this.data);

//   @override
//   List<Object> get props => [data];
// }

// class UpdateCenterManager extends CenterManagersEvent {
//   final int id;
//   final Map<String, dynamic> data;

//   const UpdateCenterManager(this.id, this.data);

//   @override
//   List<Object> get props => [id, data];
// }

// class DeleteCenterManager extends CenterManagersEvent {
//   final int id;

//   const DeleteCenterManager(this.id);

//   @override
//   List<Object> get props => [id];
// }
part of 'center_managers_bloc.dart';

abstract class CenterManagersEvent extends Equatable {
  const CenterManagersEvent();

  @override
  List<Object> get props => [];
}

class LoadCenterManagers extends CenterManagersEvent {
   final String? searchQuery;

  const LoadCenterManagers({this.searchQuery});

  
}

class AddCenterManager extends CenterManagersEvent {
  final Map<String, dynamic> data;

  const AddCenterManager(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateCenterManager extends CenterManagersEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateCenterManager(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteCenterManager extends CenterManagersEvent {
  final int id;

  const DeleteCenterManager(this.id);

  @override
  List<Object> get props => [id];
}
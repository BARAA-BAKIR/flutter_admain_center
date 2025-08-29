part of 'add_edit_manager_bloc.dart';

enum FormStatus { initial, loading, loaded, submitting, success, failure }

class AddEditManagerState extends Equatable {
  final FormStatus status;
  final List<Map<String, dynamic>>? potentialUsers;
  final List<Map<String, dynamic>>? unassignedCenters;
  final String? errorMessage;

  const AddEditManagerState({
    this.status = FormStatus.initial,
    this.potentialUsers,
    this.unassignedCenters,
    this.errorMessage,
  });

  AddEditManagerState copyWith({
    FormStatus? status,
    List<Map<String, dynamic>>? potentialUsers,
    List<Map<String, dynamic>>? unassignedCenters,
    String? errorMessage,
  }) {
    return AddEditManagerState(
      status: status ?? this.status,
      potentialUsers: potentialUsers ?? this.potentialUsers,
      unassignedCenters: unassignedCenters ?? this.unassignedCenters,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, potentialUsers, unassignedCenters, errorMessage];
}

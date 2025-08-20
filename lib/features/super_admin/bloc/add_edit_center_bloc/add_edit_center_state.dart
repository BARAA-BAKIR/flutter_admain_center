part of 'add_edit_center_bloc.dart';

enum FormStatus { initial, loading, loaded, submitting, success, failure }

class AddEditCenterState extends Equatable {
  final FormStatus status;
  final List<Map<String, dynamic>> potentialManagers;
  final CenterModel? initialData;
  final String? errorMessage;

  const AddEditCenterState({
    this.status = FormStatus.initial,
    this.potentialManagers = const [],
    this.initialData,
    this.errorMessage,
  });

  AddEditCenterState copyWith({
    FormStatus? status,
    List<Map<String, dynamic>>? potentialManagers,
    CenterModel? initialData,
    String? errorMessage,
  }) {
    return AddEditCenterState(
      status: status ?? this.status,
      potentialManagers: potentialManagers ?? this.potentialManagers,
      initialData: initialData ?? this.initialData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, potentialManagers, initialData, errorMessage];
}

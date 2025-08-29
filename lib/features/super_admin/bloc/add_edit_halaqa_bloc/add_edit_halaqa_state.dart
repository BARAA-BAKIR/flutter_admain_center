part of 'add_edit_halaqa_bloc.dart';
enum FormStatus { initial, loading, loaded, submitting, success, failure }
class AddEditHalaqaState extends Equatable {
  final FormStatus status;
  final List<Map<String, dynamic>> centers;
  final List<Map<String, dynamic>> mosques;
  final List<HalaqaType> halaqaTypes;
  final String? errorMessage;

  const AddEditHalaqaState({
    this.status = FormStatus.initial,
    this.centers = const [],
    this.mosques = const [],
    this.halaqaTypes = const [],
    this.errorMessage,
  });

  AddEditHalaqaState copyWith({
    FormStatus? status,
    List<Map<String, dynamic>>? centers,
    List<Map<String, dynamic>>? mosques,
    List<HalaqaType>? halaqaTypes,
    String? errorMessage,
  }) {
    return AddEditHalaqaState(
      status: status ?? this.status,
      centers: centers ?? this.centers,
      mosques: mosques ?? this.mosques,
      halaqaTypes: halaqaTypes ?? this.halaqaTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, centers, mosques, halaqaTypes, errorMessage];
}

part of 'add_halaqa_bloc.dart';

enum AddHalaqaStatus { initial, loading, success, failure }

class AddHalaqaState extends Equatable {
  final AddHalaqaStatus status;
  final List<Map<String, dynamic>> availableTeachers;
  final String? errorMessage;

  const AddHalaqaState({
    this.status = AddHalaqaStatus.initial,
    this.availableTeachers = const [],
    this.errorMessage,
  });

  AddHalaqaState copyWith({
    AddHalaqaStatus? status,
    List<Map<String, dynamic>>? availableTeachers,
    String? errorMessage,
  }) {
    return AddHalaqaState(
      status: status ?? this.status,
      availableTeachers: availableTeachers ?? this.availableTeachers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, availableTeachers, errorMessage];
}

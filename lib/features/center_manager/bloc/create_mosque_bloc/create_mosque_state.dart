part of 'create_mosque_bloc.dart';

enum FormStatus { initial, submissionInProgress, submissionSuccess, submissionFailure }

class CreateMosqueState extends Equatable {
  final FormStatus status;
  final String? errorMessage;

  const CreateMosqueState({
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  CreateMosqueState copyWith({FormStatus? status, String? errorMessage}) {
    return CreateMosqueState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

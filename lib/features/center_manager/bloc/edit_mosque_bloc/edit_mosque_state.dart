part of 'edit_mosque_bloc.dart';

// سنستخدم نفس الـ FormStatus من بلوك الإنشاء
enum FormStatus { initial, submissionInProgress, submissionSuccess, submissionFailure }

class EditMosqueState extends Equatable {
  final FormStatus status;
  final String? errorMessage;
  final Mosque? updatedMosque;

  const EditMosqueState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.updatedMosque,
  });

  EditMosqueState copyWith({
    FormStatus? status,
    String? errorMessage,
    Mosque? updatedMosque,
  }) {
    return EditMosqueState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedMosque: updatedMosque ?? this.updatedMosque,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, updatedMosque];
}

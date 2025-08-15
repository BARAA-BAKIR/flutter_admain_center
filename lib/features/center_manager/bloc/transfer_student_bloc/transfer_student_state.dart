part of 'transfer_student_bloc.dart';

enum TransferStatus { initial, loading, loaded, submitting, success, failure }

class TransferStudentState extends Equatable {
  final TransferStatus status;
  final List<Map<String, dynamic>> halaqas;
  final StudentDetails? updatedStudent;
  final String? errorMessage;

  const TransferStudentState({
    this.status = TransferStatus.initial,
    this.halaqas = const [],
    this.updatedStudent,
    this.errorMessage,
  });

  TransferStudentState copyWith({
    TransferStatus? status,
    List<Map<String, dynamic>>? halaqas,
    StudentDetails? updatedStudent,
    String? errorMessage,
  }) {
    return TransferStudentState(
      status: status ?? this.status,
      halaqas: halaqas ?? this.halaqas,
      updatedStudent: updatedStudent ?? this.updatedStudent,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, halaqas, updatedStudent, errorMessage];
}

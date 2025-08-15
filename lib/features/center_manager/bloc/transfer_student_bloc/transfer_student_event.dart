part of 'transfer_student_bloc.dart';

abstract class TransferStudentEvent extends Equatable {
  const TransferStudentEvent();
  @override
  List<Object> get props => [];
}

class LoadHalaqasForTransfer extends TransferStudentEvent {}

class TransferStudentSubmitted extends TransferStudentEvent {
  final int studentId;
  final int newHalaqaId;
  const TransferStudentSubmitted({required this.studentId, required this.newHalaqaId});
}

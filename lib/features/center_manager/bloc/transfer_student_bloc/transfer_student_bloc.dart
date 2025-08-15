import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'transfer_student_event.dart';
part 'transfer_student_state.dart';

class TransferStudentBloc extends Bloc<TransferStudentEvent, TransferStudentState> {
  final CenterManagerRepository _repository;

  TransferStudentBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const TransferStudentState()) {
    on<LoadHalaqasForTransfer>(_onLoadHalaqas);
    on<TransferStudentSubmitted>(_onSubmit);
  }

  Future<void> _onLoadHalaqas(LoadHalaqasForTransfer event, Emitter<TransferStudentState> emit) async {
    emit(state.copyWith(status: TransferStatus.loading));
    final result = await _repository.getFiltersData(); // نستخدم نفس الدالة
    result.fold(
      (failure) => emit(state.copyWith(status: TransferStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: TransferStatus.loaded, halaqas: List<Map<String, dynamic>>.from(data['halaqas']))),
    );
  }

  Future<void> _onSubmit(TransferStudentSubmitted event, Emitter<TransferStudentState> emit) async {
    emit(state.copyWith(status: TransferStatus.submitting));
    final result = await _repository.transferStudent(
      studentId: event.studentId,
      newHalaqaId: event.newHalaqaId,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: TransferStatus.failure, errorMessage: failure.message)),
      (response) {
        final student = StudentDetails.fromJson(response['student']);
        emit(state.copyWith(status: TransferStatus.success, updatedStudent: student));
      },
    );
  }
}

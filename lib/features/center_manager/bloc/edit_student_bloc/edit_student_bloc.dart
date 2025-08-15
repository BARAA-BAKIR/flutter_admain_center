import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/edit_student_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_details_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_student_event.dart';
part 'edit_student_state.dart';

class EditStudentBloc extends Bloc<EditStudentEvent, EditStudentState> {
  final CenterManagerRepository _repository;

  EditStudentBloc({required CenterManagerRepository repository})
    : _repository = repository,
      super(const EditStudentState()) {
    on<FetchStudentDetails>(_onFetchDetails);
    on<SubmitStudentUpdate>(_onSubmitUpdate);
  }

  Future<void> _onFetchDetails(
    FetchStudentDetails event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(state.copyWith(status: EditStudentStatus.loadingDetails));
    final result = await _repository.getStudentDetails(event.studentId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditStudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (studentDetails) => emit(
        state.copyWith(
          status: EditStudentStatus.detailsLoaded,
          student: studentDetails,// انا هيك صلحته ؟؟
        ),
      ),
    );
  }

  Future<void> _onSubmitUpdate(
    SubmitStudentUpdate event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(state.copyWith(status: EditStudentStatus.submitting));
    final result = await _repository.updateStudent(
      studentId: event.studentId,
      studentData: event.data.toJson(),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditStudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) {
        final student = StudentDetails.fromJson(response['student']);
        emit(
          state.copyWith(
            status: EditStudentStatus.success,
            updatedStudent: student,
          ),
        );
      },
    );
  }
}

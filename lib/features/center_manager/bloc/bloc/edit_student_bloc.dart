import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_student_event.dart';
part 'edit_student_state.dart';

class EditStudentBloc extends Bloc<EditStudentEvent, EditStudentState> {
  final CenterManagerRepository _repository;

  EditStudentBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const EditStudentState()) {
    on<SubmitStudentUpdate>(_onSubmitUpdate);
  }

  Future<void> _onSubmitUpdate(SubmitStudentUpdate event, Emitter<EditStudentState> emit) async {
    emit(state.copyWith(status: EditStudentStatus.loading));
    final result = await _repository.updateStudent(studentId: event.studentId, studentData: event.data);
    result.fold(
      (failure) => emit(state.copyWith(status: EditStudentStatus.failure, errorMessage: failure.message)),
      (updatedStudentData) {
        final student = Student.fromJson(updatedStudentData['student']);
        emit(state.copyWith(status: EditStudentStatus.success, updatedStudent: student));
      },
    );
  }
}

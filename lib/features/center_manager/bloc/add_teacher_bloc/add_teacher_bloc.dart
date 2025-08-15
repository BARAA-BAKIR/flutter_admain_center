import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_teacher_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'add_teacher_event.dart';
part 'add_teacher_state.dart';

class AddTeacherBloc extends Bloc<AddTeacherEvent, AddTeacherState> {
  final CenterManagerRepository _repository;

  AddTeacherBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const AddTeacherState()) {
    on<SubmitNewTeacher>(_onSubmit);
  }

 
  Future<void> _onSubmit(SubmitNewTeacher event, Emitter<AddTeacherState> emit) async {
    emit(state.copyWith(status: AddTeacherStatus.submitting));
    
    // الآن _repository.addTeacher يرجع Either<Failure, Teacher>
    final result = await _repository.addTeacher(event.teacherData);
    
    result.fold(
      (failure) => emit(state.copyWith(status: AddTeacherStatus.failure, errorMessage: failure.message)),
      // 'newTeacher' هنا هو كائن Teacher جاهز، لا حاجة لأي تحويل
      (newTeacher) {
        emit(state.copyWith(status: AddTeacherStatus.success, createdTeacher: newTeacher));
      },
    );
  }
}

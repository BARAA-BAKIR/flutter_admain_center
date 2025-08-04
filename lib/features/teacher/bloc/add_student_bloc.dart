
import 'package:flutter_admain_center/data/models/level_model.dart';
import 'package:flutter_admain_center/data/models/add_student_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// افترض وجود نموذج بيانات الطالب
// import 'package:flutter_admain_center/data/models/student_data_model.dart';

part 'add_student_event.dart';
part 'add_student_state.dart';

class AddStudentBloc extends Bloc<AddStudentEvent, AddStudentState> {
  final TeacherRepository _teacherRepository;
  final _storage = const FlutterSecureStorage();
  AddStudentBloc({required TeacherRepository teacherRepository})
    : _teacherRepository = teacherRepository,
      super(const AddStudentState()) {
    on<StepChanged>((event, emit) {
      emit(state.copyWith(currentStep: event.step));
    });

    on<GenderChanged>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });
    on<SocialStatusChanged>((event, emit) {
      emit(state.copyWith(social_status: event.socialStatus));
    });
    on<SubmitStudentData>((event, emit) async {
      emit(state.copyWith(isSaving: true, error: null, saveSuccess: false));

      try {
        final String token = await _storage.read(key: 'auth_token') ?? '';
        
        if (token.isEmpty) {
          emit(
            state.copyWith(
              isSaving: false,
              error: 'المستخدم غير مسجل دخوله، الرجاء إعادة تسجيل الدخول.',
            ),
          );
          return;
        }

        final result = await _teacherRepository.addStudent(
          token: token,
         studentData: event.studentData,
        );

        if (result['success']) {
          emit(state.copyWith(isSaving: false, saveSuccess: true));
        } else {
          emit(
            state.copyWith(
              isSaving: false,
              error: result['message'] ?? 'فشل إضافة الطالب.',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            isSaving: false,
            error: 'حدث خطأ غير متوقع: ${e.toString()}',
          ),
        );
      }
    });

    on<FetchLevels>(_onFetchLevels);
    on<LevelChanged>(
      (event, emit) => emit(state.copyWith(selectedLevelId: event.levelId)),
    );
  }

  Future<void> _onFetchLevels(
    FetchLevels event,
    Emitter<AddStudentState> emit,
  ) async {
    emit(state.copyWith(isLoadingLevels: true));
    try {
      final levels = await _teacherRepository.getLevels();
      emit(state.copyWith(levels: levels, isLoadingLevels: false));
    } catch (e) {
      emit(state.copyWith(isLoadingLevels: false, error: e.toString()));
    }
  }
}

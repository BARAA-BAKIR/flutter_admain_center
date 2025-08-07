// lib/features/teacher/blocs/add_student_bloc/add_student_bloc.dart

import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    
    // تصحيح دالة SubmitStudentData
    on<SubmitStudentData>((event, emit) async {
      emit(state.copyWith(isSaving: true, error: null, saveSuccess: false));

      final String? token = await _storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            isSaving: false,
            error: 'المستخدم غير مسجل دخوله، الرجاء إعادة تسجيل الدخول.',
          ),
        );
        return;
      }

      // استخدام fold للتعامل مع نتيجة الـ Repository
      final result = await _teacherRepository.addStudent(
        token: token,
        studentData: event.studentData,
      );

      result.fold(
        // حالة الفشل (Left)
        (failure) {
          emit(state.copyWith(
            isSaving: false,
            error: failure.message,
          ));
        },
        // حالة النجاح (Right)
        (data) {
          // 'data' هي الآن Map<String, dynamic>
          if (data['success'] == true) {
            emit(state.copyWith(isSaving: false, saveSuccess: true));
          } else {
            emit(state.copyWith(
              isSaving: false,
              error: data['message'] ?? 'فشل إضافة الطالب.',
            ));
          }
        },
      );
    });

    on<FetchLevels>(_onFetchLevels);
    on<LevelChanged>(
      (event, emit) => emit(state.copyWith(selectedLevelId: event.levelId)),
    );
  }

  // تصحيح دالة _onFetchLevels
  Future<void> _onFetchLevels(
    FetchLevels event,
    Emitter<AddStudentState> emit,
  ) async {
    emit(state.copyWith(isLoadingLevels: true));

    // استخدام fold للتعامل مع نتيجة الـ Repository
    final result = await _teacherRepository.getLevels();
    result.fold(
      // حالة الفشل (Left)
      (failure) {
        emit(state.copyWith(isLoadingLevels: false, error: failure.message));
      },
      // حالة النجاح (Right)
      (levels) {
        // 'levels' هي الآن List<LevelModel>
        emit(state.copyWith(levels: levels, isLoadingLevels: false));
      },
    );
  }
}
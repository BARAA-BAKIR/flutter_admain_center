import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/data/models/teacher/student_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final TeacherRepository _teacherRepository;

  ProfileBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const ProfileState()) {
    on<FetchProfileData>(_onFetchProfileData);
  }
// هذا هو الكود المصحح
Future<void> _onFetchProfileData(
  FetchProfileData event,
  Emitter<ProfileState> emit,
) async {
  emit(state.copyWith(status: ProfileStatus.loading));
  try {
    // 1. استدعاء الدالة التي تُرجع Either
    final result = await _teacherRepository.getStudentProfile(event.studentId);

    // 2. استخدام "fold" للتعامل مع الحالتين: الفشل (Left) والنجاح (Right)
    result.fold(
      // إذا كانت النتيجة فشلاً (Left)
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message, // افترض أن Failure لها خاصية message
        ));
      },
      // إذا كانت النتيجة نجاحاً (Right)
      (profileData) {
        emit(state.copyWith(
          status: ProfileStatus.success,
          profile: profileData,
        ));
      },
    );
  } catch (e) {
    // هذا الكاتش سيتعامل مع أي أخطاء غير متوقعة
    emit(state.copyWith(
      status: ProfileStatus.failure,
      errorMessage: 'An unexpected error occurred: ${e.toString()}',
    ));
  }
}
}
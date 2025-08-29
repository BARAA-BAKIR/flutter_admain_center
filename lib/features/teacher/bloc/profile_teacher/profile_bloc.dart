// لا تستورد أي ملفات BLoC أخرى هنا، خاصة ليس ملفه الخاص!
// احذف السطر التالي:
// import 'package:flutter_admain_center/features/teacher/bloc/profile_student/profile_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';

// استورد ملفات الـ event والـ state كـ "part"
// هذا يخبر Dart أن هذه الملفات هي امتداد لهذا الملف
part 'profile_event.dart';
part 'profile_state.dart';

// لا داعي لتحديد أنواع enum هنا، مكانها الأفضل في ملف الحالة (state)
// enum ProfileStatus { initial, loading, success, failure }
// enum ProfileActionStatus { initial, loading, success, failure }

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final TeacherRepository _teacherRepository;

  ProfileBloc({required TeacherRepository teacherRepository})
      : _teacherRepository = teacherRepository,
        super(const ProfileState()) { // الحالة الأولية تأتي من ProfileState
    on<FetchProfileData>(_onFetchProfileData);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final result = await _teacherRepository.getTeacherProfile();
      result.fold(
        (failure) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message)),
        (profileData) => emit(state.copyWith(status: ProfileStatus.success, profile: profileData)),
      );
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

 Future<void> _onUpdateProfile(
  UpdateProfile event,
  Emitter<ProfileState> emit,
) async {
  emit(state.copyWith(actionStatus: ProfileActionStatus.loading));
  try {
    final result = await _teacherRepository.updateTeacherProfile(
      firstName: event.firstName,
      lastName: event.lastName,
      fatherName: event.fatherName,
      motherName: event.motherName,
      birthDate: event.birthDate,
      educationLevel: event.educationLevel,
      gender: event.gender,
      phone: event.phoneNumber,
      address: event.address,
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      newPasswordConfirmation: event.newPasswordConfirmation,
    );
    result.fold(
      (failure) {
        emit(state.copyWith(actionStatus: ProfileActionStatus.failure, errorMessage: failure.message));
      },
      (updatedProfile) {
        emit(state.copyWith(actionStatus: ProfileActionStatus.success, profile: updatedProfile));
      },
    );
  } catch (e) {
    emit(state.copyWith(actionStatus: ProfileActionStatus.failure, errorMessage: 'An unexpected error occurred: ${e.toString()}'));
  } finally {
    // أعد الحالة إلى initial بعد انتهاء العملية للسماح بمحاولة أخرى
    emit(state.copyWith(actionStatus: ProfileActionStatus.initial));
  }
}
}

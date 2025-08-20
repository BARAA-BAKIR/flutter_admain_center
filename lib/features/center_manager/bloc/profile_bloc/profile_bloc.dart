// في lib/features/profile/bloc/profile_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/profile_details_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ProfileState()) {
    on<FetchProfile>(_onFetchProfile);
    on<VerifyPasswordAndEnableEdit>(_onVerifyPassword);
    on<SubmitProfileUpdate>(_onSubmitUpdate);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _authRepository.getProfileDetails();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(status: ProfileStatus.success, profileData: data),
      ),
    );
  }

  Future<void> _onVerifyPassword(VerifyPasswordAndEnableEdit event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
      status: ProfileStatus.verifying,
      profileData: state.profileData, // ✅ تمرير البيانات الحالية
    ));
    final result = await _authRepository.verifyPassword(event.password);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
        profileData: state.profileData, // ✅ تمرير البيانات الحالية
      )),
      (success) => emit(state.copyWith(
        status: ProfileStatus.success,
        isEditModeEnabled: true,
        profileData: state.profileData, // ✅ تمرير البيانات الحالية
      )),
    );
  }

  Future<void> _onSubmitUpdate(SubmitProfileUpdate event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
      status: ProfileStatus.updating,
      profileData: state.profileData, // ✅ تمرير البيانات الحالية
    ));
    final result = await _authRepository.updateProfileforcenteradmin(event.data);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
        profileData: state.profileData, // ✅ تمرير البيانات الحالية
      )),
      (updatedData) => emit(state.copyWith(
        status: ProfileStatus.success,
        profileData: updatedData, // <-- استخدام البيانات المحدثة هنا
        isEditModeEnabled: false,
      )),
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/user_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SuperAdminRepository _profileRepository;

  ProfileBloc({required SuperAdminRepository profileRepository})
    : _profileRepository = profileRepository,
      super(const ProfileState()) {
    on<ProfileFetched>(_onProfileFetched);
    on<PasswordVerifiedForEdit>(_onPasswordVerified);
    on<ProfileInfoUpdated>(_onProfileUpdated);
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _profileRepository.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: ProfileStatus.loaded, userProfile: user)),
    );
  }

  Future<void> _onPasswordVerified(
    PasswordVerifiedForEdit event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.submitting, clearError: true));
    final result = await _profileRepository.verifyPassword(event.password);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileStatus.passwordVerified,
          currentPassword: event.password,
        ),
      ),
    );
  }

  Future<void> _onProfileUpdated(
    ProfileInfoUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.submitting, clearError: true));
    final result = await _profileRepository.updateProfile(event.data);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedUser) => emit(
        state.copyWith(status: ProfileStatus.success, userProfile: updatedUser),
      ),
    );
  }
}

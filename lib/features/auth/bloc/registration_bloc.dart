// lib/features/auth/bloc/registration_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_event.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterTeacherUseCase _registerTeacherUseCase;
  final GetCentersUseCase _getCentersUseCase;

  RegistrationBloc({
    required RegisterTeacherUseCase registerTeacherUseCase,
    required GetCentersUseCase getCentersUseCase,
    required AuthBloc authBloc,
  })  : _registerTeacherUseCase = registerTeacherUseCase,
        _getCentersUseCase = getCentersUseCase,
        super(const RegistrationState()) {
    on<FetchCenters>(_onFetchCenters);
    on<StepChanged>(_onStepChanged);
    on<SubmitRegistration>(_onSubmitRegistration);
  }

  Future<void> _onFetchCenters(FetchCenters event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(isLoadingCenters: true));

    // استخدم fold لمعالجة النتيجة
    final result = await _getCentersUseCase();
    result.fold(
      // حالة الفشل (Left)
      (failure) {
        emit(state.copyWith(
          isLoadingCenters: false,
          errorMessage: failure.message,
        ));
      },
      // حالة النجاح (Right)
      (centers) {
        emit(state.copyWith(
          centers: centers,
          isLoadingCenters: false,
        ));
      },
    );
  }

  void _onStepChanged(StepChanged event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  Future<void> _onSubmitRegistration(SubmitRegistration event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading));

    // استخدم fold لمعالجة النتيجة
    final result = await _registerTeacherUseCase(event.registrationModel);
    result.fold(
      // حالة الفشل (Left)
      (failure) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: failure.message,
        ));
      },
      // حالة النجاح (Right)
      (data) {
        // تأكد من أن بنية البيانات العائدة تحتوي على 'success' و 'message'
        if (data['success'] == true) {
          emit(state.copyWith(
            status: RegistrationStatus.success,
            successMessage: data['message'] ?? 'تم التسجيل بنجاح',
          ));
        } else {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: data['message'] ?? 'فشل التسجيل',
          ));
        }
      },
    );
  }
}
// lib/features/auth/bloc/registration_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_event.dart';
import 'package:flutter_admain_center/features/auth/bloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  // --- الاعتماد على الـ UseCases بدلاً من الـ Repository مباشرة ---
  final RegisterTeacherUseCase _registerTeacherUseCase;
  final GetCentersUseCase _getCentersUseCase;
  // final AuthBloc _authBloc;

  RegistrationBloc({
    required RegisterTeacherUseCase registerTeacherUseCase,
    required GetCentersUseCase getCentersUseCase,
    required AuthBloc authBloc,
  })  : _registerTeacherUseCase = registerTeacherUseCase,
        _getCentersUseCase = getCentersUseCase,
        // _authBloc = authBloc,
        super(const RegistrationState()) {
    
    on<FetchCenters>(_onFetchCenters);
    on<StepChanged>(_onStepChanged);
    on<SubmitRegistration>(_onSubmitRegistration);
  }

    Future<void> _onFetchCenters(FetchCenters event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(isLoadingCenters: true));
    try {
      final centers = await _getCentersUseCase();
      emit(state.copyWith(centers: centers, isLoadingCenters: false));
    } catch (e, stackTrace) { // أضف stackTrace لتفاصيل أكثر
      // --- هذا هو السطر الذي يجب إضافته ---
      print("!!!!!!!!!!!!!!!!! خطأ في جلب المراكز !!!!!!!!!!!!!!!!!!");
      print("الخطأ: $e");
      print("Stack Trace: $stackTrace");
      // -----------------------------------------
      emit(state.copyWith(isLoadingCenters: false, errorMessage: 'فشل تحميل المراكز'));
    }
  }


  void _onStepChanged(StepChanged event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  Future<void> _onSubmitRegistration(SubmitRegistration event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    try {
      final result = await _registerTeacherUseCase(event.registrationModel);

      if (result['success']) {
        // final String token = result['data']['token'];
        // _authBloc.add(LoggedIn(token: token)); // إخبار AuthBloc بنجاح التسجيل

        emit(state.copyWith(
          status: RegistrationStatus.success,
          successMessage: result['data']['message'] ?? 'تم التسجيل بنجاح',
        ));
      } else {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: result['message'],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: 'حدث خطأ في التطبيق: ${e.toString()}',
      ));
    }
  }
}

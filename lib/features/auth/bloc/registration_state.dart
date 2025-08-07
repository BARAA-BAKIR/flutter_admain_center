// lib/features/auth/bloc/registration_state.dart
import 'package:flutter_admain_center/data/models/teacher/center_model.dart';


// استخدام enum لتحديد الحالة بشكل أوضح
enum RegistrationStatus { initial, loading, success, failure }

class RegistrationState {
  final int currentStep;
  final RegistrationStatus status;
  final String? successMessage;
  final String? errorMessage;
  final List<CenterModel> centers;
  final bool isLoadingCenters;
  const RegistrationState({
    this.currentStep = 0,
    this.status = RegistrationStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.centers=const [],
    this.isLoadingCenters=false,
  });

  RegistrationState copyWith({
    int? currentStep,
    RegistrationStatus? status,
    String? successMessage,
    String? errorMessage,
    List<CenterModel>? centers,
    bool? isLoadingCenters,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      successMessage: successMessage,
      errorMessage: errorMessage,
      centers:centers ?? this.centers,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
    );
  }
}

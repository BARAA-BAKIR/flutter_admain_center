// lib/features/auth/bloc/registration_event.dart

// الكلاس الأساسي الذي سترث منه كل الأحداث
// استخدام sealed class هو ممارسة جيدة لضمان أن كل الأحداث معرفة
import 'package:flutter_admain_center/data/models/registration_model.dart';

sealed class RegistrationEvent {}

final class FetchCenters extends RegistrationEvent {}

// --- الحدث الأول: عند تغيير الخطوة في الـ Stepper ---
// هذا الحدث يتم إرساله عندما ينتقل المستخدم بين خطوات النموذج


class StepChanged extends RegistrationEvent {
  final int step;

  StepChanged(this.step);
}


// --- الحدث الثاني: عند الضغط على زر الإرسال النهائي ---
// هذا هو الحدث الرئيسي الذي يبدأ عملية الاتصال بالـ API
class SubmitRegistration extends RegistrationEvent {
  // يحمل هذا الحدث كل بيانات النموذج التي تم جمعها
  // في كائن واحد منظم (Model)
  final RegistrationModel registrationModel;

  SubmitRegistration(this.registrationModel);
}

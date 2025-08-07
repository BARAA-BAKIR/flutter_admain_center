// هذا السطر يخبر Dart أن هذا الملف هو جزء من مكتبة profile_bloc
part of 'profile_bloc.dart';

// اجعل الكلاس الأساسي تجريدياً
abstract class ProfileEvent {}

// هذا الحدث لا يحتاج أي متغيرات
class FetchProfileData extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  // اجعل الحقول اختيارية لأن المستخدم قد لا يغيرها كلها
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  // كلمة المرور الحالية مطلوبة دائماً للتأكيد
  final String currentPassword;

  UpdateProfile({
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    required this.currentPassword,
  });
}

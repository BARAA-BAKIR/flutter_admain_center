// lib/domain/repositories/auth_repository.dart

// هذا هو "العقد" الذي يحدد ما يجب أن يفعله المستودع
// بغض النظر عن كيفية تنفيذه.
import 'package:flutter_admain_center/data/models/center_model.dart';
import 'package:flutter_admain_center/data/models/registration_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  
  Future<Map<String, dynamic>> registerTeacher(RegistrationModel data);
  Future<List<CenterModel>> getCenters();

}

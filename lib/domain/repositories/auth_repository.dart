// lib/domain/repositories/auth_repository.dart

import 'package:flutter_admain_center/data/models/center_model.dart';
import 'package:flutter_admain_center/data/models/registration_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password, String? fcmToken);
  
  Future<Map<String, dynamic>> registerTeacher(RegistrationModel data);
  Future<List<CenterModel>> getCenters();
  Future<void> logout();
}

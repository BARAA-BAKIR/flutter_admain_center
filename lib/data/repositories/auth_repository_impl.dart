// lib/data/repositories/auth_repository_impl.dart

import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
import 'package:flutter_admain_center/data/models/center_model.dart';
import 'package:flutter_admain_center/data/models/registration_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDatasource datasource;

  AuthRepositoryImpl({required this.datasource, required FlutterSecureStorage storage});

  @override
  Future<Map<String, dynamic>> login(String email, String password, String? fcmToken) {
    return datasource.login(email: email, password: password);
  }

  @override
  Future<List<CenterModel>> getCenters() {
    return datasource.getCenters();
  }

  @override
  Future<Map<String, dynamic>> registerTeacher(RegistrationModel data) {
    return datasource.registerTeacher(data);
  }
  @override
  Future<void> logout() {
    return datasource.logout();
  }
}

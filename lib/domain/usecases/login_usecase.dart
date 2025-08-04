// lib/domain/usecases/login_usecase.dart

import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Map<String, dynamic>> call(String email, String password, String? fcmToken) {
    return repository.login(email, password, fcmToken);
  }
}

// lib/domain/usecases/login_usecase.dart

import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Map<String, dynamic>> call(String email, String password) {
    // الـ UseCase يستدعي الدالة من العقد (Repository)
    return repository.login(email, password);
  }
}

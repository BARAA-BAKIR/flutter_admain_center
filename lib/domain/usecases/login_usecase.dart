import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/teacher/user_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  // الإصلاح: استخدام named arguments لتمرير البيانات
  Future<Either<Failure, UserModel>> call({
    required String email,
    required String password,
    String? fcmToken,
  }) {
    return repository.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
  }
}

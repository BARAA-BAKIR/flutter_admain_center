// lib/domain/usecases/register_teacher_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/teacher/registration_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class RegisterTeacherUseCase {
  final AuthRepository repository;

  RegisterTeacherUseCase({required this.repository});

  // يجب تغيير نوع العودة
  Future<Either<Failure, Map<String, dynamic>>> call(RegistrationModel data) {
    return repository.registerTeacher(data);
  }
}
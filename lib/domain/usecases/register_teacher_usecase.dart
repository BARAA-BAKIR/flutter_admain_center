// lib/domain/usecases/register_teacher_usecase.dart
import 'package:flutter_admain_center/data/models/registration_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class RegisterTeacherUseCase {
  final AuthRepository repository;

  RegisterTeacherUseCase({required this.repository});

  Future<Map<String, dynamic>> call(RegistrationModel data) {
    return repository.registerTeacher(data);
  }
}

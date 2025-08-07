// lib/domain/usecases/get_centers_usecase.dart

import 'package:dartz/dartz.dart'; // لا تنسَ استيرادها
import 'package:flutter_admain_center/core/error/failures.dart'; // ولا هذا
import 'package:flutter_admain_center/data/models/teacher/center_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class GetCentersUseCase {
  final AuthRepository repository;

  GetCentersUseCase({required this.repository});

  // يجب تغيير نوع العودة
  Future<Either<Failure, List<CenterModel>>> call() {
    return repository.getCenters();
  }
}
// lib/domain/usecases/get_centers_usecase.dart
import 'package:flutter_admain_center/data/models/center_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';

class GetCentersUseCase {
  final AuthRepository repository;

  GetCentersUseCase({required this.repository});

  Future<List<CenterModel>> call() {
    return repository.getCenters();
  }
}

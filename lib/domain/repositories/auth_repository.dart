// lib/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/teacher/center_model.dart';
import 'package:flutter_admain_center/data/models/teacher/registration_model.dart';
import 'package:flutter_admain_center/data/models/teacher/user_model.dart';

abstract class AuthRepository {
//  Future<Either<Failure, Map<String, dynamic>>> login(
//       String email, String password, String? fcmToken);
  Future<Either<Failure, UserModel>> login( {required String email,
    required String password,
    String? fcmToken,
  });
  Future<Either<Failure, List<CenterModel>>> getCenters();
  Future<Either<Failure, Map<String, dynamic>>> registerTeacher(
      RegistrationModel data);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, Map<String, dynamic>>> changePassword({
    required String current,
    required String newPassword,
    required String confirm,
  });
  Future<Either<Failure, Map<String, dynamic>>> fetchProfile();
  Future<Either<Failure, Map<String, dynamic>>> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String passwordConfirm,
  });
Future<Either<Failure, void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
  Future<Either<Failure, void>> updateNotificationStatus(bool status);
  Future<String?> getUserData();
}

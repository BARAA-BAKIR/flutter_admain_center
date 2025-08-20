// lib/data/repositories/auth_repository_impl.dart

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart'; // استيراد مكتبة dartz
import 'package:flutter_admain_center/core/error/failures.dart'; // استيراد كلاسات الأخطاء
import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/models/center_maneger/profile_details_model.dart';
import 'package:flutter_admain_center/data/models/teacher/center_model.dart';
import 'package:flutter_admain_center/data/models/teacher/registration_model.dart';
import 'package:flutter_admain_center/data/models/teacher/user_model.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDatasource datasource;
  final FlutterSecureStorage storage;
  TeacherLocalDatasource localDatasource;
  AuthRepositoryImpl({
    required this.datasource,
    required this.storage,
    required this.localDatasource,
  });

  // @override
  // Future<Either<Failure, Map<String, dynamic>>> login(
  //     String email, String password, String? fcmToken) async {
  //   final result = await datasource.login(
  //     email: email,
  //     password: password,
  //     fcmToken: fcmToken,
  //   );

  //   return result.fold(
  //     (failure) => Left(failure),
  //     (data) async {
  //       // يمكنك هنا حفظ التوكن إذا كان متوفرًا في الـ `data`
  //       // مثال: if (data.containsKey('token')) { await storage.write(key: 'auth_token', value: data['token']); }
  //       return Right(data);
  //     },
  //   );
  // }
  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    // الإصلاح: استدعاء الدالة باستخدام named arguments
    final result = await datasource.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );

    return result.fold((failure) => Left(failure), (data) async {
      try {
        final user = UserModel.fromJson(data);

        // تخزين بيانات المستخدم الكاملة
        final userJson = jsonEncode({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'token': user.token,
          'roles': user.roles,
        });
        await storage.write(key: 'user_data', value: userJson);
        log('user ${user}');
        return Right(user);
      } catch (e) {
        return Left(
          ParsingFailure(
            message: 'فشل في تحليل بيانات المستخدم.',
            details: e.toString(),
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, List<CenterModel>>> getCenters() async {
    final result = await datasource.getCenters();
    return result.fold((failure) => Left(failure), (centers) => Right(centers));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerTeacher(
    RegistrationModel data,
  ) async {
    final result = await datasource.registerTeacher(data);
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  // @override
  // Future<Either<Failure, void>> logout() async {
  //   final result = await datasource.logout();
  //   return result.fold(
  //     (failure) => Left(failure),
  //     (unit) => Right(unit),
  //   );
  // }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    final result = await datasource.forgotPassword(email);
    return result.fold((failure) => Left(failure), (unit) => Right(unit));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword({
    required String current,
    required String newPassword,
    required String confirm,
  }) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await datasource.changePassword(
      currentPassword: current,
      newPassword: newPassword,
      confirmPassword: confirm,
      token: token,
    );
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchProfile() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await datasource.fetchProfile(token);
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String passwordConfirm,
  }) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await datasource.updateProfile(
      token: token,
      name: name,
      phone: phone,
      address: address,
      passwordConfirm: passwordConfirm,
    );
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    // استدعاء الدالة من مصدر البيانات (API)
    return await datasource.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final token = await storage.read(
      key: 'user_data',
    ); // اقرأ بيانات المستخدم بدلاً من التوكن فقط

    // حذف بيانات المستخدم من التخزين الآمن
    await storage.delete(key: 'user_data');

    // مسح البيانات المحلية من sqflite
    await localDatasource.clearAllData();

    if (token == null) {
      // إذا لم يكن هناك بيانات أصلاً، فالعملية ناجحة
      return const Right(null);
    }

    // محاولة تسجيل الخروج من الخادم
    // استخراج التوكن الفعلي من بيانات المستخدم
    final userToken = jsonDecode(token)['token'];
    final _ = await datasource.logout(token: userToken);

    // لا نهتم بنتيجة الخادم، المهم هو أننا حذفنا البيانات محلياً
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateNotificationStatus(bool status) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    return await datasource.updateNotificationStatus(
      status: status,
      token: token,
    );
  }

  @override
  Future<String?> getUserData() async {
    return await storage.read(key: 'user_data');
  }
  // ... (داخل AuthRepositoryImpl)

  Future<String?> _getToken() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) return null;
    return jsonDecode(userDataJson)['token'];
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String fcmToken) async {
    final userToken =
        await _getToken(); // استخدم دالتك الخاصة لجلب توكن المصادقة
    if (userToken == null) {
      return const Left(CacheFailure(message: 'User not logged in'));
    }
    return await datasource.updateFcmToken(
      token: fcmToken,
      userToken: userToken,
    );
  }
   @override
  Future<Either<Failure, ProfileDetailsModel>> getProfileDetails() async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));

    final result = await datasource.getProfileDetails(token: token);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          return Right(ProfileDetailsModel.fromJson(data));
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to parse profile details: ${e.toString()}'));
        }
      },
    );
  }

  // ✅ تنفيذ دالة التحقق من كلمة المرور
  @override
  Future<Either<Failure, bool>> verifyPassword(String password) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));

    final result = await datasource.verifyPassword(token: token, password: password);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(true), // إذا نجح الطلب، فالكلمة صحيحة
    );
  }

  // ✅ تنفيذ دالة تحديث الملف الشخصي
  @override
  Future<Either<Failure, ProfileDetailsModel>> updateProfileforcenteradmin(Map<String, String> data) async {
    final token = await _getToken();
    if (token == null) return const Left(CacheFailure(message: 'User not logged in'));

    final result = await datasource.updateProfileforcenteradmin(token: token, data: data);
    return result.fold(
      (failure) => Left(failure),
      (updatedData) {
        try {
          return Right(ProfileDetailsModel.fromJson(updatedData));
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to parse updated profile: ${e.toString()}'));
        }
      },
    );
  }
}


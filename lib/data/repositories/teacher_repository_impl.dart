// lib/data/repositories/teacher_repository_impl.dart

import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/models/teacher/add_student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/dashboard_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/data/models/teacher/halaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/level_model.dart';
import 'package:flutter_admain_center/data/models/teacher/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_model.dart';
import 'package:flutter_admain_center/data/models/teacher/student_profile_model.dart';
import 'package:flutter_admain_center/data/models/teacher/teacher_profile_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherApiDatasource apiDatasource;
  final TeacherLocalDatasource localDatasource;
  final FlutterSecureStorage storage;

  TeacherRepositoryImpl({
    required this.apiDatasource,
    required this.localDatasource,
    required this.storage,
  });

  //====================================================================
  // --- دوال جلب البيانات (Getters) ---
  //====================================================================

  @override
  Future<Either<Failure, MyhalaqaModel>> getMyHalaqaWithLocalData() async {
    final String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    
    final result = await apiDatasource.getMyHalaqa(token);
    return result.fold(
      (failure) async {
        log("API failure, falling back to local cache. Reason: ${failure.toString()}");
        final cachedHalaqa = await localDatasource.getCachedHalaqaData();
        if (cachedHalaqa != null) {
          return Right(await _mergeWithLocalFollowUps(cachedHalaqa));
        } else {
          return Left(failure);
        }
      },
      (data) async {
        log("API Success: Fetched Halaqa data from server.");
        final halaqaFromApi = MyhalaqaModel.fromJson(data);
        await localDatasource.cacheHalaqaData(halaqaFromApi);
        log("Cache Success: Saved latest Halaqa data locally.");
        return Right(await _mergeWithLocalFollowUps(halaqaFromApi));
      },
    );
  }

  @override
  Future<Either<Failure, void>> syncAllUnsyncedData() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    final unsyncedFollowUps = await localDatasource.getUnsyncedFollowUps();
    final unsyncedDuties = await localDatasource.getUnsyncedDuties();

    final followUpsJson = unsyncedFollowUps.map((f) => f.toJsonForApi()).toList();
    final dutiesJson = unsyncedDuties.map((d) => d.toJsonForApi()).toList();

    final filteredFollowUps = followUpsJson
        .where((item) => (item['student_id'] ?? 0) > 0 && (item['group_id'] ?? 0) > 0)
        .toList();

    final filteredDuties = dutiesJson.where((item) => (item['student_id'] ?? 0) > 0).toList();

    if (filteredFollowUps.isEmpty && filteredDuties.isEmpty) {
      log("⚠️ No valid data to sync.");
      return const Right("لا توجد بيانات جديدة للمزامنة.");
    }

    final result = await apiDatasource.syncBulkData(
      token: token,
      followUps: filteredFollowUps,
      duties: filteredDuties,
    );

    return result.fold(
      (failure) => Left(failure),
      (data) async {
        await localDatasource.markFollowUpsAsSynced(unsyncedFollowUps);
        await localDatasource.markDutiesAsSynced(unsyncedDuties);
        log("✅ Local DB updated after successful sync.");
        return Right(data['message'] ?? 'تمت المزامنة بنجاح');
      },
    );
  }

  //====================================================================
  // --- دوال أخرى (Others) ---
  //====================================================================

  @override
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
    required String token,
    required AddStudentModel studentData,
  }) async {
    final result = await apiDatasource.addStudent(
      token: token,
      studentData: studentData,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }

  //====================================================================
  // --- دوال مساعدة خاصة (Private Helpers) ---
  //====================================================================

  Future<MyhalaqaModel> _mergeWithLocalFollowUps(MyhalaqaModel halaqa) async {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final localFollowUps = await localDatasource.getFollowUpsForDate(todayString);
    if (localFollowUps.isEmpty) {
      return halaqa;
    }
    for (var student in halaqa.students) {
      final localData = localFollowUps.firstWhereOrNull((f) => f.studentId == student.id);
      if (localData != null) {
        student.attendanceStatus =
            localData.attendance == 1 ? AttendanceStatus.present : AttendanceStatus.absent;
        student.hasTodayFollowUp = true;
      }
    }
    log("Merge Success: Merged ${localFollowUps.length} local follow-ups with Halaqa data.");
    return halaqa;
  }

  @override
  Future<Either<Failure, StudentProfileModel>> getStudentProfile(int studentId) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.getStudentProfile(token, studentId);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          // يجب أن نتحقق من أن `data` يحتوي على البيانات المطلوبة قبل التحويل
          // وإلا قد يحدث خطأ في التحويل
          return Right(StudentProfileModel.fromJson(data['data']));
        } catch (e) {
          log('Failed to parse StudentProfileModel: $e');
          return const Left(UnexpectedFailure(message: 'فشل في تحليل بيانات ملف الطالب.'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, HalaqaModel>> fetchHalaqaInfo(int halaqaId) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.fetchHalaqaInfo(token, halaqaId);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          return Right(HalaqaModel.fromJson(data));
        } catch (e) {
          log('Failed to parse HalaqaModel: $e');
          return const Left(UnexpectedFailure(message: 'فشل في تحليل بيانات الحلقة.'));
        }
      },
    );
  }

  
@override
Future<Either<Failure, Map<String, dynamic>>> getFollowUpAndDutyForStudent(
    int studentId, String date) async {
  // 1. البحث محلياً أولاً
  DailyFollowUpModel? localFollowUp = await localDatasource.getFollowUp(studentId, date);
  DutyModel? localDuty = await localDatasource.getDuty(studentId);

  if (localFollowUp != null) {
    print("Found local data for today. No need to fetch from server.");
    return Right({'followUp': localFollowUp, 'duty': localDuty});
  }

  print("No local data for today. Fetching latest from server...");
  final token = await storage.read(key: 'auth_token');
  if (token == null) {
    print("⚠️ No token, cannot fetch from server.");
    return Right({'followUp': null, 'duty': localDuty});
  }

  // 3. نستخدم fold للتعامل مع نتيجة الـ API
  final result = await apiDatasource.fetchLatestStudentData(
    token: token,
    studentId: studentId,
  );

  return result.fold(
    (failure) {
      print("❌ Error fetching from server: ${failure.message}. Returning local duty if available.");
      return Right({'followUp': null, 'duty': localDuty});
    },
    (serverData) async {
      final DailyFollowUpModel? serverFollowUp = serverData['followUp'];
      final DutyModel? serverDuty = serverData['duty'];

      // نقوم بتخزين البيانات القادمة من السيرفر محلياً
      if (serverFollowUp != null) {
        await localDatasource.upsertFollowUp(serverFollowUp.copyWith(isSynced: false));
      }
      if (serverDuty != null) {
        await localDatasource.upsertDuty(serverDuty.copyWith(isSynced: false));
      }
      return Right({'followUp': serverFollowUp, 'duty': serverDuty});
    },
  );
}
@override
Future<Either<Failure, bool>> storeFollowUpAndDuty(
    DailyFollowUpModel followUp, DutyModel duty) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  final hasInternet = connectivityResult != ConnectivityResult.none;
  final token = await storage.read(key: 'auth_token');

  if (!hasInternet || token == null) {
    log("🔌 Offline Mode or no token: Saving locally.");
    await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
    await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
    return const Left(
        ConnectionFailure(message: 'لا يوجد اتصال بالإنترنت. تم الحفظ محليًا.'));
  }

  final results = await Future.wait([
    apiDatasource.storeFollowUp(token: token, followUpData: followUp.toJsonForApi()),
    apiDatasource.storeDuty(token: token, dutyData: duty.toJsonForApi()),
  ]);

  final followUpResult = results[0];
  final dutyResult = results[1];

  // إذا نجحت كلتا العمليتين
  if (followUpResult.isRight() && dutyResult.isRight()) {
    followUp = followUp.copyWith(isSynced: true);
    duty = duty.copyWith(isSynced: true);
    log("✅ Sync Success: Data sent to server.");
    await localDatasource.upsertFollowUp(followUp);
    await localDatasource.upsertDuty(duty);
    return const Right(true);
  } else {
    // إذا فشلت إحدى العمليتين، نجد الخطأ الأول ونُرجعه
    final Failure error = (followUpResult.isLeft() ?? dutyResult.isLeft()) as Failure;
    log("❌ Sync Failed: Saving locally. Reason: ${error.message}");
    await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
    await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
    return Left(error);
  }
}

  @override
  Future<Either<Failure, List<LevelModel>>> getLevels() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.getLevels(token);
    return result.fold(
      (failure) => Left(failure),
      (levels) => Right(levels),
    );
  }
@override
Future<Either<Failure, DashboardModel>> getDashboardSummary({required int halaqaId}) async {
  print("🔵 [Repository] بدء الطلب getDashboardSummary لحلقة $halaqaId");
  final token = await storage.read(key: 'auth_token');
  print("📌 [Repository] التوكن المسترجع: $token");

  if (token == null) {
    return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
  }

  final result = await apiDatasource.getDashboardSummary(
    token: token,
    halaqaId: halaqaId,
  );
  print("📩 [Repository] الرد الأولي من API: $result");

  return result.fold(
    (failure) {
      print("❌ [Repository] فشل الاتصال: ${failure.message}");
      return Left(failure);
    },
    (data) {
      try {
        print("✅ [Repository] البيانات قبل التحويل: $data");
        return Right(DashboardModel.fromJson(data));
      } catch (e) {
        print("❌ [Repository] خطأ في التحويل: $e");
        return const Left(UnexpectedFailure(message: 'فشل في تحليل بيانات لوحة التحكم.'));
      }
    },
  );
}


@override
  Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
     String? firstName,
    String? lastName,
    String? phone,
    String? address,
    // كلمة المرور الحالية دائماً مطلوبة للتأكيد
    required String currentPassword,
  }) async {
    final String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    final result = await apiDatasource.updateTeacherProfile(
      token: token,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      address: address,
      currentPassword: currentPassword, // تم التغيير هنا
    );

    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          // الـ API يرجع الآن بيانات جاهزة للتحليل مباشرة
          return Right(TeacherProfile.fromJson(data));
        } catch (e) {
          log('Failed to parse updated TeacherProfile: $e');
          return const Left(UnexpectedFailure(message: 'فشل في تحليل بيانات الملف الشخصي المحدثة.'));
        }
      },
    );
  }
  
  // دالة getTeacherProfile تبقى كما هي تقريباً، فقط تأكد أنها تتعامل مع استجابة API الجديدة
  @override
  Future<Either<Failure, TeacherProfile>> getTeacherProfile() async {
    final String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    final result = await apiDatasource.getTeacherProfile(token);
    return result.fold(
      (failure) => Left(failure),
      (data) {
        try {
          // الـ API يرجع الآن بيانات جاهزة للتحليل مباشرة
          return Right(TeacherProfile.fromJson(data));
        } catch (e) {
          log('Failed to parse TeacherProfile: $e');
          return const Left(UnexpectedFailure(message: 'فشل في تحليل بيانات الملف الشخصي.'));
        }
      },
    );
  }

   @override
  Future<Either<Failure, Map<String, dynamic>>> getNotifications(int page) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    return await apiDatasource.getNotifications(token, page);
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String notificationId) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    return await apiDatasource.markNotificationAsRead(token, notificationId);
  }
}
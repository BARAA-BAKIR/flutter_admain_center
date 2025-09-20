// lib/data/repositories/teacher_repository_impl.dart

import 'dart:convert';
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
import 'package:flutter_admain_center/data/models/teacher/notification_model.dart';
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

  /// دالة جلب التوكن
  Future<String?> getToken() async {
    final userDataJson = await storage.read(key: 'user_data');
    if (userDataJson == null) return null;
    return jsonDecode(userDataJson)['token'];
  }
  //====================================================================
  // --- دوال جلب البيانات (Getters) ---
  //====================================================================

  // @override
  // Future<Either<Failure, MyhalaqaModel>> getMyHalaqaWithLocalData() async {
  //   // 1. اقرأ بيانات المستخدم المخزنة
  //  // final String? userJson = await storage.read(key: 'user_data');

  //   // 3. قم بفك تشفير JSON للحصول على البيانات واستخراج التوكن
  //  // final userData = jsonDecode(userJson);
  //   final String? token = await getToken();
  //   log('Token: $token');
  //   if (token == null) {
  //     // 4. في حالة عدم وجود توكن داخل البيانات، اعرض خطأ
  //     return const Left(
  //       CacheFailure(message: 'الرمز المميز (token) غير موجود في البيانات.'),
  //     );
  //   }

  //   // 5. استمر في تنفيذ باقي الدالة باستخدام التوكن الجديد
  //   final result = await apiDatasource.getMyHalaqa(token);

  //   return result.fold(
  //     (failure) async {
  //       log(
  //         "API failure, falling back to local cache. Reason: ${failure.toString()}",
  //       );
  //       final cachedHalaqa = await localDatasource.getCachedHalaqaData();
  //       if (cachedHalaqa != null) {
  //         return Right(await _mergeWithLocalFollowUps(cachedHalaqa));
  //       } else {
  //         return Left(failure);
  //       }
  //     },
  //     (data) async {
  //       log("API Success: Fetched Halaqa data from server.");
  //       final halaqaFromApi = MyhalaqaModel.fromJson(data);
  //       await localDatasource.cacheHalaqaData(halaqaFromApi);
  //       log("Cache Success: Saved latest Halaqa data locally.");
  //       return Right(await _mergeWithLocalFollowUps(halaqaFromApi));
  //     },
  //   );
  // }
  // @override
  // Future<Either<Failure, MyhalaqaModel>> getMyHalaqaWithLocalData() async {
  //   final String? token = await getToken();
  //   if (token == null)
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));

  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   final hasInternet = connectivityResult != ConnectivityResult.none;

  //   // إذا كان هناك إنترنت، نحاول الجلب من السيرفر أولاً
  //   if (hasInternet) {
  //     final result = await apiDatasource.getMyHalaqa(token);
  //     return result.fold(
  //       (failure) async {
  //         // فشل السيرفر؟ لا مشكلة، نلجأ للكاش
  //         log(
  //           "API failure, falling back to local cache. Reason: ${failure.toString()}",
  //         );
  //         return _getCachedAndMergedHalaqa();
  //       },
  //       (data) async {
  //         // نجح السيرفر؟ ممتاز، نخزن البيانات ونقوم بالدمج
  //         log("API Success: Fetched Halaqa data from server.");
  //         final halaqaFromApi = MyhalaqaModel.fromJson(data);
  //         await localDatasource.cacheHalaqaData(halaqaFromApi);
  //         log("Cache Success: Saved latest Halaqa data locally.");
  //         return Right(await _mergeWithLocalFollowUps(halaqaFromApi));
  //       },
  //     );
  //   } else {
  //     // لا يوجد إنترنت؟ نذهب مباشرة إلى الكاش
  //     log("🔌 Offline Mode: Fetching from local cache.");
  //     return _getCachedAndMergedHalaqa();
  //   }
  // }
@override
Future<Either<Failure, MyhalaqaModel?>> getMyHalaqaWithLocalData() async { // <-- لاحظ: MyhalaqaModel أصبحت nullable
  final String? token = await getToken();
  if (token == null) {
    return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
  }

  final connectivityResult = await (Connectivity().checkConnectivity());
  final hasInternet = connectivityResult != ConnectivityResult.none;

  if (hasInternet) {
    // إذا كان هناك إنترنت، نحاول الجلب من السيرفر
    final result = await apiDatasource.getMyHalaqa(token);
    
    return result.fold(
      (failure) async {
        // ====================  هنا هو الحل الرئيسي ====================
        // تحقق مما إذا كان الفشل هو ServerFailure ورسالته تحتوي على "لا يوجد حلقة"
        if (failure is ServerFailure && failure.message.contains('لا يوجد حلقة لديك')) {
          log("API Info: Server responded with 'No Halaqa Assigned'. This is a valid state.");
          // هذه ليست حالة فشل، بل حالة "فارغ".
          // 1. نمسح أي بيانات قديمة من الكاش لضمان عدم ظهورها لاحقًا.
          await localDatasource.clearAllData(); // <-- (دالة اختيارية ولكن موصى بها)
          // 2. نرجع "نجاح" مع قيمة null للإشارة إلى عدم وجود حلقة.
          return Right(null); 
        } else {
          // لأي فشل آخر (مثل خطأ في الشبكة، خطأ 500)، نلجأ للكاش
          log("API failure, falling back to local cache. Reason: ${failure.toString()}");
          return _getCachedAndMergedHalaqa();
        }
        // =============================================================
      },
      (data) async {
        // نجح السيرفر؟ ممتاز، نخزن البيانات ونقوم بالدمج
        log("API Success: Fetched Halaqa data from server.");
        final halaqaFromApi = MyhalaqaModel.fromJson(data);
        await localDatasource.cacheHalaqaData(halaqaFromApi);
        log("Cache Success: Saved latest Halaqa data locally.");
        return Right(await _mergeWithLocalFollowUps(halaqaFromApi));
      },
    );
  } else {
    // لا يوجد إنترنت؟ نذهب مباشرة إلى الكاش
    log("🔌 Offline Mode: Fetching from local cache.");
    return _getCachedAndMergedHalaqa();
  }}


// // تأكد من أن هذه الدالة المساعدة تتعامل مع null بشكل صحيح
// Future<Either<Failure, MyhalaqaModel?>> _getCachedAndMergedHalaqa() async {
//   try {
//     final cachedHalaqa = await localDatasource.getHalaqaData();
//     if (cachedHalaqa == null) {
//       // إذا كان الكاش فارغًا أيضًا، فهذا يعني أنه لا توجد بيانات على الإطلاق
//       return Right(null);
//     }
//     log("Cache Success: Fetched Halaqa from local storage.");
//     return Right(await _mergeWithLocalFollowUps(cachedHalaqa));
//   } on CacheException catch (e) {
//     return Left(CacheFailure(message: e.message));
//   }
// }

  // دالة مساعدة لجلب البيانات من الكاش ودمجها
  Future<Either<Failure, MyhalaqaModel>> _getCachedAndMergedHalaqa() async {
    final cachedHalaqa = await localDatasource.getCachedHalaqaData();
    if (cachedHalaqa != null) {
      return Right(await _mergeWithLocalFollowUps(cachedHalaqa));
    } else {
      return const Left(
        CacheFailure(
          message: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة محلياً.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> syncAllUnsyncedData() async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    final unsyncedFollowUps = await localDatasource.getUnsyncedFollowUps();
    final unsyncedDuties = await localDatasource.getUnsyncedDuties();

    final followUpsJson =
        unsyncedFollowUps.map((f) => f.toJsonForApi()).toList();
    final dutiesJson = unsyncedDuties.map((d) => d.toJsonForApi()).toList();

    final filteredFollowUps =
        followUpsJson
            .where(
              (item) =>
                  (item['student_id'] ?? 0) > 0 && (item['group_id'] ?? 0) > 0,
            )
            .toList();

    final filteredDuties =
        dutiesJson.where((item) => (item['student_id'] ?? 0) > 0).toList();

    if (filteredFollowUps.isEmpty && filteredDuties.isEmpty) {
      log("⚠️ No valid data to sync.");
      return const Right("لا توجد بيانات جديدة للمزامنة.");
    }

    final result = await apiDatasource.syncBulkData(
      token: token,
      followUps: filteredFollowUps,
      duties: filteredDuties,
    );

    return result.fold((failure) => Left(failure), (data) async {
      await localDatasource.markFollowUpsAsSynced(unsyncedFollowUps);
      await localDatasource.markDutiesAsSynced(unsyncedDuties);
      log("✅ Local DB updated after successful sync.");
      return Right(data['message'] ?? 'تمت المزامنة بنجاح');
    });
  }

  //====================================================================
  // --- دوال أخرى (Others) ---
  //====================================================================

  @override
  Future<Either<Failure, Map<String, dynamic>>> addStudent({
   
    required AddStudentModel studentData,
  }) async {
    final String token = await getToken()??'';
    final result = await apiDatasource.addStudent(
      token: token,
      studentData: studentData,
    );
    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  //====================================================================
  // --- دوال مساعدة خاصة (Private Helpers) ---
  //====================================================================

  Future<MyhalaqaModel> _mergeWithLocalFollowUps(MyhalaqaModel halaqa) async {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final localFollowUps = await localDatasource.getFollowUpsForDate(
      todayString,
    );
    if (localFollowUps.isEmpty) {
      return halaqa;
    }
    for (var student in halaqa.students) {
      final localData = localFollowUps.firstWhereOrNull(
        (f) => f.studentId == student.id,
      );
      if (localData != null) {
        student.attendanceStatus =
            localData.attendance == 1
                ? AttendanceStatus.present
                : AttendanceStatus.absent;
        student.hasTodayFollowUp = true;
      }
    }
    log(
      "Merge Success: Merged ${localFollowUps.length} local follow-ups with Halaqa data.",
    );
    return halaqa;
  }

  @override
  Future<Either<Failure, StudentProfileModel>> getStudentProfile(
    int studentId,
  ) async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.getStudentProfile(token, studentId);
    return result.fold((failure) => Left(failure), (data) {
      try {
        // يجب أن نتحقق من أن `data` يحتوي على البيانات المطلوبة قبل التحويل
        // وإلا قد يحدث خطأ في التحويل
        return Right(StudentProfileModel.fromJson(data['data']));
      } catch (e) {
        log('Failed to parse StudentProfileModel: $e');
        return const Left(
          UnexpectedFailure(message: 'فشل في تحليل بيانات ملف الطالب.'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, HalaqaModel>> fetchHalaqaInfo(int halaqaId) async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.fetchHalaqaInfo(token, halaqaId);
    return result.fold((failure) => Left(failure), (data) {
      try {
        return Right(HalaqaModel.fromJson(data));
      } catch (e) {
        log('Failed to parse HalaqaModel: $e');
        return const Left(
          UnexpectedFailure(message: 'فشل في تحليل بيانات الحلقة.'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFollowUpAndDutyForStudent(
    int studentId,
    String date,
  ) async {
    // 1. البحث محلياً أولاً
    DailyFollowUpModel? localFollowUp = await localDatasource.getFollowUp(
      studentId,
      date,
    );
    DutyModel? localDuty = await localDatasource.getDuty(studentId);

    if (localFollowUp != null) {
      print("Found local data for today. No need to fetch from server.");
      return Right({'followUp': localFollowUp, 'duty': localDuty});
    }

    print("No local data for today. Fetching latest from server...");
    final String? token = await getToken();
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
        print(
          "❌ Error fetching from server: ${failure.message}. Returning local duty if available.",
        );
        return Right({'followUp': null, 'duty': localDuty});
      },
      (serverData) async {
        final DailyFollowUpModel? serverFollowUp = serverData['followUp'];
        final DutyModel? serverDuty = serverData['duty'];

        // نقوم بتخزين البيانات القادمة من السيرفر محلياً
        if (serverFollowUp != null) {
          await localDatasource.upsertFollowUp(
            serverFollowUp.copyWith(isSynced: false),
          );
        }
        if (serverDuty != null) {
          await localDatasource.upsertDuty(
            serverDuty.copyWith(isSynced: false),
          );
        }
        return Right({'followUp': serverFollowUp, 'duty': serverDuty});
      },
    );
  }

  // @override
  // Future<Either<Failure, bool>> storeFollowUpAndDuty(
  //   DailyFollowUpModel followUp,
  //   DutyModel duty,
  // ) async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   final hasInternet = connectivityResult != ConnectivityResult.none;
  //   final String? token = await getToken();

  //   if (!hasInternet || token == null) {
  //     log("🔌 Offline Mode or no token: Saving locally.");
  //     await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
  //     await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
  //     return const Left(
  //       ConnectionFailure(message: 'لا يوجد اتصال بالإنترنت. تم الحفظ محليًا.'),
  //     );
  //   }

  //   final results = await Future.wait([
  //     apiDatasource.storeFollowUp(
  //       token: token,
  //       followUpData: followUp.toJsonForApi(),
  //     ),
  //     apiDatasource.storeDuty(token: token, dutyData: duty.toJsonForApi()),
  //   ]);

  //   final followUpResult = results[0];
  //   final dutyResult = results[1];

  //   // إذا نجحت كلتا العمليتين
  //   if (followUpResult.isRight() && dutyResult.isRight()) {
  //     followUp = followUp.copyWith(isSynced: true);
  //     duty = duty.copyWith(isSynced: true);
  //     log("✅ Sync Success: Data sent to server.");
  //     await localDatasource.upsertFollowUp(followUp);
  //     await localDatasource.upsertDuty(duty);
  //     return const Right(true);
  //   } else {
  //     // إذا فشلت إحدى العمليتين، نجد الخطأ الأول ونُرجعه
  //     // ✅ الطريقة الصحيحة لاستخراج الخطأ
  //     final Failure error =
  //         followUpResult.isLeft()
  //             ? (followUpResult as Left).value as Failure
  //             : (dutyResult as Left).value as Failure;

  //     log("❌ Sync Failed: Saving locally. Reason: ${error.message}");
  //     await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
  //     await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
  //     return Left(error);
  //   }
  // }
  @override
  Future<Either<Failure, bool>> storeFollowUpAndDuty(
    DailyFollowUpModel followUp,
    DutyModel duty,
  ) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final hasInternet = connectivityResult != ConnectivityResult.none;
    final String? token = await getToken();

    // إذا لم يكن هناك إنترنت أو توكن، نحفظ محلياً فقط
    if (!hasInternet || token == null) {
      log("🔌 Offline Mode or no token: Saving locally.");
      await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
      await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
      // نرجع Right(false) ليعرف البلوك أن الحفظ تم محلياً فقط
      return const Right(false);
    }

    // إذا كان هناك إنترنت، نحاول الإرسال للسيرفر
    final followUpResult = await apiDatasource.storeFollowUp(
      token: token,
      followUpData: followUp.toJsonForApi(),
    );
    final dutyResult = await apiDatasource.storeDuty(
      token: token,
      dutyData: duty.toJsonForApi(),
    );

    // إذا نجحت كلتا العمليتين
    if (followUpResult.isRight() && dutyResult.isRight()) {
      log("✅ Sync Success: Data sent to server.");
      await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: true));
      await localDatasource.upsertDuty(duty.copyWith(isSynced: true));
      // نرجع Right(true) ليعرف البلوك أن المزامنة نجحت
      return const Right(true);
    } else {
      // إذا فشلت إحدى العمليتين، نحفظ محلياً
      log("❌ Sync Failed: Saving locally.");
      await localDatasource.upsertFollowUp(followUp.copyWith(isSynced: false));
      await localDatasource.upsertDuty(duty.copyWith(isSynced: false));
      // نرجع Right(false) ليعرف البلوك أن الحفظ تم محلياً
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, List<LevelModel>>> getLevels() async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.getLevels(token);
    return result.fold((failure) => Left(failure), (levels) => Right(levels));
  }

  @override
  Future<Either<Failure, DashboardModel>> getDashboardSummary({
    required int halaqaId,
  }) async {
    print("🔵 [Repository] بدء الطلب getDashboardSummary لحلقة $halaqaId");
    final String? token = await getToken();
    // هذا السطر يسبب خطأ

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
        return Left(failure);
      },
      (data) {
        try {
          print("✅ [Repository] البيانات قبل التحويل: $data");
          return Right(DashboardModel.fromJson(data));
        } catch (e) {
          return const Left(
            UnexpectedFailure(message: 'فشل في تحليل بيانات لوحة التحكم.'),
          );
        }
      },
    );
  }

  @override
  // Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
  //   String? firstName,
  //   String? lastName,
  //   String? phone,
  //   String? address,
  //   // كلمة المرور الحالية دائماً مطلوبة للتأكيد
  //   required String currentPassword,
  // }) async {
  //   final String? token = await getToken();
  //   if (token == null) {
  //     return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
  //   }

  //   final result = await apiDatasource.updateTeacherProfile(
  //     token: token,
  //     firstName: firstName,
  //     lastName: lastName,
  //     phone: phone,
  //     address: address,
  //     currentPassword: currentPassword, // تم التغيير هنا
  //   );

  //   return result.fold((failure) => Left(failure), (data) {
  //     try {
  //       // الـ API يرجع الآن بيانات جاهزة للتحليل مباشرة
  //       return Right(TeacherProfile.fromJson(data));
  //     } catch (e) {
  //       log('Failed to parse updated TeacherProfile: $e');
  //       return const Left(
  //         UnexpectedFailure(
  //           message: 'فشل في تحليل بيانات الملف الشخصي المحدثة.',
  //         ),
  //       );
  //     }
  //   });
  // }
// In data/repositories/teacher_repository_impl.dart
@override
Future<Either<Failure, TeacherProfile>> updateTeacherProfile({
  required String firstName,
  required String lastName,
  String? fatherName,
  String? motherName,
  DateTime? birthDate,
  String? educationLevel,
  required String gender,
  required String phone,
  String? address,
  required String currentPassword,
  String? newPassword,
  String? newPasswordConfirmation,
}) async {
  final String? token = await getToken();
  if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));

  final result = await apiDatasource.updateTeacherProfile(
    token: token,
    firstName: firstName,
    lastName: lastName,
    fatherName: fatherName,
    motherName: motherName,
    birthDate: birthDate,
    educationLevel: educationLevel,
    gender: gender,
    phone: phone,
    address: address,
    currentPassword: currentPassword,
    newPassword: newPassword,
    newPasswordConfirmation: newPasswordConfirmation,
  );

  return result.fold(
    (failure) => Left(failure),
    (data) {
      try {
        return Right(TeacherProfile.fromJson(data));
      } catch (e) {
        return Left(ParsingFailure(message: 'فشل في تحليل بيانات الملف الشخصي المحدثة: $e'));
      }
    },
  );
}

  // دالة getTeacherProfile تبقى كما هي تقريباً، فقط تأكد أنها تتعامل مع استجابة API الجديدة
  @override
  Future<Either<Failure, TeacherProfile>> getTeacherProfile() async {
      log('Failed to parse TeacherProfile: start');
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }

    final result = await apiDatasource.getTeacherProfile(token);
      log('Failed to parse TeacherProfile: $result');
    return result.fold((failure) => Left(failure), (data) {
      try {
        // الـ API يرجع الآن بيانات جاهزة للتحليل مباشرة
        return Right(TeacherProfile.fromJson(data));
      } catch (e) {
        log('Failed to parse TeacherProfile: $e');
        return const Left(
          UnexpectedFailure(message: 'فشل في تحليل بيانات الملف الشخصي.'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(
    String notificationId,
  ) async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    return await apiDatasource.markNotificationAsRead(token, notificationId);
  }

  // 3. دالة تسجيل الحضور (السيناريو الثالث)
  @override
  Future<Either<Failure, void>> markAttendanceOnly(
    int studentId,
    int halaqaId,
    bool isPresent,
  ) async {
    // هذه الدالة تقوم بإنشاء سجل متابعة افتراضي وحفظه
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // نحاول جلب البيانات الموجودة للطالب لتجنب الكتابة فوقها
    final existingData = await getFollowUpAndDutyForStudent(studentId, today);

    return existingData.fold(
      (l) => Left(l), // إذا فشل جلب البيانات، نرجع الخطأ
      (data) async {
        final DailyFollowUpModel? existingFollowUp = data['followUp'];
        final DutyModel? existingDuty = data['duty'];

        final followUpToSave = DailyFollowUpModel(
          studentId: studentId,
          halaqaId: halaqaId,
          date: today,
          attendance: isPresent ? 1 : 0,
          // نحافظ على القيم القديمة إن وجدت، وإلا نضع قيماً افتراضية
          savedPagesCount: existingFollowUp?.savedPagesCount ?? 0,
          reviewedPagesCount: existingFollowUp?.reviewedPagesCount ?? 0,
          memorizationScore: existingFollowUp?.memorizationScore ?? 0,
          reviewScore: existingFollowUp?.reviewScore ?? 0,
        );

        final dutyToSave = DutyModel(
          studentId: studentId,
          startPage: existingDuty?.startPage ?? 0,
          endPage: existingDuty?.endPage ?? 0,
          requiredParts: existingDuty?.requiredParts ?? '',
        );

        // نستدعي دالة الحفظ التي كتبناها في الأعلى
        final result = await storeFollowUpAndDuty(followUpToSave, dutyToSave);
        return result.fold(
          (failure) => Left(failure),
          (_) => const Right(null), // نجح الأمر
        );
      },
    );
  }

 // In lib/data/repositories/teacher_repository_impl.dart

// ... (داخل class TeacherRepositoryImpl)

@override
Future<Either<Failure, List<Map<String, dynamic>>>> getPartsForStudent(int studentId) async {
    final token = await getToken();
    if (token == null) return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));

    final result = await apiDatasource.getPartsForStudent(token, studentId);

    // ====================  إضافة كود تصحيح الأخطاء ====================
    return result.fold(
      (failure) {
        print("❌ ERROR in TeacherRepositoryImpl -> getPartsForStudent: ${failure.message}");
        return Left(failure);
      },
      (data) {
        print("✅ SUCCESS in TeacherRepositoryImpl -> getPartsForStudent: Received ${data.length} parts.");
        return Right(data);
      }
    );
    // =====================================================================
}



  @override
  Future<Either<Failure, Map<String, dynamic>>> getNotifications(
    int page,
  ) async {
    final String? token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    final result = await apiDatasource.getNotifications(token);
    return result.fold((failure) => Left(failure), (data) {
      try {
        final List<dynamic> notificationList = data['data'];
        final notifications = notificationList.map((json) => NotificationModel.fromJson(json)).toList();
        return Right({
          'notifications': notifications,
          'meta': data['meta'] ?? {},
        });
      } catch (e) {
        return Left(
          ParsingFailure(
            message: "Failed to parse notifications: ${e.toString()}",
          ),
        );
      }
    });
  }
  @override
  Future<Either<Failure, void>> syncStudentParts(
    int studentId,
    List<int> partIds,
  ) async {
    final token = await getToken();
    if (token == null) {
      return const Left(CacheFailure(message: 'المستخدم غير مسجل دخوله.'));
    }
    return await apiDatasource.syncStudentParts(token, studentId, partIds);
  }

  
  @override
  Future<Either<Failure, void>> verifyPassword(String password) async {
    try {
      final token = await getToken();
      if (token == null) {
        return Left(CacheFailure(message: 'تسجيل الدخول خاطئ'));
      }
      await apiDatasource.verifyPassword(token, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

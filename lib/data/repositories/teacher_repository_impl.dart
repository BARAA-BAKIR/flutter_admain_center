// lib/data/repositories/teacher_repository_impl.dart

import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/models/add_student_model.dart';
import 'package:flutter_admain_center/data/models/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/duty_model.dart';
import 'package:flutter_admain_center/data/models/level_model.dart';
import 'package:flutter_admain_center/data/models/myhalaqa_model.dart';
import 'package:flutter_admain_center/data/models/student_model.dart';
import 'package:flutter_admain_center/data/models/student_profile_model.dart';
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
  Future<MyhalaqaModel> getMyHalaqaWithLocalData() async {
    try {
      // 1. محاولة جلب البيانات من الشبكة أولاً
      final String? token = await storage.read(key: 'auth_token');
      if (token == null) throw Exception('المستخدم غير مسجل دخوله');

      final result = await apiDatasource.getMyHalaqa(token);

      if (result['success']) {
        log("API Success: Fetched Halaqa data from server.");
        final halaqaFromApi = MyhalaqaModel.fromJson(result['data']);

        // 2. نجحنا -> نحفظ البيانات في الكاش المحلي
        await localDatasource.cacheHalaqaData(halaqaFromApi);
        log("Cache Success: Saved latest Halaqa data locally.");

        // 3. ندمجها مع بيانات المتابعة المحلية ونرجعها
        return await _mergeWithLocalFollowUps(halaqaFromApi);
      } else {
        // فشل الـ API لسبب ما (مثل خطأ 404)، ننتقل إلى المحلي
        throw Exception("API call was not successful, trying local cache...");
      }
    } catch (e) {
      // 4. فشل الاتصال بالشبكة أو أي خطأ آخر -> نلجأ إلى الكاش المحلي
      log(
        "Network Error: Could not fetch from server, falling back to local cache. Reason: $e",
      );
      final cachedHalaqa = await localDatasource.getCachedHalaqaData();

      if (cachedHalaqa != null) {
        log("Cache Hit: Found cached Halaqa data.${cachedHalaqa.namehalaqa}");
        // وجدنا بيانات محفوظة -> ندمجها مع المتابعة المحلية ونرجعها
        return await _mergeWithLocalFollowUps(cachedHalaqa);
      } else {
        // لا يوجد إنترنت ولا يوجد كاش -> هنا فقط نرمي الخطأ النهائي
        throw Exception('لا يوجد اتصال بالإنترنت وبيانات محفوظة لعرضها.');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getFollowUpAndDutyForStudent(
    int studentId,
    String date,
  ) async {
    // يجلب البيانات من المحلي أولاً لأنه الأسرع
    final localFollowUp = await localDatasource.getFollowUp(studentId, date);
    final localDuty = await localDatasource.getDuty(studentId);

    // TODO: يمكن إضافة منطق لجلب البيانات من السيرفر إذا لم تكن موجودة محلياً

    return {'followUp': localFollowUp, 'duty': localDuty};
  }

  @override
  Future<List<LevelModel>> getLevels() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw Exception('User not authenticated');
    return await apiDatasource.getLevels(token);
  }

  //====================================================================
  // --- دوال الحفظ والمزامنة (Savers & Syncers) ---
  //====================================================================

  @override
  Future<bool> storeFollowUpAndDuty(
    DailyFollowUpModel followUp,
    DutyModel duty,
  ) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    final hasInternet = connectivityResult != ConnectivityResult.none;
    final token = await storage.read(key: 'auth_token');

    bool wasSynced = false; // متغير لتتبع حالة المزامنة

    if (hasInternet && token != null) {
      try {
        final results = await Future.wait([
          apiDatasource.storeFollowUp(
            token: token,
            followUpData: followUp.toJsonForApi(),
          ),
          apiDatasource.storeDuty(token: token, dutyData: duty.toJsonForApi()),
        ]);

        final bool followUpSuccess = results[0]['success'] as bool;
        final bool dutySuccess = results[1]['success'] as bool;

        if (followUpSuccess && dutySuccess) {
          followUp.isSynced = true;
          duty.isSynced = true;
          wasSynced = true; // ✅ نجحت المزامنة
          log("✅ Sync Success: Data sent to server.");
        } else {
          throw Exception("API Error...");
        }
      } catch (e) {
        followUp.isSynced = false;
        duty.isSynced = false;
        wasSynced = false; // ❌ فشلت المزامنة
        log("❌ Sync Failed: Saving locally. Reason: $e");
      }
    } else {
      followUp.isSynced = false;
      duty.isSynced = false;
      wasSynced = false; // 🔌 لا يوجد إنترنت، تم الحفظ محلياً فقط
      log("🔌 Offline Mode: Saving locally.");
    }

    // في كل الحالات، نقوم بالحفظ المحلي
    await localDatasource.upsertFollowUp(followUp);
    await localDatasource.upsertDuty(duty);

    // نعيد حالة المزامنة النهائية
    return wasSynced;
  }

  @override
  Future<void> syncAllUnsyncedData() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      log("Sync Aborted: User not authenticated.");
      return; // لا تفعل شيئاً إذا لم يكن المستخدم مسجلاً
    }

    // 1. جلب كل البيانات غير المتزامنة من المحلي
    final unsyncedFollowUps = await localDatasource.getUnsyncedFollowUps();
    final unsyncedDuties = await localDatasource.getUnsyncedDuties();

    // 2. تحويل البيانات إلى JSON
    final followUpsJson =
        unsyncedFollowUps.map((f) => f.toJsonForApi()).toList();
    final dutiesJson = unsyncedDuties.map((d) => d.toJsonForApi()).toList();

    // ✅ فلترة السجلات التي لا تحتوي على IDs صحيحة (>0)
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
      return;
    }

    // 3. إرسال البيانات للسيرفر
    final result = await apiDatasource.syncBulkData(
      token: token,
      followUps: filteredFollowUps,
      duties: filteredDuties,
    );

    // 4. إذا نجحت المزامنة
    if (result['success']) {
      await localDatasource.markFollowUpsAsSynced(unsyncedFollowUps);
      await localDatasource.markDutiesAsSynced(unsyncedDuties);
      log("✅ Local DB updated after successful sync.");
    } else {
      throw Exception(result['message'] ?? 'فشل المزامنة مع الخادم.');
    }
  }

  //====================================================================
  // --- دوال أخرى (Others) ---
  //====================================================================

  @override
  Future<Map<String, dynamic>> addStudent({
    required String token,
    required AddStudentModel studentData,
  }) async {
    return await apiDatasource.addStudent(
      token: token,
      studentData: studentData,
    );
  }

  //====================================================================
  // --- دوال مساعدة خاصة (Private Helpers) ---
  //====================================================================

  /// دالة مساعدة لدمج بيانات الحلقة مع بيانات المتابعة المحلية لليوم الحالي.
  Future<MyhalaqaModel> _mergeWithLocalFollowUps(MyhalaqaModel halaqa) async {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final localFollowUps = await localDatasource.getFollowUpsForDate(
      todayString,
    );

    if (localFollowUps.isEmpty) {
      // لا يوجد متابعات محلية لليوم، لا حاجة للدمج
      return halaqa;
    }

    for (var student in halaqa.students) {
      // =================================================================
      // --- هذا هو الجزء الذي تم تصحيحه ---
      // =================================================================
      // نستخدم firstWhereOrNull التي تعيد null إذا لم تجد عنصراً، بدلاً من رمي خطأ.
      final localData = localFollowUps.firstWhereOrNull(
        (f) => f.studentId == student.id,
      );

      if (localData != null) {
        // وجدنا سجل متابعة محلي لهذا الطالب، نقوم بتحديث حالته
        student.attendanceStatus =
            localData.attendance == 1
                ? AttendanceStatus.present
                : AttendanceStatus.absent;
        student.hasTodayFollowUp = true;
      }
      // إذا كان localData هو null (للطالب الجديد)، لا نفعل شيئاً،
      // وتبقى حالته الافتراضية (pending).
      // =================================================================
    }
    log(
      "Merge Success: Merged ${localFollowUps.length} local follow-ups with Halaqa data.",
    );
    return halaqa;
  }

  // ... (داخل كلاس TeacherRepositoryImpl)

  // --- تنفيذ دالة جلب ملف الطالب الكامل ---
  @override
  Future<StudentProfileModel> getStudentProfile(int studentId) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('المستخدم غير مسجل دخوله');
    }

    final result = await apiDatasource.getStudentProfile(token, studentId);

    if (result['success']) {
      // إذا نجح الطلب، قم بتحويل الـ JSON إلى الموديل الخاص بنا
      return StudentProfileModel.fromJson(result['data']);
    } else {
      // إذا فشل، ارمِ خطأ بالرسالة القادمة من السيرفر
      throw Exception(result['message'] ?? 'فشل جلب بيانات ملف الطالب');
    }
  }

}

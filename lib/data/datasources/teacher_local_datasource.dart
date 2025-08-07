// // lib/data/datasources/teacher_local_datasource.dart

// import 'package:dio/dio.dart';
// import 'package:flutter_admain_center/core/services/database_service.dart';
// import 'package:flutter_admain_center/data/models/daily_follow_up_model1.dart';
// import 'package:flutter_admain_center/data/models/myhalaqa_model.dart';
// import 'package:sembast/sembast.dart';

// class TeacherLocalDatasource {
//   final DatabaseService _dbService = DatabaseService();
//   // اسم "المخزن" أو "الجدول" في Sembast
//   final _store = stringMapStoreFactory.store('follow_ups');

//    // --- جديد: مخزن خاص ببيانات الحلقة ---
//   final _halaqaStore = StoreRef.main();

//   // --- دالة جديدة: لحفظ بيانات الحلقة الكاملة ---
//   Future<void> cacheHalaqaData(MyhalaqaModel halaqa) async {
//     final db = await _dbService.database;
//     // نحفظ الكائن كاملاً تحت مفتاح ثابت
//     await _halaqaStore.record('my_halaqa').put(db, halaqa.toJson());
//   }

//   // --- دالة جديدة: لجلب بيانات الحلقة المحفوظة ---
//   Future<MyhalaqaModel?> getCachedHalaqaData() async {
//     final db = await _dbService.database;
//     final halaqaJson = await _halaqaStore.record('my_halaqa').get(db) as Map<String, dynamic>?;
//     if (halaqaJson != null) {
//       return MyhalaqaModel.fromJson(halaqaJson);
//     }
//     return null;
//   }

//   // دالة لحفظ أو تحديث متابعة طالب واحد
//   Future<void> upsertFollowUp(DailyFollowUpModel followUp) async {
//     final db = await _dbService.database;
//     // نستخدم studentId + date كمفتاح فريد لضمان عدم تكرار المتابعة لنفس الطالب في نفس اليوم
//     final key = '${followUp.studentId}_${followUp.date}';
//     await _store.record(key).put(db, followUp.toJson());
//   }

//   // دالة لجلب كل المتابعات لتاريخ معين
//   Future<List<DailyFollowUpModel>> getFollowUpsForDate(String date) async {
//     final db = await _dbService.database;
//     final finder = Finder(filter: Filter.equals('date', date));
//     final records = await _store.find(db, finder: finder);

//     return records.map((snapshot) {
//       return DailyFollowUpModel.fromSembast(snapshot.value);
//     }).toList();
//   }

//   // دالة لجلب كل المتابعات التي لم تتم مزامنتها
//   Future<List<DailyFollowUpModel>> getUnsyncedFollowUps() async {
//     final db = await _dbService.database;
//     final finder = Finder(filter: Filter.equals('isSynced', false));
//     final records = await _store.find(db, finder: finder);
//     return records.map((e) => DailyFollowUpModel.fromSembast(e.value)).toList();
//   }

//   // دالة لوضع علامة "تمت المزامنة" على مجموعة من المتابعات
//   Future<void> markAsSynced(List<DailyFollowUpModel> followUps) async {
//     final db = await _dbService.database;
//     for (var followUp in followUps) {
//       final key = '${followUp.studentId}_${followUp.date}';
//       // نحدث فقط حقل isSynced
//       await _store.record(key).update(db, {'isSynced': true});
//     }
//   }

//   // دالة لجلب متابعة طالب واحد في يوم معين
//   Future<DailyFollowUpModel?> getFollowUp(int studentId, String date) async {
//     final db = await _dbService.database;
//     final key = '${studentId}_${date}';
//     final record = await _store.record(key).get(db);

//     if (record != null) {
//       return DailyFollowUpModel.fromSembast(record);
//     }
//     return null;
//   }

//    // --- تنظيف البيانات القديمة ---
//   Future<void> cleanupOldFollowUps({int daysToKeep = 30}) async {
//     final db = await _dbService.database;
//     final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

//     final finder = Finder(
//       filter: Filter.and([
//         Filter.equals('isSynced', true),
//         Filter.lessThan('date', cutoffDate.toIso8601String()),
//       ]),
//     );

//     final deletedCount = await _store.delete(db, finder: finder);
//     print("🧹 تم حذف $deletedCount من السجلات القديمة من قاعدة البيانات المحلية");
//   }

//   // --- رفع جميع البيانات غير المرسلة (Bulk Sync) ---
//   Future<void> syncAllFollowUps() async {
//     final unsynced = await getUnsyncedFollowUps();
//     if (unsynced.isEmpty) {
//       print("✅ لا توجد بيانات غير مزامنة");
//       return;
//     }

//     try {
//       final dio = Dio();
//       final payload = unsynced.map((f) => f.toJson()).toList();

//       final response = await dio.post(
//         "https://your-api-url.com/api/bulk-sync", // <-- غيره حسب API Laravel
//         data: {"followUps": payload},
//       );

//       if (response.statusCode == 200) {
//         await markAsSynced(unsynced);
//         print("✅ تم رفع جميع المتابعات (${unsynced.length}) بنجاح");
//         await cleanupOldFollowUps(daysToKeep: 30);
//       } else {
//         print("⚠️ فشل رفع المتابعات: ${response.statusMessage}");
//       }
//     } catch (e) {
//       print("❌ خطأ في المزامنة: $e");
//     }
//   }

//    // --- دالة جديدة: لحفظ أو تحديث الواجب محلياً ---
//   Future<void> upsertDuty(DailyFollowUpModel duty) async {
//     final db = await _dbService.database;
//     // المفتاح هو رقم الطالب، لضمان وجود واجب واحد فقط له
//     await _store.record(duty.studentId.toString()).put(db, duty.toJson());
//   }

//   // --- دالة جديدة: لجلب واجب طالب معين ---
//   Future<DailyFollowUpModel?> getDuty(int studentId) async {
//     final db = await _dbService.database;
//     final record = await _store.record(studentId.toString()).get(db);
//     if (record != null) {
//       return DailyFollowUpModel.fromSembast(record);
//     }
//     return null;
//   }

// }
// lib/data/datasources/teacher_local_datasource.dart
// lib/data/datasources/teacher_local_datasource.dart
// lib/data/datasources/teacher_local_datasource.dart

import 'package:flutter_admain_center/core/services/database_service.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';
import 'package:flutter_admain_center/data/models/teacher/myhalaqa_model.dart';
import 'package:sembast/sembast.dart';

class TeacherLocalDatasource {
  final DatabaseService _dbService = DatabaseService();

  final _followUpStore = stringMapStoreFactory.store('follow_ups');
  final _dutyStore = stringMapStoreFactory.store('duties');
  final _halaqaStore = StoreRef.main();

  // --- دوال الحلقة ---
  Future<void> cacheHalaqaData(MyhalaqaModel halaqa) async {
    final db = await _dbService.database;
    await _halaqaStore.record('my_halaqa').put(db, halaqa.toJson());
  }

  Future<MyhalaqaModel?> getCachedHalaqaData() async {
    final db = await _dbService.database;
    final halaqaJson =
        await _halaqaStore.record('my_halaqa').get(db) as Map<String, dynamic>?;
    return halaqaJson != null ? MyhalaqaModel.fromJson(halaqaJson) : null;
  }

  // --- دوال المتابعة اليومية ---
  Future<void> upsertFollowUp(DailyFollowUpModel followUp) async {
    final db = await _dbService.database;
    final key = '${followUp.studentId}_${followUp.date}';
    await _followUpStore.record(key).put(db, followUp.toSembastJson());
  }

  Future<List<DailyFollowUpModel>> getUnsyncedFollowUps() async {
    final db = await _dbService.database;
    final finder = Finder(filter: Filter.equals('isSynced', false));
    final records = await _followUpStore.find(db, finder: finder);
    return records.map((e) => DailyFollowUpModel.fromSembast(e.value)).toList();
  }

  Future<void> markFollowUpsAsSynced(List<DailyFollowUpModel> followUps) async {
    final db = await _dbService.database;
    for (var followUp in followUps) {
      final key = '${followUp.studentId}_${followUp.date}';
      await _followUpStore.record(key).update(db, {'isSynced': true});
    }
  }
  
  Future<DailyFollowUpModel?> getFollowUp(int studentId, String date) async {
    final db = await _dbService.database;
    final key = '${studentId}_$date';
    final record = await _followUpStore.record(key).get(db);
    return record != null ? DailyFollowUpModel.fromSembast(record) : null;
  }
  
  Future<List<DailyFollowUpModel>> getFollowUpsForDate(String date) async {
    final db = await _dbService.database;
    final finder = Finder(filter: Filter.equals('date', date));
    final records = await _followUpStore.find(db, finder: finder);
    return records.map((snapshot) {
      return DailyFollowUpModel.fromSembast(snapshot.value);
    }).toList();
  }

  // --- دوال الواجب ---
  Future<void> upsertDuty(DutyModel duty) async {
    final db = await _dbService.database;
    final key = duty.studentId.toString();
    await _dutyStore.record(key).put(db, duty.toSembastJson());
  }

  Future<DutyModel?> getDuty(int studentId) async {
    final db = await _dbService.database;
    final record = await _dutyStore.record(studentId.toString()).get(db);
    return record != null ? DutyModel.fromSembast(record) : null;
  }
  
  Future<List<DutyModel>> getUnsyncedDuties() async {
    final db = await _dbService.database;
    final finder = Finder(filter: Filter.equals('isSynced', false));
    final records = await _dutyStore.find(db, finder: finder);
    return records.map((snapshot) {
      return DutyModel.fromSembast(snapshot.value);
    }).toList();
  }
  
  Future<void> markDutiesAsSynced(List<DutyModel> duties) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      for (var duty in duties) {
        final key = duty.studentId.toString();
        await _dutyStore.record(key).update(txn, {'isSynced': true});
      }
    });
  }

   Future<void> clearAllData() async {
    final db = await _dbService.database;
    await _followUpStore.drop(db);
    await _dutyStore.drop(db);
    await _halaqaStore.drop(db);
    print('🧹 تم مسح جميع البيانات المحلية بنجاح.');
  }
}
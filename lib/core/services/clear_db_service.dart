import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ClearDBService {
  static Future<void> clearLocalDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/follow_ups.db'; // اسم قاعدة بياناتك
    final file = File(dbPath);

    if (await file.exists()) {
      await file.delete();
      log("🗑️ قاعدة البيانات المحلية تم حذفها بنجاح");
    } else {
      log("ℹ️ لا توجد قاعدة بيانات محلية للحذف.");
    }
  }
}

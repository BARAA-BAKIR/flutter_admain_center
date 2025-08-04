// lib/core/services/database_service.dart

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern to ensure only one instance of the database is open
  // هذا يضمن أننا لا نفتح قاعدة البيانات عدة مرات في نفس الوقت
  DatabaseService._();
  static final DatabaseService _singleton = DatabaseService._();
  factory DatabaseService() => _singleton;

  // متغير لتخزين نسخة من قاعدة البيانات بعد فتحها
  Database? _database;

  // هذه هي الدالة التي ستستخدمها باقي أجزاء التطبيق للوصول إلى قاعدة البيانات
  Future<Database> get database async {
    // إذا كانت قاعدة البيانات مفتوحة بالفعل، أرجعها مباشرة
    if (_database != null) {
      return _database!;
    }
    // إذا لم تكن مفتوحة، قم بتهيئتها أولاً
    _database = await _initDb();
    return _database!;
  }

  // دالة التهيئة الداخلية
  Future<Database> _initDb() async {
    // احصل على المسار الافتراضي لتخزين ملفات التطبيق على الجهاز
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // ادمج المسار مع اسم ملف قاعدة البيانات الذي نريده
    final dbPath = join(appDocumentDir.path, 'teacher_app.db');
    // استخدم مكتبة sembast لفتح (أو إنشاء) قاعدة البيانات في هذا المسار
    final db = await databaseFactoryIo.openDatabase(dbPath);
    return db;
  }
}

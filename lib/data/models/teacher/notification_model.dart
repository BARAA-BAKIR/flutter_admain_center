import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  
  // ✅ 1. تخزين التاريخ الأصلي القادم من الـ API
 final DateTime createdAt; 

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt, // <-- تم التغيير هنا
  });

  // ✅ 2. دالة محسوبة (getter) لتنسيق التاريخ عند الحاجة إليه في الواجهة
  // String get createdAtFormatted {
  //   try {
  //     final dateTime = DateTime.parse(createdAt);
  //     return DateFormat('d MMMM yyyy, hh:mm a', 'ar').format(dateTime);
  //   } catch (e) {
  //     // في حالة فشل التحويل، أرجع النص الأصلي
  //     return createdAt;
  //   }
  // }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return NotificationModel(
      id: json['id'] ?? '',
      title: data['title'] ?? 'بدون عنوان',
      body: data['body'] ?? 'لا يوجد محتوى.',
      isRead: json['read_at'] != null,
      
      // ✅ 3. تخزين التاريخ الخام كما هو بدون تنسيق
         createdAt: DateTime.parse(json['created_at']),
    );
  }

  // ✅ 4. (اختياري ولكن موصى به) دالة لتحويل الموديل إلى Map
  // هذه الدالة مفيدة إذا كنت تحتاج لإرسال الكائن مرة أخرى للـ API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': {
        'title': title,
        'body': body,
      },
      'read_at': isRead ? DateTime.now().toIso8601String() : null,
      'created_at': createdAt,
    };
  }
}

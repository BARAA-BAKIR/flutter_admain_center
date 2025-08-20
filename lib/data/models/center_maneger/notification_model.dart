// import 'package:equatable/equatable.dart';

// class NotificationModel extends Equatable {
//   final int id; // ID الإشعار يكون عادة String
//   final String title;
//   final String body;
//   final String createdAt;
//   final bool isRead;

//   const NotificationModel({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.createdAt,
//     required this.isRead,
//   });

//   // ==================== هنا هو الإصلاح الكامل والنهائي ====================
//   // دالة FromJson محصّنة ضد الأخطاء
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     try {
//       // 1. استخراج البيانات من 'data' إذا كانت موجودة
//       final data = json.containsKey('data') && json['data'] is Map
//                    ? json['data'] as Map<String, dynamic>
//                    : json;

//       // 2. التحقق من وجود 'read_at'. إذا كان null، فالإشعار غير مقروء
//       final bool isNotificationRead = json['read_at'] != null;

//       // 3. بناء المودل مع قيم افتراضية آمنة
//       return NotificationModel(
//         id: json['id'] ?? 0, // <-- تحويل آمن إلى String
//         title: data['title']?.toString() ?? 'لا يوجد عنوان',
//         body: data['body']?.toString() ?? 'لا يوجد محتوى',
//         createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
//         isRead: isNotificationRead,
//       );
//     } catch (e, stacktrace) {
//       // 4. إذا فشل كل شيء، اطبع الخطأ وأرجع إشعاراً بديلاً آمناً
//       print('CRITICAL PARSING ERROR in NotificationModel.fromJson: $e');
//       print(stacktrace);
//       return NotificationModel(
//         id: 0,
//         title: 'خطأ في تحليل الإشعار',
//         body: e.toString(),
//         createdAt: DateTime.now().toIso8601String(),
//         isRead: true,
//       );
//     }
//   }
//   // ====================================================================

//   NotificationModel copyWith({
//     bool? isRead,
//   }) {
//     return NotificationModel(
//       id: id,
//       title: title,
//       body: body,
//       createdAt: createdAt,
//       isRead: isRead ?? this.isRead,
//     );
//   }

//   @override
//   List<Object?> get props => [id, title, body, createdAt, isRead];
// }
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  // ✅ الإصلاح: تم تغيير النوع إلى String
  final String id; 
  final String title;
  final String body;
  final String createdAt;
  final bool isRead;
  // ✅ الإضافة: حقول جديدة للقبول والرفض
  final String type; // نوع الإشعار، مثال: 'teacher_approval'
  final int? teacherId; // ID الأستاذ للموافقة عليه

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.teacherId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      final bool isNotificationRead = json['read_at'] != null;

      return NotificationModel(
        // ✅ الإصلاح: تحويل آمن إلى String
        id: json['id']?.toString() ?? 'no-id', 
        title: data['title']?.toString() ?? 'لا يوجد عنوان',
        body: data['body']?.toString() ?? 'لا يوجد محتوى',
        createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        isRead: isNotificationRead,
        // ✅ الإضافة: قراءة الحقول الجديدة من الـ JSON
        type: data['type']?.toString() ?? 'general', // قيمة افتراضية
        teacherId: int.tryParse(data['teacher_id']?.toString() ?? ''),
      );
    } catch (e, stacktrace) {
      print('CRITICAL PARSING ERROR in NotificationModel.fromJson: $e');
      print(stacktrace);
      return NotificationModel(
        id: 'error-id',
        title: 'خطأ في تحليل الإشعار',
        body: e.toString(),
        createdAt: DateTime.now().toIso8601String(),
        isRead: true,
        type: 'error',
        teacherId: null,
      );
    }
  }

  NotificationModel copyWith({ bool? isRead }) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
      teacherId: teacherId,
    );
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead, type, teacherId];
}

import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String type; // ✅ نوع الطلب (e.g., 'teacher_approval')
  final String title; // ✅ العنوان
  final String body; // ✅ المحتوى
  final int? teacherId; // ✅ رقم الأستاذ للموافقة/الرفض
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.teacherId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      // ✅ استخراج البيانات من الحقول الجديدة التي أضفناها في لارافيل
      type: json['request_type'] ?? 'general', 
      title: json['title'] ?? 'لا يوجد عنوان',
      body: json['body'] ?? 'لا يوجد محتوى',
      teacherId: json['teacher_id'],
      isRead: json['read_at'] != null,
      createdAt: json['created_at'],
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      teacherId: teacherId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, title, body, teacherId, isRead, createdAt];
}

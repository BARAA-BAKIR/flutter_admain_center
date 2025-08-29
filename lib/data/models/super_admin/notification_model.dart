import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String type;
  final Map<String, dynamic> body; // 'data' from Laravel is the body
  final DateTime createdAt;
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      body: json['data'] as Map<String, dynamic>, // The 'data' field holds the body
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  bool get isRead => readAt != null;

  @override
  List<Object?> get props => [id, type, body, createdAt, readAt];
}

import 'package:equatable/equatable.dart';

class PendingUser extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? centerName;
  final String createdAt;

  const PendingUser({
    required this.id,
    required this.name,
    required this.email,
    this.centerName,
    required this.createdAt,
  });

  factory PendingUser.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'] ?? {};
    final center = employee['center'] ?? {};
    
    return PendingUser(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      centerName: center['name'],
      createdAt: json['created_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, email, centerName, createdAt];
}

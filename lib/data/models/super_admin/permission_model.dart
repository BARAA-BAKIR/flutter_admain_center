import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final int id;
  final String name;

  const Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'] ?? 'N/A',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

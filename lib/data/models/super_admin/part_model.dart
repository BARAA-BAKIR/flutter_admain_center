// lib/data/models/part_model.dart
class Part {
  final int id;
  final String writing;

  Part({required this.id, required this.writing});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      writing: json['writing'],
    );
  }
}
// lib/data/models/halaqa_type_model.dart
class HalaqaType {
  final int id;
  final String name;

  HalaqaType({required this.id, required this.name});

  factory HalaqaType.fromJson(Map<String, dynamic> json) {
    return HalaqaType(
      id: json['id'],
      name: json['name'],
    );
  }
}
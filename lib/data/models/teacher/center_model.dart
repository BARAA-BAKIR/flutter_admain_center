// lib/data/models/center_model.dart
class CenterModel {
  final int id;
  final String name;

  CenterModel({required this.id, required this.name});

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

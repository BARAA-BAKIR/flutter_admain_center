class CenterFilterModel {
  final int id;
  final String name;

  CenterFilterModel({required this.id, required this.name});

  factory CenterFilterModel.fromJson(Map<String, dynamic> json) {
    return CenterFilterModel(id: json['id'], name: json['name']);
  }
}

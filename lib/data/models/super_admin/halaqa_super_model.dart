class HalaqasuperModel {
  final int id;
  final String name;

  const HalaqasuperModel({required this.id, required this.name});

  factory HalaqasuperModel.fromJson(Map<String, dynamic> json) {
    return HalaqasuperModel(
      id: json['id'],
      name: json['name'] ?? 'اسم غير محدد',
    );
  }
}

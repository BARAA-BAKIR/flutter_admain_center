class HalaqaNameModel {
  final int id;
  final String name;

  const HalaqaNameModel({required this.id, required this.name});

  factory HalaqaNameModel.fromJson(Map<String, dynamic> json) {
    return HalaqaNameModel(
      id: json['id'],
      name: json['name'] ?? 'اسم غير محدد',
    );
  }
}

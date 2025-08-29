// center_model.dart
class Center {
  final int id;
  final String name;
  final String region;
  final String governorate;
  final String city;

  Center({
    required this.id,
    required this.name,
    required this.region,
    required this.governorate,
    required this.city,
  });

  factory Center.fromJson(Map<String, dynamic> json) {
    return Center(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      governorate: json['governorate'],
      city: json['city'],
    );
  }
}
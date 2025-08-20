// lib/data/models/mosque_model.dart

import 'package:equatable/equatable.dart';

class Mosque extends Equatable {
  final int id;
  final String name;
  final String address;
  final int centerId;
  final int halaqaCount;
  // يمكن إضافة حقول Timestamps إذا كنت تحتاجها في الواجهة
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const Mosque({
    required this.id,
    required this.name,
    required this.address,
    required this.centerId, required this.halaqaCount,
    // required this.createdAt,
    // required this.updatedAt,
  });

  // دالة لتحويل JSON القادم من الـ API إلى كائن Mosque
  factory Mosque.fromJson(Map<String, dynamic> json) {
    return Mosque(
        
      id: json['id'],
      name: json['name'],
      address: json['address'],
      centerId: json['center_id'],
      halaqaCount: json['halaqa_count'] ?? 0,
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // دالة لتحويل كائن Mosque إلى JSON (قد لا تحتاجها ولكن من الجيد وجودها)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'center_id': centerId,
      'halaqa_count': halaqaCount,
      // 'created_at': createdAt.toIso8601String(),
      // 'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, address, centerId];
}

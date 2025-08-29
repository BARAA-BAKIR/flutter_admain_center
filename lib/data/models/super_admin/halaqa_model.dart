import 'package:equatable/equatable.dart';

class HalaqaModel extends Equatable {
  final int id;
  final String name;
  final String mosqueName;
  final String centerName; // ✅ إضافة اسم المركز
  final String typeName;
  final int? mosqueId; // ✅ لإعادة التعبئة في شاشة التعديل
  final int? centerId; // ✅ لإعادة التعبئة في شاشة التعديل
  final int? typeId;   // ✅ لإعادة التعبئة في شاشة التعديل

  const HalaqaModel({
    required this.id,
    required this.name,
    required this.mosqueName,
    required this.centerName,
    required this.typeName,
    this.mosqueId,
    this.centerId,
    this.typeId,
  });

  factory HalaqaModel.fromJson(Map<String, dynamic> json) {
    return HalaqaModel(
      id: json['id'],
      name: json['name'],
      mosqueName: json['mosque']?['name'] ?? 'غير محدد',
      centerName: json['mosque']?['center']?['name'] ?? 'غير محدد', // ✅
      typeName: json['halaqa_type']?['name'] ?? 'غير محدد',
      mosqueId: json['mosque_id'],
      centerId: json['mosque']?['center_id'],
      typeId: json['type'],
    );
  }

  @override
  List<Object?> get props => [id, name, mosqueName, centerName, typeName];
}

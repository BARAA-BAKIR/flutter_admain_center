import 'package:equatable/equatable.dart';

class MosqueModel extends Equatable {
  final int id;
  final String name;
  final String address;
  final String? centerName;
  final int? centerId; // ✅ تأكد من وجود هذا الحقل

  const MosqueModel({
    required this.id,
    required this.name,
    required this.address,
    this.centerName,
    this.centerId, // ✅
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    return MosqueModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      centerName: json['center']?['name'],
      centerId: json['center_id'], // ✅
    );
  }

  @override
  List<Object?> get props => [id, name, address, centerName, centerId];
}

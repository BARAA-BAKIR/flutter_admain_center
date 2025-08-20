import 'package:equatable/equatable.dart';

class CenterModel extends Equatable {
  final int id;
  final String name;
  final String? region;
  final String governorate;
  final String city;
  final String? address;
  final String? managerName;
  final int studentsCount; // ✅ --- 1. إضافة الحقل الجديد ---

  const CenterModel({
    required this.id,
    required this.name,
    this.region,
    required this.governorate,
    required this.city,
    this.address,
    this.managerName,
    required this.studentsCount, // ✅ --- 2. إضافته للمنشئ ---
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    final manager = json['manager'];
    final user = manager != null ? manager['user'] : null;
    
    return CenterModel(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      region: json['region'],
      governorate: json['governorate'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      address: json['address'],
      managerName: user != null ? user['name'] : 'غير محدد',
      // ✅ --- 3. قراءة الحقل الجديد من الـ JSON ---
      // الـ API يرجع 'students_count' عند استخدام withCount
      studentsCount: json['students_count'] ?? 0, 
    );
  }

  @override
  List<Object?> get props => [id, name, region, governorate, city, address, managerName, studentsCount]; // ✅ --- 4. إضافته للـ props ---
}

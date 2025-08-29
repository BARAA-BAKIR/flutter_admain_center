import 'package:equatable/equatable.dart';

class CenterModel extends Equatable {
  final int id;
  final String name;
  final String? region;
  final String governorate;
  final String city;
  final String? address;
  final String? managerName;
  final int studentsCount; 
  final int? managerId;
  const CenterModel({
    required this.id,
    required this.name,
    this.region,
    required this.governorate,
    required this.city,
    this.address,
    this.managerName,
    required this.studentsCount,
     this.managerId, // ✅ --- 2. إضافته للمنشئ ---
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
       String? managerFullName;
    
    // 1. تحقق مما إذا كان employeeadmin موجوداً وليس null
    if (json['employeeadmin'] != null && json['employeeadmin'] is Map) {
      final employeeAdminData = json['employeeadmin'];
      
      // 2. تحقق مما إذا كان employee موجوداً وليس null
      if (employeeAdminData['employee'] != null && employeeAdminData['employee'] is Map) {
        final employeeData = employeeAdminData['employee'];
        final firstName = employeeData['first_name'] ?? '';
        final lastName = employeeData['last_name'] ?? '';
        managerFullName = '$firstName $lastName'.trim();
      }
    }
    return CenterModel(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      region: json['region'],
      governorate: json['governorate'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      address: json['address'],
      managerName: managerFullName?.isNotEmpty == true ? managerFullName : 'غير محدد',
      managerId: json['manager_id'], // ✅ --- 3. قراءة الحقل الجديد من الـ JSON ---
      // الـ API يرجع 'students_count' عند استخدام withCount
      studentsCount: json['students_count'] ?? 0, 
    );
  }

  @override
  List<Object?> get props => [id, name, region, governorate, city, address, managerName, studentsCount, managerId]; // ✅ --- 4. إضافته للـ props ---
}

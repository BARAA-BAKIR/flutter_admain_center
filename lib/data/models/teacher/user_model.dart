// class UserModel {
//   final String token;
//   // يمكنك إضافة بيانات أخرى للمستخدم هنا لاحقاً
//   // final String name;
//   // final String email;

//   UserModel({required this.token});

//   // دالة لتحويل JSON القادم من الـ API إلى كائن Dart
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       token: json['token'],
//     );
//   }
// }
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String token;
  final List<String> roles; // <-- الحقل الجديد والمهم

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.roles,
  });

  // دالة للتحقق بسهولة إذا كان المستخدم يمتلك دوراً معيناً
  bool hasRole(String role) {
    return roles.contains(role);
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    // استخراج قائمة الأدوار من الـ JSON
    final rolesFromJson = json['user']['roles'] as List<dynamic>?;
    final rolesList = rolesFromJson?.map((role) => role.toString()).toList() ?? [];

    return UserModel(
      token: token,
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      roles: rolesList, // <-- استخدام القائمة هنا
    );
  }

  @override
  List<Object?> get props => [id, name, email, token, roles];

  
}

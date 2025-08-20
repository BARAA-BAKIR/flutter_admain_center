// // // class UserModel {
// // //   final String token;
// // //   // يمكنك إضافة بيانات أخرى للمستخدم هنا لاحقاً
// // //   // final String name;
// // //   // final String email;

// // //   UserModel({required this.token});

// // //   // دالة لتحويل JSON القادم من الـ API إلى كائن Dart
// // //   factory UserModel.fromJson(Map<String, dynamic> json) {
// // //     return UserModel(
// // //       token: json['token'],
// // //     );
// // //   }
// // // }
// // import 'package:equatable/equatable.dart';

// // class UserModel extends Equatable {
// //   final int id;
// //   final String name;
// //   final String email;
// //   final String? token; // التوكن قد يكون اختيارياً في بعض الحالات
// //   final List<String> roles;

// //   const UserModel({
// //     required this.id,
// //     required this.name,
// //     required this.email,
// //     this.token, // <-- تم جعله اختيارياً
// //     required this.roles,
// //   });

// //   bool hasRole(String role) {
// //     return roles.contains(role);
// //   }

// //   // ==================== هنا هو الإصلاح الكامل والنهائي ====================
// //   // الدالة الآن تقبل وسيطاً واحداً فقط، وهو الـ Map الكامل
// //   factory UserModel.fromJson(Map<String, dynamic> json, data) {
// //     // الخطوة 1: تحديد بيانات المستخدم. قد تكون متداخلة أو لا.
// //     final userData = json.containsKey('user') 
// //                    ? json['user'] as Map<String, dynamic> 
// //                    : json;

// //     // الخطوة 2: استخراج الأدوار بشكل آمن
// //     final rolesData = userData['roles'] as List<dynamic>? ?? [];
// //     final rolesList = rolesData.map((role) {
// //       // الأدوار قد تكون نصاً مباشراً أو Map يحتوي على 'name'
// //       if (role is Map) {
// //         return role['name'].toString();
// //       }
// //       return role.toString();
// //     }).toList();

// //     // الخطوة 3: بناء الكائن
// //     return UserModel(
// //       // التوكن يكون عادة في المستوى الأعلى من الـ JSON
// //       token: json['token'] as String?,
      
// //       // باقي البيانات من كائن المستخدم
// //       id: userData['id'] ?? 0,
// //       name: userData['name'] ?? '',
// //       email: userData['email'] ?? '',
// //       roles: rolesList,
// //     );
// //   }
// //   // ====================================================================

// //   @override
// //   List<Object?> get props => [id, name, email, token, roles];
// // }
// import 'package:equatable/equatable.dart';

// class UserModel extends Equatable {
//   final int id;
//   final String name;
//   final String email;
//   final String? token;
//   final List<String> roles;

//   const UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.token,
//     required this.roles,
//   });

//   bool hasRole(String role) {
//     return roles.contains(role);
//   }

//   // ==================== هذا هو التعريف الصحيح ====================
//   // يقبل وسيطاً واحداً فقط: Map<String, dynamic>
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     final userData = json.containsKey('user') 
//                    ? json['user'] as Map<String, dynamic> 
//                    : json;

//     final rolesData = userData['roles'] as List<dynamic>? ?? [];
//     final rolesList = rolesData.map((role) {
//       if (role is Map) {
//         return role['name'].toString();
//       }
//       return role.toString();
//     }).toList();

//     return UserModel(
//       token: json['token'] as String?,
//       id: userData['id'] ?? 0,
//       name: userData['name'] ?? '',
//       email: userData['email'] ?? '',
//       roles: rolesList,
//     );
//   }
//   // =============================================================

//   @override
//   List<Object?> get props => [id, name, email, token, roles];
// }
// في ملف user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? token;
  final List<String> roles;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.roles,
  });

  bool hasRole(String role) => roles.contains(role);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('user') ? json['user'] as Map<String, dynamic> : json;
    final rolesData = userData['roles'] as List<dynamic>? ?? [];
    final rolesList = rolesData.map((role) {
      if (role is Map) return role['name'].toString();
      return role.toString();
    }).toList();

    return UserModel(
      token: json['token'] as String?,
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      roles: rolesList,
    );
  }

  @override
  List<Object?> get props => [id, name, email, token, roles];
}

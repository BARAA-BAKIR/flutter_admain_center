class UserModel {
  final String token;
  // يمكنك إضافة بيانات أخرى للمستخدم هنا لاحقاً
  // final String name;
  // final String email;

  UserModel({required this.token});

  // دالة لتحويل JSON القادم من الـ API إلى كائن Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
    );
  }
}

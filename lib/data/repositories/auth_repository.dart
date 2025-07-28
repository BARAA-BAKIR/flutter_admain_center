// // lib/data/repositories/auth_repository.dart

// import 'dart:developer';

// import 'package:dio/dio.dart'; // <-- استيراد dio
// import 'package:flutter_admain_center/data/models/registration_model.dart';
// import 'package:flutter_admain_center/data/models/center_model.dart';

// class AuthRepository {
//   final Dio _dio;

//   // الرابط الأساسي للـ API الخاص بك
//   static const String _baseUrl =
//       "http://192.168.1.6:8000/api"; // 10.0.2.2 for Android Emulator

//   // Constructor لتهيئة dio مع الإعدادات الأساسية
//   AuthRepository()
//     : _dio = Dio(
//         BaseOptions(
//           baseUrl: _baseUrl,
//           connectTimeout: const Duration(seconds: 10), // مهلة الاتصال 5 ثواني
//           receiveTimeout: const Duration(
//             seconds: 10,
//           ), // مهلة استقبال البيانات 3 ثواني
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//   Future<List<CenterModel>> getCenters() async {
//     try {
//       final response = await _dio.get('/centers');
//       final List<dynamic> data = response.data['data'];
//       return data.map((json) => CenterModel.fromJson(json)).toList();
//     } catch (e) {
//       // يمكنك معالجة الخطأ هنا أو تركه للـ Bloc
//       rethrow;
//     }
//   }

//   // --- الدالة الجديدة لتسجيل الدخول ---
//   Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await _dio.post(
//         '/login', // افترض أن هذا هو مسار الـ API لتسجيل الدخول
//         data: {'email': email, 'password': password},
//       );

//       return {'success': true, 'data': response.data};
//     } on DioException catch (e) {
//       // ... (نفس منطق إدارة الأخطاء الموجود في registerTeacher)
//       if (e.response != null) {
//         final responseBody = e.response!.data;
//         String errorMessage = "فشل تسجيل الدخول. يرجى التحقق من بياناتك.";
//         if (responseBody is Map && responseBody.containsKey('message')) {
//           errorMessage = responseBody['message'];
//         }
//         return {'success': false, 'message': errorMessage};
//       }
//       return {'success': false, 'message': 'فشل الاتصال بالخادم.'};
//     } catch (e) {
//       return {'success': false, 'message': 'حدث خطأ غير متوقع.'};
//     }
//   }

//   // دالة لتسجيل أستاذ جديد (الآن تستخدم dio)
//   Future<Map<String, dynamic>> registerTeacher(
//     RegistrationModel registrationData,
//   ) async {
//     try {
//       // --- هذا هو التغيير الرئيسي ---
//       final response = await _dio.post(
//         '/register/teacher', // المسار النسبي فقط، لأن الرابط الأساسي معرف في BaseOptions
//         data: registrationData.toJson(), // dio يتعامل مع Map مباشرة
//       );
//       // --- نهاية التغيير الرئيسي ---

//       // dio يفترض أن أي status code في نطاق 2xx هو نجاح
//       // لذلك لا نحتاج للتحقق من response.statusCode == 201
//       return {
//         'success': true,
//         'data':
//             response.data, // response.data يحتوي على الـ Map المحول تلقائياً
//       };
//     } on DioException catch (e) {
//       // --- إدارة الأخطاء أصبحت أكثر قوة ---
//       log(e.toString()); // للمطور
//       // إذا كانت الاستجابة من السيرفر تحتوي على خطأ (مثل 422, 401, 500)
//       if (e.response != null) {
//         final responseBody = e.response!.data;
//         String errorMessage = "حدث خطأ من الخادم";

//         // التعامل مع أخطاء التحقق من الصحة (Validation)
//         if (responseBody is Map && responseBody.containsKey('errors')) {
//           errorMessage = responseBody['errors'].values.first[0];
//         } else if (responseBody is Map && responseBody.containsKey('error')) {
//           errorMessage = responseBody['error'];
//         }

//         return {'success': false, 'message': errorMessage};
//       }

//       // التعامل مع أخطاء الشبكة (Timeout, no internet, etc.)
//       switch (e.type) {
//         case DioExceptionType.connectionTimeout:
//         case DioExceptionType.sendTimeout:
//         case DioExceptionType.receiveTimeout:
//           return {'success': false, 'message': 'انتهت مهلة الاتصال بالخادم.'};
//         case DioExceptionType.badResponse:
//           return {'success': false, 'message': 'استجابة غير صالحة من الخادم.'};
//         case DioExceptionType.cancel:
//           return {'success': false, 'message': 'تم إلغاء الطلب.'};
//         default:
//           return {
//             'success': false,
//             'message': 'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.',
//           };
//       }
//     } catch (e) {
//       // لأي خطأ غير متوقع آخر
//       return {'success': false, 'message': 'حدث خطأ غير متوقع في التطبيق.'};
//     }
//   }
// }

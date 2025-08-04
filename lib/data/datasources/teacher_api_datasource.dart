import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_admain_center/data/models/add_student_model.dart';
import 'package:flutter_admain_center/data/models/level_model.dart';

class TeacherApiDatasource {
  final Dio _dio;

  static const String _baseUrl = "http://192.168.1.8:8000/api";
  TeacherApiDatasource()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
  // دالة الجلب لبيانات حلقتي
  Future<Map<String, dynamic>> getMyHalaqa(String token) async {
    try {
      final response = await _dio.get(
        '/get/myhalaqa/full/for/teacher/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      log('Response from getMyHalaqa: ${response.data}');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      if (e.response != null) {
        final responseBody = e.response!.data;
        String errorMessage = "فشل جلب بيانات الحلقة.";
        if (responseBody is Map && responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        }
        return {'success': false, 'message': errorMessage};
      }
      return {'success': false, 'message': 'فشل الاتصال بالخادم.'};
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع.'};
    }
  }

  Future<List<LevelModel>> getLevels(String token) async {
    try {
      final response = await _dio.get(
        '/studentprogressstages/get',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LevelModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل جلب قائمة المراحل');
    }
  }
  //دالة اضافة طالب 
  Future<Map<String, dynamic>> addStudent({
    required String token,
     required AddStudentModel studentData,
  }) async {
    try {
      log('Adding student with data: ${studentData.toJson()}');
      final response = await _dio.post(
        '/add/student/to/halaqa',
        data:studentData.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      if (e.response != null) {
        final responseBody = e.response!.data;
       // String errorMessage = "فشل إضافة الطالب.";
       String errorMessage='${e.message}';
       log(e.toString());
       log(token);
        if (responseBody is Map && responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        }
        return {'success': false, 'message': errorMessage};
      }
      return {'success': false, 'message': 'فشل الاتصال بالخادم.'};
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع.'};
    }
  }
 
 Future<Map<String, dynamic>> storeFollowUp({
    required String token,
    required Map<String, dynamic> followUpData,
  }) async {
    try {
      log('Sending follow-up data: $followUpData');
      final response = await _dio.post(
        '/followup/store', // المسار الذي اتفقنا عليه
        data: followUpData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      // التعامل مع الأخطاء
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'فشل حفظ المتابعة'
      };
    }
  }

  // --- دالة جديدة: لإرسال الواجب للسيرفر ---
  Future<Map<String, dynamic>> storeDuty({
    required String token,
    required Map<String, dynamic> dutyData,
  }) async {
    try {
      log( 'Sending duty data: $dutyData');
      final response = await _dio.post(
        '/duty/store', // المسار الذي اتفقنا عليه
        data: dutyData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      // التعامل مع الأخطاء
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'فشل حفظ الواجب'
      };
    }
  }

  // دالة لإرسال البيانات المجمعة للسيرفر
Future<Map<String, dynamic>> syncBulkData({
  required String token,
  required List<Map<String, dynamic>> followUps,
  required List<Map<String, dynamic>> duties,
}) async {
  try {
    log("🚀 Sending BULK data to server... ${followUps}${duties}");
    final response = await _dio.post(
      '/sync/bulk', // المسار الذي عرفناه في لارافل
      data: {
        'follow_ups': followUps,
        'duties': duties,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    log("✅ BULK Sync successful from API side.");
    return {'success': true, 'data': response.data};
  } on DioException catch (e) {
    log("❌ BULK Sync API Error: ${e.response?.data ?? e.message}");
    // يمكنك تحليل e.response.data هنا لعرض أخطاء التحقق للمستخدم
    return {'success': false, 'message': 'فشل المزامنة الجماعية'};
  }
}
// ... (داخل كلاس TeacherApiDatasource)

  // --- دالة جديدة: لجلب ملف الطالب الكامل ---
  Future<Map<String, dynamic>> getStudentProfile(String token, int studentId) async {
    try {
      final response = await _dio.get(
        '/student/$studentId/profile', // المسار الذي عرفناه في لارافل
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // الاستجابة من لارافل تحتوي على 'success' و 'data'
      // نحن نهتم بالبيانات الموجودة داخل مفتاح 'data'
      if (response.data['success'] == true) {
        return {'success': true, 'data': response.data['data']};
      } else {
        return {'success': false, 'message': response.data['message'] ?? 'فشل جلب البيانات من السيرفر'};
      }
    } on DioException catch (e) {
      // معالجة أخطاء الشبكة
      return {'success': false, 'message': 'فشل الاتصال بالخادم: ${e.message}'};
    } catch (e) {
      // معالجة أي خطأ آخر
      return {'success': false, 'message': 'حدث خطأ غير متوقع: ${e.toString()}'};
    }
  }

}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/error/failures.dart';

// دالة مساعدة لتغليف استدعاءات الـ API بأمان
Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return Right(result);
  } on DioException catch (e) {
    // ==================== هنا هو التعديل الأهم ====================
    if (e.response?.statusCode == 422 && e.response?.data != null) {
      // هذا خطأ تحقق من الصحة (Validation Error)
      final errors = e.response!.data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        // استخراج أول رسالة خطأ من القائمة
        final firstErrorField = errors.keys.first;
        final firstErrorMessage = (errors[firstErrorField] as List).first;
        // إرجاع رسالة خطأ واضحة للمستخدم
        return Left(ServerFailure(message: firstErrorMessage));
      }
    }
    // =============================================================

    // التعامل مع باقي أخطاء Dio
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const Left(ConnectionFailure(message: 'فشل الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت.'));
    }
    // التعامل مع الأخطاء العامة من الخادم
    final message = e.response?.data['message'] ?? 'حدث خطأ غير متوقع في الخادم.';
    return Left(ServerFailure(message: message));
  } catch (e) {
    // التعامل مع أي أخطاء أخرى غير متوقعة (مثل أخطاء التحويل)
    return Left(UnexpectedFailure(message: 'حدث خطأ غير متوقع في التطبيق: ${e.toString()}'));
  }
}

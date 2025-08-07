// lib/core/utils/safe_api_call.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admain_center/core/error/failures.dart';

typedef ApiCall<T> = Future<T> Function();

Future<Either<Failure, T>> safeApiCall<T>(ApiCall<T> apiCall) async {
  try {
    final result = await apiCall();
    return Right(result);
  } on DioException catch (e) {
    log('DioException: ${e.response?.data ?? e.message}');
    if (e.response != null) {
      final responseBody = e.response!.data;
      String errorMessage = "حدث خطأ من الخادم";
      
      if (responseBody is Map && responseBody.containsKey('errors')) {
        errorMessage = responseBody['errors'].values.first[0];
      } else if (responseBody is Map && responseBody.containsKey('message')) {
        errorMessage = responseBody['message'];
      }
      return Left(ServerFailure(message: errorMessage));
    }
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Left(ConnectionFailure(message: 'انتهت مهلة الاتصال بالخادم.'));
      case DioExceptionType.badResponse:
        return Left(ServerFailure(message: 'استجابة غير صالحة من الخادم.'));
      case DioExceptionType.cancel:
        return Left(UnexpectedFailure(message: 'تم إلغاء الطلب.'));
      default:
        return Left(ConnectionFailure(message: 'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.'));
    }
  } catch (e) {
    log('Unexpected Error: $e');
    return Left(UnexpectedFailure(message: 'حدث خطأ غير متوقع في التطبيق.'));
  }
}



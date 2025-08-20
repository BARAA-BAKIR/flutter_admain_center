import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
    final int? statusCode; // <-- تأكد من وجود هذه الخاصية

  const ServerFailure({required String message, this.statusCode}) : super(message: message);

  
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

// ==================== هنا هو الإصلاح ====================
// أضف هذا الكلاس الجديد ليمثل أخطاء تحليل البيانات
class ParsingFailure extends Failure {
  final String? details; // يمكن إضافة تفاصيل إضافية للمطور
  const ParsingFailure({required super.message, this.details});

  @override
  List<Object> get props => [message, if (details != null) details!];
}
// =======================================================

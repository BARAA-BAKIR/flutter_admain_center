// part of 'reports_bloc.dart';

// enum ReportGenerationStatus { initial, loading, success, failure }

// class ReportsState extends Equatable {
//   final ReportGenerationStatus status;
//   final String? message; // يمكن استخدامه لعرض رسائل النجاح أو الفشل

//   const ReportsState({
//     this.status = ReportGenerationStatus.initial,
//     this.message,
//   });

//   ReportsState copyWith({
//     ReportGenerationStatus? status,
//     String? message,
//   }) {
//     return ReportsState(
//       status: status ?? this.status,
//       message: message, // لا تستخدم '??' هنا للسماح بإعادة التعيين إلى null
//     );
//   }

//   @override
//   List<Object?> get props => [status, message];
// }
part of 'reports_bloc.dart';

enum ReportGenerationStatus { initial, loading, success, failure }

class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportGenerationStatus.initial,
    this.message,
  });

  final ReportGenerationStatus status;
  final String? message;

  ReportsState copyWith({
    ReportGenerationStatus? status,
    String? message,
  }) {
    return ReportsState(
      status: status ?? this.status,
      message: message, // لا نستخدم ?? this.message لإعادة تعيين الرسالة
    );
  }

  @override
  List<Object?> get props => [status, message];
}

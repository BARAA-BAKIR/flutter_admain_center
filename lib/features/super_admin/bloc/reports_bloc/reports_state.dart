// // In features/super_admin/bloc/reports_bloc/reports_state.dart

// part of 'reports_bloc.dart';

// enum ReportStatus { initial, loading, success, failure }

// class ReportsState extends Equatable {
//   final ReportStatus status;
//   final List<Map<String, dynamic>> reportData;
//   final String? errorMessage;
//   final String? loadingMessage;
//   final String? reportTitle; // --- ✅✅ إضافة عنوان التقرير ✅✅ ---
//   final List<Map<String, dynamic>> centers; // To hold centers for the filter

//   const ReportsState({
//     this.status = ReportStatus.initial,
//     this.reportData = const [],
//     this.errorMessage,
//     this.loadingMessage,
//     this.reportTitle, // --- ✅✅ إضافة عنوان التقرير ✅✅ ---
//     this.centers = const [],
//   });

//   ReportsState copyWith({
//     ReportStatus? status,
//     List<Map<String, dynamic>>? reportData,
//     String? errorMessage,
//     String? loadingMessage,
//     String? reportTitle, // --- ✅✅ إضافة عنوان التقرير ✅✅ ---
//     List<Map<String, dynamic>>? centers,
//   }) {
//     return ReportsState(
//       status: status ?? this.status,
//       reportData: reportData ?? this.reportData,
//       errorMessage: errorMessage ?? this.errorMessage,
//       loadingMessage: loadingMessage ?? this.loadingMessage,
//       reportTitle: reportTitle ?? this.reportTitle, // --- ✅✅ إضافة عنوان التقرير ✅✅ ---
//       centers: centers ?? this.centers,
//     );
//   }

//   @override
//   List<Object?> get props => [status, reportData, errorMessage, loadingMessage, reportTitle, centers];
// }
// في ملف reports_state.dart
// ===== ملف reports_state.dart =====

 part of 'reports_bloc.dart';

enum ReportStatus { initial, loading, success, failure }

class ReportsState extends Equatable {
  final ReportStatus status;
  final List<Map<String, dynamic>> reportData;
  final String? errorMessage;
  final String? loadingMessage;
  final String? reportTitle;
  final List<Map<String, dynamic>> centers;

  const ReportsState({
    this.status = ReportStatus.initial,
    this.reportData = const [],
    this.errorMessage,
    this.loadingMessage,
    this.reportTitle,
    this.centers = const [],
  });

  ReportsState copyWith({
    ReportStatus? status,
    List<Map<String, dynamic>>? reportData,
    String? errorMessage,
    String? loadingMessage,
    String? reportTitle,
    List<Map<String, dynamic>>? centers,
  }) {
    return ReportsState(
      status: status ?? this.status,
      reportData: reportData ?? this.reportData,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      reportTitle: reportTitle ?? this.reportTitle,
      centers: centers ?? this.centers,
    );
  }

  @override
  List<Object?> get props => [status, reportData, errorMessage, loadingMessage, reportTitle, centers];
}
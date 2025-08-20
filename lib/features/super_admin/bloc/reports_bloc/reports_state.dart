// features/super_admin/bloc/reports_bloc/reports_state.dart
part of 'reports_bloc.dart';

enum ReportStatus { initial, loading, success, failure }

class ReportsState extends Equatable {
  final ReportStatus status;
  final List<Map<String, dynamic>> reportData;
  final List<Map<String, dynamic>> centers; // For the filter dropdown
  final String? errorMessage;
  final String? loadingMessage;

  const ReportsState({
    this.status = ReportStatus.initial,
    this.reportData = const [],
    this.centers = const [],
    this.errorMessage,
    this.loadingMessage,
  });

  ReportsState copyWith({
    ReportStatus? status,
    List<Map<String, dynamic>>? reportData,
    List<Map<String, dynamic>>? centers,
    String? errorMessage,
    String? loadingMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      reportData: reportData ?? this.reportData,
      centers: centers ?? this.centers,
      errorMessage: errorMessage,
      loadingMessage: loadingMessage,
    );
  }

  @override
  List<Object?> get props => [status, reportData, centers, errorMessage, loadingMessage];
}

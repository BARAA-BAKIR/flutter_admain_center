// features/super_admin/bloc/dashboard_bloc/dashboard_state.dart
part of 'dashboard_bloc.dart';

// Enum to represent the different states of the screen
enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final Map<String, dynamic> globalStats;
  final List<Map<String, dynamic>> topCenters;
  final List<Map<String, dynamic>> performanceChartData;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.globalStats = const {},
    this.topCenters = const [],
    this.performanceChartData = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    Map<String, dynamic>? globalStats,
    List<Map<String, dynamic>>? topCenters,
    List<Map<String, dynamic>>? performanceChartData,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      globalStats: globalStats ?? this.globalStats,
      topCenters: topCenters ?? this.topCenters,
      performanceChartData: performanceChartData ?? this.performanceChartData,
      errorMessage: errorMessage, // Allow setting it to null
    );
  }

  @override
  List<Object?> get props => [status, globalStats, topCenters, performanceChartData, errorMessage];
}

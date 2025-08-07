part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }
enum SyncStatus { initial, syncing, success, failure }

class DashboardState {
  final DashboardStatus status;
  final SyncStatus syncStatus;
  final DashboardModel? dashboardData;
  final String? error;
  final String? syncError;

  DashboardState({
    this.status = DashboardStatus.initial,
    this.syncStatus = SyncStatus.initial,
    this.dashboardData,
    this.error,
    this.syncError,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    SyncStatus? syncStatus,
    DashboardModel? dashboardData,
    String? error,
    String? syncError,
  }) {
    return DashboardState(
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      dashboardData: dashboardData ?? this.dashboardData,
      error: error ?? this.error,
      syncError: syncError ?? this.syncError,
    );
  }
}

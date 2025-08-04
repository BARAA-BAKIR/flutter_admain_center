part of 'dashboard_bloc.dart';

enum SyncStatus { initial, syncing, success, failure }

class DashboardState {
  // ... (يمكن إضافة متغيرات أخرى للإحصائيات لاحقاً)
  final SyncStatus syncStatus;
  final String? syncError;

  const DashboardState({
    this.syncStatus = SyncStatus.initial,
    this.syncError,
  });

  DashboardState copyWith({
    SyncStatus? syncStatus,
    String? syncError,
  }) {
    return DashboardState(
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError, // لا نستخدم ?? هنا لإمكانية مسح الخطأ
    );
  }
}

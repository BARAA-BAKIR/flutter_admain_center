part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class LoadDashboardData extends DashboardEvent {
  final int halaqaId;
  LoadDashboardData({required this.halaqaId});
}

class SyncAllDataRequested extends DashboardEvent {}

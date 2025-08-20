// features/super_admin/bloc/dashboard_bloc/dashboard_event.dart
part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all dashboard data from the repository
class FetchSuperAdminDashboard extends DashboardEvent {}

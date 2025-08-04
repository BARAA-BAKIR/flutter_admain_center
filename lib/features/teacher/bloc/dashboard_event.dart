part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

// حدث لجلب بيانات لوحة التحكم (يمكن تطويره لاحقاً)
class FetchDashboardStats extends DashboardEvent {}

// حدث لطلب المزامنة الجماعية
class SyncAllDataRequested extends DashboardEvent {}

// // // features/super_admin/view/super_admin_dashboard_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/info_card.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/dashboard_bloc/dashboard_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/widgets/centers_performance_chart.dart';
// import 'package:flutter_admain_center/features/super_admin/widgets/top_performing_centers_list.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SuperAdminDashboardScreen extends StatelessWidget {
//   const SuperAdminDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Provide the BLoC to the widget tree
//     return BlocProvider(
//       create: (context) => DashboardBloc(
//         superAdminRepository: context.read<SuperAdminRepository>(),
//       )..add(FetchSuperAdminDashboard()), // Fetch data immediately
//       child: const SuperAdminDashboardView(),
//     );
//   }
// }

// class SuperAdminDashboardView extends StatelessWidget {
//   const SuperAdminDashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text('اللوحة الرئيسية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.grey.shade100,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: BlocBuilder<DashboardBloc, DashboardState>(
//         builder: (context, state) {
//           // Handle loading state
//           if (state.status == DashboardStatus.loading || state.status == DashboardStatus.initial) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           // Handle failure state
//           if (state.status == DashboardStatus.failure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('فشل تحميل البيانات: ${state.errorMessage ?? "خطأ غير معروف"}'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => context.read<DashboardBloc>().add(FetchSuperAdminDashboard()),
//                     child: const Text('إعادة المحاولة'),
//                   )
//                 ],
//               ),
//             );
//           }
//           // Handle success state
//           return RefreshIndicator(
//             onRefresh: () async {
//               context.read<DashboardBloc>().add(FetchSuperAdminDashboard());
//             },
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 Text('نظرة شاملة على جميع المراكز', style: GoogleFonts.tajawal(fontSize: 24, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 24),
//                 // Global Stats Cards
//                 GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     InfoCard(title: 'إجمالي المراكز', value: state.globalStats['centers']?.toString() ?? '0', icon: Icons.business_rounded, color: Colors.teal),
//                     InfoCard(title: 'إجمالي الطلاب', value: state.globalStats['students']?.toString() ?? '0', icon: Icons.groups_2_rounded, color: Colors.blue),
//                     InfoCard(title: 'إجمالي الأساتذة', value: state.globalStats['teachers']?.toString() ?? '0', icon: Icons.school_rounded, color: Colors.orange),
//                     InfoCard(title: 'طلبات معلقة', value: state.globalStats['pending_requests']?.toString() ?? '0', icon: Icons.pending_actions_rounded, color: Colors.red),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 // Performance Chart Widget
//                 CentersPerformanceChart(chartData: state.performanceChartData),
//                 const SizedBox(height: 24),
//                 // Top Centers List Widget
//                 TopPerformingCentersList(centers: state.topCenters),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/info_card.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/centers_performance_chart.dart';
import 'package:flutter_admain_center/features/super_admin/widgets/top_performing_centers_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => DashboardBloc(
            superAdminRepository: context.read<SuperAdminRepository>(),
          )..add(FetchSuperAdminDashboard()),
      child: const SuperAdminDashboardView(),
    );
  }
}

class SuperAdminDashboardView extends StatelessWidget {
  const SuperAdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'اللوحة الرئيسية',
          
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Text(
                'فشل تحميل البيانات: ${state.errorMessage ?? "خطأ غير معروف"}',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh:
                () async => context.read<DashboardBloc>().add(
                  FetchSuperAdminDashboard(),
                ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'نظرة شاملة على جميع المراكز',
                  style: GoogleFonts.tajawal(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                   
                    InfoCard(
                      title: 'إجمالي المراكز',
                      value: state.globalStats['centers']?.toString() ?? '0',
                      icon: Icons.business_rounded,
                      color: Colors.teal,
                    ),
                    InfoCard(
                      title: 'إجمالي الطلاب',
                      value: state.globalStats['students']?.toString() ?? '0',
                      icon: Icons.groups_2_rounded,
                      color: Colors.blue,
                    ),
                    InfoCard(
                      title: 'إجمالي الأساتذة',
                      value: state.globalStats['teachers']?.toString() ?? '0',
                      icon: Icons.school_rounded,
                      color: Colors.orange,
                    ),
                    InfoCard(
                      title: 'طلبات معلقة',
                      value:
                          state.globalStats['pending_requests']?.toString() ??
                          '0',
                      icon: Icons.pending_actions_rounded,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // ✅ تمرير البيانات الصحيحة للويدجت
                CentersPerformanceChart(chartData: state.performanceChartData),
                const SizedBox(height: 24),
                // ✅ تمرير البيانات الصحيحة للويدجت
                TopPerformingCentersList(centers: state.topCenters),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/centers_bloc/centers_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/dashboard_bloc/dashboard_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/parts_bloc/parts_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/progress_stages_bloc/progress_stages_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/roles_permissions_bloc/roles_permissions_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/view/aggregated_reports_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/all_staff_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/management_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/roles_permissions_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/settings_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/super_admin_dashboard_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SuperAdminMainScreen extends StatelessWidget {
//   const SuperAdminMainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ====================  هنا هو الإصلاح الكامل والنهائي ====================
//     // توفير كل البلوكات التي تحتاجها واجهة المدير العام وأبناؤها
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<DashboardBloc>(
//           create:
//               (context) => DashboardBloc(
//                 superAdminRepository: context.read<SuperAdminRepository>(),
//               )..add(FetchSuperAdminDashboard()),
//         ),
//         BlocProvider<CentersBloc>(
//           create:
//               (context) =>
//                   CentersBloc(repository: context.read<SuperAdminRepository>()),
//         ),
//         BlocProvider<TeacherManagementBloc>(
//           create:
//               (context) => TeacherManagementBloc(
//                 repository: context.read<SuperAdminRepository>(),
//               ),
//         ),
//         BlocProvider<RolesPermissionsBloc>(
//           create:
//               (context) => RolesPermissionsBloc(
//                 repository: context.read<SuperAdminRepository>(),
//               ),
//         ),
//         // توفير بلوكات الثوابت هنا لتكون متاحة عند الحاجة
//         BlocProvider<HalaqaTypesBloc>(
//           create:
//               (context) => HalaqaTypesBloc(
//                 repository: context.read<SuperAdminRepository>(),
//               )..add(LoadHalaqaTypes()),
//         ),
//         BlocProvider<ProgressStagesBloc>(
//           create:
//               (context) => ProgressStagesBloc(
//                 repository: context.read<SuperAdminRepository>(),
//               )..add(LoadProgressStages()),
//         ),
//         BlocProvider<PartsBloc>(
//           create:
//               (context) =>
//                   PartsBloc(repository: context.read<SuperAdminRepository>())
//                     ..add(LoadParts()),
//         ),
//       ],
//       child: const SuperAdminMainView(),
//     );
//     // =====================================================================
//   }
// }

// // الويدجت التي تبني الواجهة الفعلية
// class SuperAdminMainView extends StatefulWidget {
//   const SuperAdminMainView({super.key});
//   @override
//   State<SuperAdminMainView> createState() => _SuperAdminMainViewState();
// }

// class _SuperAdminMainViewState extends State<SuperAdminMainView> {
//   int _selectedIndex = 0;

//   // تم إضافة شاشة الأدوار والصلاحيات إلى القائمة
//   static final List<Widget> _widgetOptions = <Widget>[
//     const SuperAdminDashboardScreen(),
//     ManagementScreen(),
//     const AllStaffScreen(),
//     const RolesPermissionsScreen(), // <-- شاشة جديدة
//     const AggregatedReportsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset(
//           'assets/image.png',
//           height: 60,
//           fit: BoxFit.cover,
//           alignment: Alignment.center,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_rounded),
//             onPressed: () {
//               Navigator.of(
//                 context,
//               ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
//             },
//           ),
//         ],
//       ),
//       body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.insights_rounded),
//             label: 'الرئيسية',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business_center_rounded),
//             label: 'المراكز',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.groups_3_rounded),
//             label: 'الكادر',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.admin_panel_settings_rounded),
//             label: 'الأدوار',
//           ), // <-- أيقونة جديدة
//           BottomNavigationBarItem(
//             icon: Icon(Icons.summarize_rounded),
//             label: 'التقارير',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.steel_blue,
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: GoogleFonts.tajawal(),
//       ),
//     );
//   }
// }
// In lib/features/super_admin/view/super_admin_main_screen.dartimport 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/view/aggregated_reports_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/constants_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/management_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/settings_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/staff_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/super_admin_dashboard_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SuperAdminMainScreen extends StatefulWidget {
//   const SuperAdminMainScreen({super.key});

//   @override
//   State<SuperAdminMainScreen> createState() => _SuperAdminMainScreenState();
// }

// class _SuperAdminMainScreenState extends State<SuperAdminMainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     const SuperAdminDashboardScreen(),
//     ManagementScreen(),
//     const StaffScreen(),
//     ConstantsScreen(),
//     const AggregatedReportsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset(
//           'assets/image.png',
//           height: 60,
//           fit: BoxFit.cover,
//           alignment: Alignment.center,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_rounded),
//             onPressed: () {
//               // عندما ننتقل إلى شاشة الإعدادات، يجب أن نوفر لها البلوكات التي تحتاجها
//               // لأنها في مسار جديد.
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => BlocProvider.value(
//                     // نحن نقرأ البلوك من السياق الحالي ونمرره إلى المسار الجديد
//                     value: context.read<NotificationsBloc>(),
//                     child: const SettingsScreen(),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'الرئيسية'),
//           BottomNavigationBarItem(icon: Icon(Icons.business_center_rounded), label: 'المراكز'),
//           BottomNavigationBarItem(icon: Icon(Icons.groups_3_rounded), label: 'الكادر'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings_applications_rounded), label: 'الثوابت'),
//           BottomNavigationBarItem(icon: Icon(Icons.summarize_rounded), label: 'التقارير'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.steel_blue,
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: GoogleFonts.tajawal(),
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/profile_boc/profile_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/aggregated_reports_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/constants_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/management_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/settings_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/staff_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/super_admin_dashboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SuperAdminMainScreen extends StatefulWidget {
  const SuperAdminMainScreen({super.key});

  @override
  State<SuperAdminMainScreen> createState() => _SuperAdminMainScreenState();
}

class _SuperAdminMainScreenState extends State<SuperAdminMainScreen> {
  int _selectedIndex = 0;
  bool _showSettings = false;

  // ✅ 1. قائمة المفاتيح، مفتاح لكل تاب للحفاظ على حالة التنقل

  @override
  Widget build(BuildContext context) {
    // ✅ 2. استخدام WillPopScope للتحكم في زر الرجوع
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // إذا كانت شاشة الإعدادات مفتوحة، قم بإغلاقها بدلاً من الخروج من التطبيق
        if (_showSettings) {
          setState(() {
            _showSettings = false;
          });
          return false; // لا تسمح بالخروج
        }
        // اسمح بالخروج إذا لم تكن الإعدادات مفتوحة
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              _showSettings
                  ? Text(
                    'الإعدادات',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                  : Image.asset(
                    'assets/image.png',
                    height: 60,
                   
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
        
          // ✅ 4. إظهار زر الرجوع فقط في شاشة الإعدادات
          leading:
              _showSettings
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _showSettings = false;
                      });
                    },
                  )
                  : null,
          automaticallyImplyLeading: false,
          actions: [
            // ✅ 5. إخفاء زر الإعدادات عندما تكون شاشة الإعدادات مفتوحة بالفعل
            if (!_showSettings)
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {
                  setState(() {
                    _showSettings = true;
                  });
                },
              ),
          ],
        ),
        // ✅ 6. تغيير الـ body بناءً على متغير _showSettings
        body:
            _showSettings
                ? BlocProvider.value(
                  // تمرير البلوك إلى شاشة الإعدادات
                  value: context.read<ProfileBloc>(),
                  child: const SettingsScreen(),
                )
                : IndexedStack(
                  index: _selectedIndex,
                  children: <Widget>[
                    // ... (التابات الخمسة كما هي)
                    const SuperAdminDashboardScreen(),
                    const ManagementScreen(),
                    const StaffScreen(),
                    const ConstantsScreen(),
                    const AggregatedReportsScreen(),
                  ],
                ),
        // ✅ 7. إخفاء الـ BottomNavigationBar في شاشة الإعدادات
        bottomNavigationBar:
            _showSettings
                ? null
                : BottomNavigationBar(
                  // ... (كود BottomNavigationBar كما هو)
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.insights_rounded),
                      label: 'الرئيسية',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business_center_rounded),
                      label: 'الهيكلية',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.groups_3_rounded),
                      label: 'الكادر',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings_applications_rounded),
                      label: 'الثوابت',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.summarize_rounded),
                      label: 'التقارير',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.steel_blue,
                  unselectedItemColor: Colors.grey.shade600,
                  selectedLabelStyle: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.tajawal(),
                ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {

  //   return Scaffold(
  //   appBar: AppBar(
  //       title: Image.asset(
  //         'assets/image.png',
  //         height: 60,
  //         fit: BoxFit.cover,
  //         alignment: Alignment.center,
  //       ),
  //       // هذا يضمن عدم ظهور زر الرجوع في الشاشة الرئيسية
  //       automaticallyImplyLeading: false,
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.settings_rounded),
  //           onPressed: () {
  //               Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (_) => BlocProvider.value(
  //                     value: context.read<ProfileBloc>(),
  //                   child: const SettingsScreen(),
  //                 ),
  //               ),
  //              );
  //           },
  //         ),
  //       ],
  //     ),
  //     body: IndexedStack(
  //       index: _selectedIndex,
  //       children: <Widget>[
  //         _buildOffstageNavigator(0, const SuperAdminDashboardScreen()),
  //         _buildOffstageNavigator(1, const ManagementScreen()),
  //         _buildOffstageNavigator(2, const StaffScreen()),
  //         _buildOffstageNavigator(3, const ConstantsScreen()),
  //         _buildOffstageNavigator(4, const AggregatedReportsScreen()),
  //       ],
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'الرئيسية'),
  //         BottomNavigationBarItem(icon: Icon(Icons.business_center_rounded), label: 'الهيكلية'),
  //         BottomNavigationBarItem(icon: Icon(Icons.groups_3_rounded), label: 'الكادر'),
  //         BottomNavigationBarItem(icon: Icon(Icons.settings_applications_rounded), label: 'الثوابت'),
  //         BottomNavigationBarItem(icon: Icon(Icons.summarize_rounded), label: 'التقارير'),
  //       ],
  //       currentIndex: _selectedIndex,
  //       onTap: (index) {
  //         setState(() {
  //           _selectedIndex = index;
  //         });
  //       },
  //       type: BottomNavigationBarType.fixed,
  //       selectedItemColor: AppColors.steel_blue,
  //       unselectedItemColor: Colors.grey.shade600,
  //       selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
  //       unselectedLabelStyle: GoogleFonts.tajawal(),
  //     ),
  //   );
  // }

  // ✅ 3. دالة لبناء Navigator لكل تاب
  // Widget _buildOffstageNavigator(int index, Widget initialRoute) {
  //   return Offstage(
  //     offstage: _selectedIndex != index,
  //     child: Navigator(
  //       key: _navigatorKeys[index],
  //       onGenerateRoute: (routeSettings) {
  //         return MaterialPageRoute(builder: (context) => initialRoute);
  //       },
  //     ),
  //   );
  // }
}

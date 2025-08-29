
// // import 'package:flutter/material.dart';
// // import 'package:flutter_admain_center/core/constants/app_colors.dart';
// // import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
// // import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/mosques_bloc/mosques_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/dashboard_screen.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:badges/badges.dart' as badges;
// // import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/center_settings_screen.dart';
// // import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';

// // class CenterMainScreen extends StatelessWidget {
// //   const CenterMainScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     // توفير كل البلوكات التي تحتاجها واجهة مدير المركز هنا
// //     return MultiBlocProvider(
// //       providers: [
// //         BlocProvider(
// //           create: (context) => DashboardBloc(
// //             centerManagerRepository: context.read<CenterManagerRepository>(),
// //           )..add(FetchDashboardSummary()),
// //         ),
// //         BlocProvider(
// //           create: (context) => StudentsBloc(
// //             centerManagerRepository: context.read<CenterManagerRepository>(),
// //           )..add(const FetchStudents()),
// //         ),
// //         BlocProvider(
// //           create: (context) => HalaqasBloc(
// //             centerManagerRepository: context.read<CenterManagerRepository>(),
// //           )..add(const FetchHalaqas()),
// //         ),
// //         BlocProvider(
// //           create: (context) => TeachersBloc(
// //             centerManagerRepository: context.read<CenterManagerRepository>(),
// //           )..add(const FetchTeachers()),
// //         ),
// //         BlocProvider(
// //           create: (context) => MosquesBloc(
// //             repository: context.read<CenterManagerRepository>(),
// //           ),
// //         ),
// //         BlocProvider(
// //           create: (context) => NotificationsBloc(
// //             notificationsRepository: context.read<NotificationsRepository>(),
// //           )..add(FetchUnreadCount()),
// //         ),
// //       ],
// //       child: const CenterMainView(),
// //     );
// //   }
// // }

// // // الويدجت التي تبني الواجهة الفعلية
// // class CenterMainView extends StatefulWidget {
// //   const CenterMainView({super.key});
// //   @override
// //   State<CenterMainView> createState() => _CenterMainViewState();
// // }

// // class _CenterMainViewState extends State<CenterMainView> {
// //   int _selectedIndex = 0;

// //   static const List<Widget> _screens = [
// //     DashboardScreen(),
// //     StudentsScreen(),
// //     StaffScreen(),
// //     ReportsScreen(),
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Image.asset('assets/image.png', height: 60),
// //         actions: [
// //           BlocBuilder<NotificationsBloc, NotificationsState>(
// //             builder: (context, state) {
// //               return IconButton(
// //                 icon: badges.Badge(
// //                   showBadge: state.unreadCount > 0,
// //                   badgeContent: Text(
// //                     state.unreadCount.toString(),
// //                     style: const TextStyle(color: Colors.white, fontSize: 10),
// //                   ),
// //                   child: const Icon(Icons.notifications_rounded),
// //                 ),
// //                 onPressed: () {
// //                   final notificationsBloc = context.read<NotificationsBloc>();
// //                   Navigator.of(context).push(
// //                     MaterialPageRoute(
// //                       builder: (_) => BlocProvider.value(
// //                         value: notificationsBloc,
// //                         child: const NotificationsScreen(),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.settings_rounded),
// //             onPressed: () {
// //               final authBloc = context.read<AuthBloc>();
// //               final notificationsBloc = context.read<NotificationsBloc>();
// //               Navigator.of(context).push(
// //                 MaterialPageRoute(
// //                   builder: (_) => MultiBlocProvider(
// //                     providers: [
// //                       BlocProvider.value(value: authBloc),
// //                       BlocProvider.value(value: notificationsBloc),
// //                     ],
// //                     child: const CenterSettingsScreen(),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       body: IndexedStack(index: _selectedIndex, children: _screens),
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
// //           BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'الطلاب'),
// //           BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'الكادر'),
// //           BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         onTap: _onItemTapped,
// //         backgroundColor: Colors.white,
// //         type: BottomNavigationBarType.fixed,
// //         selectedItemColor: AppColors.steel_blue,
// //         unselectedItemColor: Colors.grey.shade600,
// //         selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
// //         unselectedLabelStyle: GoogleFonts.tajawal(),
// //         elevation: 8.0,
// //       ),
// //     );
// //   }
// // }
// // In lib/features/center_manager/view/center_main_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// // import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
// import 'package:flutter_admain_center/features/center_manager/view/dashboard_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/center_settings_screen.dart';
// import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:badges/badges.dart' as badges;

// // ✅ أصبحت الشاشة الآن StatelessWidget بسيطًا جدًا
// class CenterMainScreen extends StatefulWidget {
//   const CenterMainScreen({super.key});

//   @override
//   State<CenterMainScreen> createState() => _CenterMainScreenState();
// }

// class _CenterMainScreenState extends State<CenterMainScreen> {
//   int _selectedIndex = 0;

//   // لا يوجد أي تغيير هنا
//   static const List<Widget> _screens = [
//     DashboardScreen(),
//     StudentsScreen(),
//     StaffScreen(),
//     ReportsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     // عند النقر، نقوم بتحديث الحالة وجلب البيانات إذا لزم الأمر
//     setState(() {
//       _selectedIndex = index;
//     });
//     // يمكنك إضافة منطق لجلب البيانات هنا إذا أردت
//     // مثال: if (index == 1) context.read<StudentsBloc>().add(FetchStudents());
//   }

//   @override
//   void initState() {
//     super.initState();
//     // جلب البيانات الأولية عند بناء الشاشة لأول مرة
//     context.read<DashboardBloc>().add(FetchDashboardSummary());
//     context.read<NotificationsBloc>().add(FetchUnreadCount());
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ❌ لا يوجد أي MultiBlocProvider هنا
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset('assets/image.png', height: 60),
//         actions: [
//           BlocBuilder<NotificationsBloc, NotificationsState>(
//             builder: (context, state) {
//               return IconButton(
//                 icon: badges.Badge(
//                   showBadge: state.unreadCount > 0,
//                   badgeContent: Text(
//                     state.unreadCount.toString(),
//                     style: const TextStyle(color: Colors.white, fontSize: 10),
//                   ),
//                   child: const Icon(Icons.notifications_rounded),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
//                 },
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings_rounded),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CenterSettingsScreen()));
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(index: _selectedIndex, children: _screens),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
//           BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'الطلاب'),
//           BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'الكادر'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.steel_blue,
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: GoogleFonts.tajawal(),
//         elevation: 8.0,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/center_settings_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

// ✅ الحل: لم نعد بحاجة لـ StatefulWidget هنا
// الشاشة أصبحت StatelessWidget بسيطة
class CenterMainScreen extends StatelessWidget {
  const CenterMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅✅ الحل النهائي: نقوم بطلب البيانات الأولية هنا عند إنشاء البلوكات ✅✅
    // هذا يضمن أن الطلب يحدث في الوقت والمكان الصحيحين.
    context.read<DashboardBloc>().add(FetchDashboardSummary());
    context.read<NotificationsBloc>().add(FetchUnreadCount());

    // نعيد بناء الواجهة الفعلية
    return const CenterMainView();
  }
}

// قمنا بفصل الواجهة الفعلية إلى ويدجت خاصة بها
class CenterMainView extends StatefulWidget {
  const CenterMainView({super.key});

  @override
  State<CenterMainView> createState() => _CenterMainViewState();
}

class _CenterMainViewState extends State<CenterMainView> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    StudentsScreen(),
    StaffScreen(),
    ReportsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ❌❌ قمنا بإزالة initState من هنا بالكامل ❌❌

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/image.png', height: 60),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              return IconButton(
                icon: badges.Badge(
                  showBadge: state.unreadCount > 0,
                  badgeContent: Text(
                    state.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: const Icon(Icons.notifications_rounded),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
           Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    // نحن نقرأ البلوك من السياق الحالي ونمرره إلى المسار الجديد
                    value: context.read<NotificationsBloc>(),
                    child: const CenterSettingsScreen(),
                  ),
                ),
              );
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CenterSettingsScreen()));
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'الطلاب'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'الكادر'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.steel_blue,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.tajawal(),
        elevation: 8.0,
      ),
    );
  }
}

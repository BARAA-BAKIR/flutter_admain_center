import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';

import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// استيراد الشاشات التي سننشئها
import 'dashboard_screen.dart'; 
// import 'students_screen.dart';
// import 'staff_screen.dart';
// import 'reports_screen.dart';

class CenterMainScreen extends StatefulWidget {
  const CenterMainScreen({super.key});

  @override
  State<CenterMainScreen> createState() => _CenterMainScreenState();
}

class _CenterMainScreenState extends State<CenterMainScreen> {
  int _selectedIndex = 0;

  // قائمة الشاشات الرئيسية
    // تحديث قائمة الشاشات
   static final List<Widget> _widgetOptions = <Widget>[
     BlocProvider(
      create: (context) => DashboardBloc(
        centerManagerRepository: context.read<CenterManagerRepository>(),
      )..add(FetchDashboardSummary()), // طلب البيانات فوراً
      child: const DashboardScreen(),
    ),
     // هنا نقوم بتوفير البلوك للشاشةCenterManagerRepository centerManagerRepository
    BlocProvider(
      create: (context) => StudentsBloc(
        centerManagerRepository: context.read<CenterManagerRepository>(),
      )..add(const FetchStudents()), // طلب الدفعة الأولى فوراً
      child: const StudentsScreen(),
    ),
    const StaffScreen(),
    const ReportsScreen(), 
   const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('الواجهة الرئيسية'), // يتغير حسب الشاشة
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: 'الطلاب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: 'الكادر',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'التقارير',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'الإعدادات',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // تصميم شريط التنقل
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
//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _widgetOptions,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_rounded),
//             label: 'مركزي',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.groups_2_rounded),
//             label: 'الطلاب',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school_rounded),
//             label: 'الكادر',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assessment_rounded),
//             label: 'التقارير',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings_rounded),
//             label: 'الإعدادات',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         // --- إعدادات المظهر لشريط التنقل ---
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: AppColors.steel_blue,
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: GoogleFonts.tajawal(),
//         elevation: 8.0,
//       ),
//     );
//   }
// }
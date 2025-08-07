import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/view/aggregated_reports_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/all_staff_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// استيراد الشاشات الجديدة
import 'super_admin_dashboard_screen.dart';
import 'centers_management_screen.dart';

class SuperAdminMainScreen extends StatefulWidget {
  const SuperAdminMainScreen({super.key});

  @override
  State<SuperAdminMainScreen> createState() => _SuperAdminMainScreenState();
}

class _SuperAdminMainScreenState extends State<SuperAdminMainScreen> {
  int _selectedIndex = 0;

  // قائمة شاشات المدير العام
   static const List<Widget> _widgetOptions = <Widget>[
    SuperAdminDashboardScreen(),
    CentersManagementScreen(),
    AllStaffScreen(),
    AggregatedReportsScreen(),
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
            icon: Icon(Icons.insights_rounded),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_rounded),
            label: 'المراكز',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_3_rounded),
            label: 'الكادر العام',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize_rounded),
            label: 'التقارير',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.steel_blue,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.tajawal(),
      ),
    );
  }
}

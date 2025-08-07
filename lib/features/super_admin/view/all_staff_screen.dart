import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// استيراد الأقسام الفرعية التي سننشئها
import 'tabs/all_teachers_tab.dart';
import 'tabs/all_students_tab.dart';

class AllStaffScreen extends StatelessWidget {
  const AllStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text('الكادر العام', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          bottom: TabBar(
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
            labelColor: AppColors.steel_blue,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: AppColors.steel_blue,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'جميع الطلاب'),
              Tab(text: 'جميع الأساتذة'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllStudentsTab(),
            AllTeachersTab(),
          ],
        ),
      ),
    );
  }
}

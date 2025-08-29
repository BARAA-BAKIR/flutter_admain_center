import 'package:flutter/material.dart';

import 'package:flutter_admain_center/features/super_admin/view/tabs/all_students_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/all_teachers_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/center_managers_tab.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إدارة الكادر العام',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          bottom: TabBar(
          
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black87,
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.tajawal(),
             tabs: const [
              Tab(text: 'مدراء المراكز'),
              Tab(text: 'الأساتذة'),
              Tab(text: 'الطلاب'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CenterManagersTab(),
            AllTeachersTab(),
            AllStudentsTabWrapper(),
          ],
        ),
      ),
    );
  }
}

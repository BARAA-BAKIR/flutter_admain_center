import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/halaqa_type_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/parts_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/progress_stage_tab.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstantsScreen extends StatelessWidget {
  const ConstantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدارة الثوابت', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          centerTitle: true,
          bottom: TabBar(
           
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black87,
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.tajawal(),
            tabs: const [
              Tab(text: 'أنواع الحلقات'),
              Tab(text: 'مراحل التقدم'),
              Tab(text: 'الأجزاء الثابتة'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HalaqaTypesTab(),
            ProgressStagesTab(),
            PartsTab(),
          ],
        ),
      ),
    );
  }
}

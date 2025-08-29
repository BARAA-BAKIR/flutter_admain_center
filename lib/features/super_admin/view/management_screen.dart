import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/centers_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/halaqas_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/mosques_tab.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ الحل: استخدام DefaultTabController داخل Scaffold جديد
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدارة الهيكلية', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.f_light_gray,
          foregroundColor: Colors.black,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.tajawal(),
            tabs: const [
              Tab(text: 'المراكز'),
              Tab(text: 'المساجد'),
              Tab(text: 'الحلقات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CentersTab(),
            MosquesTab(),
            HalaqasTab(),
          ],
        ),
      ),
    );
  }
}

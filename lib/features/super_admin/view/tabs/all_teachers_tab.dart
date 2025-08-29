import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/super_admin/view/approved_teachers_list.dart';
import 'package:flutter_admain_center/features/super_admin/view/pending_teachers_list.dart';

class AllTeachersTab extends StatelessWidget {
  const AllTeachersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.f_light_gray,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'الأساتذة الموافق عليهم'),
                Tab(text: 'طلبات التسجيل'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ApprovedTeachersList(),
                  PendingTeachersList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

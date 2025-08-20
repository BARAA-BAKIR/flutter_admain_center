import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/all_students_tab.dart';
import 'package:flutter_admain_center/features/super_admin/view/tabs/all_teachers_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AllStaffScreen extends StatelessWidget {
  const AllStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // توفير البلوكات اللازمة لهذه الشاشة وأبنائها
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TeacherManagementBloc(
            repository: context.read<SuperAdminRepository>(),
          ),
        ),
        // يمكنك إضافة بلوك الطلاب هنا لاحقاً
        // BlocProvider(create: (context) => AllStudentsBloc(...)),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('الكادر العام', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.school_outlined), text: 'الأساتذة'),
                Tab(icon: Icon(Icons.groups_outlined), text: 'الطلاب'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AllTeachersTab(), // واجهة إدارة الأساتذة
              AllStudentsTabWrapper(), // واجهة إدارة الطلاب
            ],
          ),
        ),
      ),
    );
  }
}

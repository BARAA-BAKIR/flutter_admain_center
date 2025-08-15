import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/settings_screen.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'dashboard_screen.dart';

class CenterMainScreen extends StatefulWidget {
  const CenterMainScreen({super.key});

  @override
  State<CenterMainScreen> createState() => _CenterMainScreenState();
}

class _CenterMainScreenState extends State<CenterMainScreen> {
  int _selectedIndex = 0;

  //  قائمة الشاشات أصبحت بسيطة جداً
  static const List<Widget> _screens = <Widget>[
    DashboardScreen(),
    StudentsScreen(),
    StaffScreen(), //  شاشة الكادر الآن لا تحتاج لتوفير بلوكات
    ReportsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ==================== هنا هو الإصلاح الكامل والنهائي ====================
    //  توفير كل البلوكات اللازمة هنا في المستوى الأعلى
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          )..add(FetchDashboardSummary()),
        ),
        BlocProvider(
          create: (context) => StudentsBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          )..add(const FetchStudents()),
        ),
        BlocProvider(
          create: (context) => HalaqasBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          )..add(const FetchHalaqas()),
        ),
        BlocProvider(
          create: (context) => TeachersBloc(
            centerManagerRepository: context.read<CenterManagerRepository>(),
          )..add(const FetchTeachers()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/image.png', height: 60),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.group_rounded), label: 'الطلاب'),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'الكادر'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'الإعدادات'),
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
      ),
    );
    // ====================================================================
  }
}

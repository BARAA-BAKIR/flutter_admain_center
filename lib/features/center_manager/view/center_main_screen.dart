import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/center_settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

// ... (باقي استيراداتك)
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/students_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/staff_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/reports_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/notifications_screen.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class CenterMainScreen extends StatelessWidget {
  const CenterMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ==================== هنا هو الإصلاح الكامل والنهائي ====================
    // 1. قم بتوفير كل البلوكات اللازمة لواجهة مدير المركز هنا
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => DashboardBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(FetchDashboardSummary()),
        ),
        BlocProvider(
          create:
              (context) => StudentsBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(const FetchStudents()),
        ),
        BlocProvider(
          create:
              (context) => HalaqasBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(const FetchHalaqas()),
        ),
        BlocProvider(
          create:
              (context) => TeachersBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(const FetchTeachers()),
        ),
        BlocProvider(
          create:
              (context) => NotificationsBloc(
                notificationsRepository:
                    context.read<NotificationsRepository>(),
              )..add(FetchUnreadCount()),
        ),
      ],
      // 2. استخدم ويدجت منفصلة لبناء الواجهة
      child: const CenterMainView(),
    );
  }
}

// 3. ويدجت جديدة ومستقلة لبناء الواجهة الفعلية
class CenterMainView extends StatefulWidget {
  const CenterMainView({super.key});

  @override
  State<CenterMainView> createState() => _CenterMainViewState();
}

class _CenterMainViewState extends State<CenterMainView> {
  int _selectedIndex = 0;

  // قائمة الشاشات
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

  @override
  Widget build(BuildContext context) {
    // الآن، هذا الـ context هو ابن لـ MultiBlocProvider ويمكنه الوصول لكل البلوكات
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/image.png', height: 60),
        actions: [
          // أيقونة الإشعارات
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
                  final notificationsBloc = context.read<NotificationsBloc>();

                  // 2. انتقل إلى الشاشة الجديدة مع توفير البلوك لها باستخدام BlocProvider.value
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: notificationsBloc,
                            child: const NotificationsScreen(),
                          ),
                    ),
                  );
                },
              );
            },
          ),

          // أيقونة الإعدادات
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // ==================== هنا هو الإصلاح الكامل والنهائي ====================
              // 1. احصل على البلوكات التي تحتاجها الشاشة التالية
              final authBloc = context.read<AuthBloc>();
              final notificationsBloc = context.read<NotificationsBloc>();

              // 2. انتقل إلى الشاشة الجديدة مع توفير البلوكات لها باستخدام MultiBlocProvider
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: authBloc),
                          BlocProvider.value(value: notificationsBloc),
                        ],
                        child: const CenterSettingsScreen(),
                      ),
                ),
              );
              // ====================================================================
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
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

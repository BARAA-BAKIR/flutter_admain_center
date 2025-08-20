// في lib/features/teacher/view/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart'; // <-- استيراد AuthBloc
import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_info_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _screens = [
    DashboardScreen(),
    HalaqaScreen(),
    HalaqaInfoScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<HalaqaBloc>().state.halaqa == null) {
        context.read<HalaqaBloc>().add(FetchHalaqaData());
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 // في lib/features/teacher/view/main_screen.dart

@override
Widget build(BuildContext context) {
  return BlocBuilder<HalaqaBloc, HalaqaState>(
    builder: (context, state) {
      // الحالة 1: التحميل الأولي
      if (state.isLoading && state.halaqa == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // ==================== هنا هو الإصلاح الكامل والنهائي ====================
      // الحالة 2: فشل التحميل الأولي (لأي سبب كان)
      if (state.error != null && state.halaqa == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('خطأ'),
            automaticallyImplyLeading: false, // إخفاء سهم الرجوع
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
                  const SizedBox(height: 24),
                  Text(
                    'فشل تحميل البيانات',
                    style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.error!, // عرض رسالة الخطأ الفعلية
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر إعادة المحاولة
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                        onPressed: () {
                          context.read<HalaqaBloc>().add(FetchHalaqaData());
                        },
                      ),
                      const SizedBox(width: 16),
                      // زر تسجيل الخروج
                      TextButton.icon(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          context.read<AuthBloc>().add(LoggedOut());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      // ====================================================================

      // الحالة 3: الأستاذ ليس لديه حلقة (بعد نجاح الاتصال بالـ API)
      if (state.noHalaqaAssigned) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('مرحباً بك'),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 80, color: Colors.blueGrey),
                  const SizedBox(height: 24),
                  Text(
                    'لم يتم تعيين حلقة لك بعد',
                    style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'يرجى مراجعة إدارة المركز لتسليمك إحدى الحلقات.',
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('تسجيل الخروج'),
                    onPressed: () {
                      context.read<AuthBloc>().add(LoggedOut());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }

      // الحالة 4: النجاح (يوجد حلقة)
      return Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    },
  );
}

  // ====================================================================

  // ... (باقي دوال الـ build تبقى كما هي)
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
        if (halaqaId != null) {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => AddStudentBloc(
                  teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
                )..add(FetchLevels()),
                child: AddStudentScreen(halaqaId: halaqaId),
              ),
            ),
          );
          if (result == true && mounted) {
            context.read<HalaqaBloc>().add(FetchHalaqaData());
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا يمكن إضافة طالب، لم يتم تحميل بيانات الحلقة بعد.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      backgroundColor: AppColors.golden_orange,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.dashboard_outlined, label: 'التحكم', index: 0),
            _buildNavItem(icon: Icons.group, label: 'حلقتي', index: 1),
            const SizedBox(width: 40),
            _buildNavItem(icon: Icons.info_outline, label: 'البيانات', index: 2),
            _buildNavItem(icon: Icons.settings_outlined, label: 'الإعدادات', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isActive = _selectedIndex == index;
    final color = isActive ? AppColors.steel_blue : Colors.grey.shade600;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.tajawal(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

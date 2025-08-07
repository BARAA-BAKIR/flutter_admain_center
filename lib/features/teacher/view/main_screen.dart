import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

import 'package:flutter_admain_center/features/teacher/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_info_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const DashboardScreen(),
    HalaqaScreen(),
    const HalaqaInfoScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // =================================================================
    // --- هذا هو الإصلاح ---
    // لم نعد بحاجة لـ BlocProvider هنا على الإطلاق.
    // الـ Bloc تم توفيره في main.dart.
    // =================================================================
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    // نستخدم BlocBuilder للوصول إلى HalaqaBloc الذي تم توفيره في main.dart
    return BlocBuilder<HalaqaBloc, HalaqaState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            final halaqaId = state.halaqa?.idhalaqa;
            if (halaqaId != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (context) => AddStudentBloc(
                              teacherRepository:
                                  RepositoryProvider.of<TeacherRepository>(
                                    context,
                                  ),
                            )..add(FetchLevels()),
                        child: AddStudentScreen(halaqaId: halaqaId),
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'لا يمكن إضافة طالب، لم يتم تحميل بيانات الحلقة بعد.',
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              );
            }
          },
          backgroundColor: AppColors.golden_orange,
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
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
            _buildNavItem(
              icon: Icons.dashboard_outlined,
              label: 'التحكم',
              index: 0,
            ),
            _buildNavItem(icon: Icons.group, label: 'حلقتي', index: 1),
            const SizedBox(width: 40),
            _buildNavItem(
              icon: Icons.info_outline,
              label: 'البيانات',
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.settings_outlined,
              label: 'الإعدادات',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
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

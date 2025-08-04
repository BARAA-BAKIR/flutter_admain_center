// lib/features/teacher/view/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/add_student_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// استيراد الشاشات الأربع التي أنشأناها
import 'package:flutter_admain_center/features/teacher/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_info_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/add_student_screen.dart';

class MainScreen extends StatefulWidget {
  //final TeacherRepository teacherRepository;
  const MainScreen({super.key, required teacherRepository});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // متغير لتتبع الشاشة النشطة حالياً
  int _selectedIndex = 1; // سنبدأ بشاشة "حلقتي"

  // قائمة الشاشات التي سيعرضها الشريط السفلي
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      const DashboardScreen(),
      HalaqaScreen(),
      const HalaqaInfoScreen(),
      const SettingsScreen(),
    ];
  }

  // دالة لتغيير الشاشة عند الضغط على زر
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // عرض الشاشة المحددة من القائمة
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // --- هذا هو الشريط السفلي المعدل والديناميكي ---
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- زر الإضافة الآن جزء من الشاشة الرئيسية ---
 Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;

        if (halaqaId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              // --- هذا هو الإصلاح الكامل ---
              builder: (_) => BlocProvider(
                create: (context) => AddStudentBloc(
                  // حقن الـ Repository
                 teacherRepository:  context.read<TeacherRepository>(),
                )..add(FetchLevels()), // استدعاء FetchLevels فور إنشاء الـ Bloc
                child: AddStudentScreen(halaqaId: halaqaId),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('لا يمكن إضافة طالب، لم يتم تحميل بيانات الحلقة بعد.'),
            behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  bottom: 50.0, // ارفع الـ SnackBar فوق الزر العائم
                  left: 16.0,
                  right: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
          );
        }
      },
      backgroundColor: AppColors.golden_orange,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }


  // --- هذه هي الدالة التي طلبت تعديلها، الآن أصبحت ديناميكية ---
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
            _buildNavItem(
              icon: Icons.group,
              label: 'حلقتي',
              index: 1,
            ),
            const SizedBox(width: 40), // مساحة للزر العائم
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

  // --- ويدجت بناء زر التنقل، الآن أصبح أكثر ذكاءً ---
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    // تحديد ما إذا كان هذا الزر هو النشط حالياً
    final bool isActive = _selectedIndex == index;
    final color = isActive ? AppColors.steel_blue : Colors.grey.shade600;

    return InkWell(
      // عند الضغط، استدع دالة تغيير الشاشة
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

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
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
  int _selectedIndex = 1; // البدء بشاشة "حلقتي"

  // قائمة الشاشات الفرعية
  static const List<Widget> _screens = [
    DashboardScreen(),
    HalaqaScreen(),
    HalaqaInfoScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // عند بناء هذه الشاشة لأول مرة، نرسل حدث جلب البيانات
    // نستخدم addPostFrameCallback لضمان أن الـ context متاح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // نتحقق إذا كانت البيانات لم تُحمّل بعد لتجنب الطلبات المتكررة
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

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocBuilder لمراقبة حالة HalaqaBloc
    return BlocBuilder<HalaqaBloc, HalaqaState>(
      builder: (context, state) {
        // الحالة 1: التحميل الأولي والبيانات غير متاحة
        if (state.isLoading && state.halaqa == null) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحميل بيانات الحلقة...'),
                ],
              ),
            ),
          );
        }

        // الحالة 2: فشل التحميل الأولي
        if (state.error != null && state.halaqa == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('فشل تحميل البيانات: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HalaqaBloc>().add(FetchHalaqaData()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        // الحالة 3: تم تحميل البيانات بنجاح (أو فشل التحديث مع وجود بيانات قديمة)
        // نعرض الواجهة الرئيسية الكاملة
        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: _screens),
          floatingActionButton: _buildFloatingActionButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // نقرأ الحالة الحالية من البلوك مباشرة
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
          // إذا عادت الشاشة بنتيجة true، قم بتحديث قائمة الطلاب
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

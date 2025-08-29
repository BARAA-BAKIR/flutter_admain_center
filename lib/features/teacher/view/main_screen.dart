
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
// import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
// import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
// import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart';
// import 'package:flutter_admain_center/features/teacher/view/dashboard_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/halaqa_info_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/halaqa_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/no_halaqa_assigned_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // توفير كل البلوكات التي تحتاجها واجهة الأستاذ هنا
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<DashboardBloc>(
//           create: (context) => DashboardBloc(teacherRepository: context.read<TeacherRepository>()),
//         ),
//         BlocProvider<HalaqaBloc>(
//           create: (context) => HalaqaBloc(
//             teacherRepository: context.read<TeacherRepository>(),
//             dashboardBloc: context.read<DashboardBloc>(),
//           ),
//         ),
//         BlocProvider<ProfileBloc>(
//           create: (context) => ProfileBloc(teacherRepository: context.read<TeacherRepository>()),
//         ),
//         BlocProvider<SettingsBloc>(
//           create: (context) => SettingsBloc(authRepository: context.read<AuthRepository>())..add(LoadSettings()),
//         ),
//       ],
//       child: const MainScreenView(),
//     );
//   }
// }

// // الويدجت التي تبني الواجهة الفعلية
// class MainScreenView extends StatefulWidget {
//   const MainScreenView({super.key});
//   @override
//   State<MainScreenView> createState() => _MainScreenViewState();
// }

// class _MainScreenViewState extends State<MainScreenView> {
//   int _selectedIndex = 1;

//   static const List<Widget> _screens = [
//     DashboardScreen(),
//     HalaqaScreen(),
//     HalaqaInfoScreen(),
//     SettingsScreen(), // <-- سنقوم بإزالة هذه من هنا
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<HalaqaBloc>().add(FetchHalaqaData());
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//  @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HalaqaBloc, HalaqaState>(
//       builder: (context, state) {
//         // الحالة 1: جاري التحميل لأول مرة
//         if (state.isLoading && state.halaqa == null) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator(color: AppColors.steel_blue)),
//           );
//         }

//         // الحالة 2: حدث خطأ ولم يتم تحميل الحلقة
//         if (state.error != null && state.halaqa == null) {
//           // يمكنك هنا أيضاً إنشاء شاشة خطأ مخصصة مع زر "إعادة المحاولة"
//           return Scaffold(
//             appBar: AppBar(title: const Text('خطأ')
//                ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(state.error!),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => context.read<HalaqaBloc>().add(FetchHalaqaData()),
//                     child: const Text('إعادة المحاولة'),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }

//         // ====================  هنا هو التعديل الرئيسي ====================
//         // الحالة 3: تم التحميل بنجاح ولكن لا توجد حلقة معينة
//         if (state.noHalaqaAssigned) {
//           // نعرض الشاشة الترحيبية التفاعلية الجديدة
//           return const NoHalaqaAssignedScreen();
//         }
//         // =================================================================

//         // الحالة 4: تم تحميل الحلقة بنجاح، اعرض الواجهة الرئيسية
//         return Scaffold(
//           body: _screens[_selectedIndex],
//           floatingActionButton: _buildFloatingActionButton(context),
//           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           bottomNavigationBar: _buildBottomNavigationBar(),
//         );
//       },
//     );
//   }


//   Widget _buildFloatingActionButton(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () async {
//         final halaqaId = context.read<HalaqaBloc>().state.halaqa?.idhalaqa;
//         if (halaqaId != null) {
//           final result = await Navigator.of(context).push<bool>(
//             MaterialPageRoute(
//               builder:
//                   (_) => BlocProvider(
//                     create:
//                         (context) => AddStudentBloc(
//                           teacherRepository:
//                               RepositoryProvider.of<TeacherRepository>(context),
//                         )..add(FetchLevels()),
//                     child: AddStudentScreen(halaqaId: halaqaId),
//                   ),
//             ),
//           );
//           if (result == true && mounted) {
//             context.read<HalaqaBloc>().add(FetchHalaqaData());
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'لا يمكن إضافة طالب، لم يتم تحميل بيانات الحلقة بعد.',
//               ),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       backgroundColor: AppColors.golden_orange,
//       child: const Icon(Icons.add, color: Colors.white),
//     );
//   }


//   Widget _buildBottomNavigationBar() {
//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8.0,
//       elevation: 10,
//       child: SizedBox(
//         height: 65,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(icon: Icons.dashboard_outlined, label: 'التحكم', index: 0),
//             _buildNavItem(icon: Icons.group, label: 'حلقتي', index: 1),
//             const SizedBox(width: 40),
//             _buildNavItem(icon: Icons.info_outline, label: 'البيانات', index: 2),
//             // ====================  هنا هو الإصلاح الكامل والنهائي ====================
//             // زر الإعدادات الآن لا يغير الـ index، بل ينتقل مباشرة
//             _buildNavItem(
//               icon: Icons.settings_outlined,
//               label: 'الإعدادات',
//               index: 3, // لا يزال يستخدم للتحكم في اللون
//               onTap: () {
//                 final settingsBloc = context.read<SettingsBloc>();
//                 final profileBloc = context.read<ProfileBloc>();
//                 final authBloc = context.read<AuthBloc>();

//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => MultiBlocProvider(
//                       providers: [
//                         BlocProvider.value(value: settingsBloc),
//                         BlocProvider.value(value: profileBloc),
//                         BlocProvider.value(value: authBloc),
//                       ],
//                       child: const SettingsScreen(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             // =====================================================================
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required String label,
//     required int index,
//     VoidCallback? onTap,
//   }) {
//     // ====================  هنا هو الإصلاح الكامل والنهائي ====================
//     // بما أن زر الإعدادات له onTap خاص، فإننا نتحقق من أننا لا نغير الـ index له
//     final bool isActive = _selectedIndex == index && onTap == null;
//     // =====================================================================
//     final color = isActive ? AppColors.steel_blue : Colors.grey.shade600;
//     return InkWell(
//       onTap: onTap ?? () => _onItemTapped(index),
//       borderRadius: BorderRadius.circular(20),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 1),
//             Text(
//               label,
//               style: GoogleFonts.tajawal(
//                 color: color,
//                 fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/view/add_student_screen.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart' as Teacher;
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/dashboard_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_info_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/halaqa_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/no_halaqa_assigned_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ الحل: الشاشة أصبحت الآن مسؤولة عن توفير البلوك الخاص بها
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HalaqaBloc(
        teacherRepository: context.read<TeacherRepository>(),
        // يمكننا قراءة dashboardBloc بأمان هنا لأنه تم توفيره في RoleRouterScreen
        dashboardBloc: context.read<Teacher.DashboardBloc>(),
      )..add(FetchHalaqaData()), // <-- طلب البيانات مباشرة عند الإنشاء
      child: const MainView(),
    );
  }
}

// قمنا بفصل الواجهة الفعلية إلى ويدجت خاصة بها
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 1;

  static const List<Widget> _screens = [
    DashboardScreen(),
    HalaqaScreen(),
    HalaqaInfoScreen(),
    SettingsScreen(),
  ];

  // ❌ لا يوجد initState هنا لطلب البيانات
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // الواجهة الآن تستخدم BlocBuilder كالمعتاد
    return BlocBuilder<HalaqaBloc, HalaqaState>(
      builder: (context, state) {
        if (state.isLoading && state.halaqa == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.error != null && state.halaqa == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('خطأ')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<HalaqaBloc>().add(FetchHalaqaData()),
                    child: const Text('إعادة المحاولة'),
                  )
                ],
              ),
            ),
          );
        }

        if (state.noHalaqaAssigned) {
          return const NoHalaqaAssignedScreen();
        }

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

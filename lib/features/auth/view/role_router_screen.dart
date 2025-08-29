// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

// // استيراد واجهات الأدوار المختلفة
// import 'package:flutter_admain_center/features/teacher/view/main_screen.dart'; // واجهة الأستاذ
// import 'package:flutter_admain_center/features/center_manager/view/center_main_screen.dart'; // واجهة مدير المركز
// import 'package:flutter_admain_center/features/super_admin/view/super_admin_main_screen.dart';

// class RoleRouterScreen extends StatelessWidget {
//   const RoleRouterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // استخدام BlocBuilder للاستماع إلى حالة المصادقة
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is AuthAuthenticated) {
//           // المستخدم مسجل دخوله، الآن تحقق من دوره
//           final user = state.user;

//           // التحقق من الأدوار بالأولوية (من الأعلى إلى الأدنى)
//            if (user.hasRole('مدير عام')) {
//             return const SuperAdminMainScreen();
//           } else if (user.hasRole('مدير مركز')) {
//             return const CenterMainScreen();
//           } else if (user.hasRole('استاذ')) {
//             return const MainScreen();
//           } else {
//             // حالة احتياطية: إذا لم يكن للمستخدم أي دور معروف
//             // أو إذا كان هناك خطأ في الأدوار القادمة من الـ API
//             print("User has no recognized role: ${user.roles}");
//             return const LoginScreen();
//           }

//             // حالة احتياطية: إذا لم يكن للمستخدم أي دور معروف
//             // يمكنك إظهار رسالة خطأ أو إعادته لشاشة الدخول

//         }

//         // إذا لم يكن المستخدم مسجل دخوله، أعده إلى شاشة الدخول
//         // هذا السطر لن يتم الوصول إليه في العادة إذا تم استخدام هذه الشاشة بشكل صحيح
//         return const CircularProgressIndicator(); // أو شاشة الدخول
//       },
//     );
//   }
// }import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/dashboard_bloc/dashboard_bloc.dart'
    as CenterManager;
import 'package:flutter_admain_center/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_bloc.dart';
// ✅ سنستخدم HalaqasBloc من مدير المركز للمدير العام أيضاً
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/mosques_bloc/mosques_bloc.dart';
// ✅ سنستخدم NotificationsBloc من مدير المركز للمدير العام أيضاً
import 'package:flutter_admain_center/features/center_manager/bloc/notifications_bloc/notifications_bloc.dart'
    as CenterManager;
import 'package:flutter_admain_center/features/center_manager/bloc/reports_bloc/reports_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/student_bloc/students_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/add_edit_center_bloc/add_edit_center_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/center_managers_bloc/center_managers_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/centers_bloc/centers_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/dashboard_bloc/dashboard_bloc.dart'
    as SuperAdmin;
import 'package:flutter_admain_center/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/parts_bloc/parts_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/profile_boc/profile_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/progress_stages_bloc/progress_stages_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/roles_permissions_bloc/roles_permissions_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/add_student/add_student_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart'
    as Teacher;
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart'
    as teacher;
import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/teacher/view/main_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/center_main_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/super_admin_main_screen.dart';

class RoleRouterScreen extends StatelessWidget {
  const RoleRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;

    if (state is AuthAuthenticated) {
      final user = state.user;

      if (user.hasRole('مدير عام')) {
        return MultiBlocProvider(
          providers: [
            // ... البلوكات السابقة للمدير العام
              BlocProvider<ProfileBloc>(
              create:
                  (context) => ProfileBloc(
                    profileRepository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<SuperAdmin.DashboardBloc>(
              create:
                  (context) => SuperAdmin.DashboardBloc(
                    superAdminRepository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<CentersBloc>(
              create:
                  (context) => CentersBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<AddEditCenterBloc>(
              create:
                  (context) => AddEditCenterBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<AllStudentsBloc>(
              create:
                  (context) => AllStudentsBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<CenterManagersBloc>(
              create:
                  (context) => CenterManagersBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<TeacherManagementBloc>(
              create:
                  (context) => TeacherManagementBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<RolesPermissionsBloc>(
              create:
                  (context) => RolesPermissionsBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<HalaqaTypesBloc>(
              create:
                  (context) => HalaqaTypesBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<ProgressStagesBloc>(
              create:
                  (context) => ProgressStagesBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),
            BlocProvider<PartsBloc>(
              create:
                  (context) => PartsBloc(
                    repository: context.read<SuperAdminRepository>(),
                  ),
            ),

            // ✅✅ الحل: إضافة البلوكات الناقصة هنا ✅✅
            BlocProvider<CenterManager.NotificationsBloc>(
              create:
                  (context) => CenterManager.NotificationsBloc(
                    notificationsRepository:
                        context.read<NotificationsRepository>(),
                  ),
            ),
            BlocProvider<HalaqasBloc>(
              create:
                  (context) => HalaqasBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
          
          ],
          child: const SuperAdminMainScreen(),
        );
      } else if (user.hasRole('مدير مركز')) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CenterManager.DashboardBloc>(
              create:
                  (context) => CenterManager.DashboardBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<StudentsBloc>(
              create:
                  (context) => StudentsBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<HalaqasBloc>(
              create:
                  (context) => HalaqasBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<TeachersBloc>(
              create:
                  (context) => TeachersBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<MosquesBloc>(
              create:
                  (context) => MosquesBloc(
                    repository: context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<HalaqaDetailsBloc>(
              create:
                  (context) => HalaqaDetailsBloc(
                    repository: context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<ReportsBloc>(
              create:
                  (context) => ReportsBloc(
                    centerManagerRepository:
                        context.read<CenterManagerRepository>(),
                  ),
            ),
            BlocProvider<CenterManager.NotificationsBloc>(
              create:
                  (context) => CenterManager.NotificationsBloc(
                    notificationsRepository:
                        context.read<NotificationsRepository>(),
                  ),
            ),
          ],
          child: const CenterMainScreen(),
        );
      } else if (user.hasRole('استاذ')) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<Teacher.DashboardBloc>(
              create:
                  (context) => Teacher.DashboardBloc(
                    teacherRepository: context.read<TeacherRepository>(),
                  ),
            ),
            BlocProvider<AddStudentBloc>(
              create:
                  (context) => AddStudentBloc(
                    teacherRepository: context.read<TeacherRepository>(),
                  ),
            ),
            BlocProvider<teacher.ProfileBloc>(
              create:
                  (context) => teacher.ProfileBloc(
                    teacherRepository: context.read<TeacherRepository>(),
                  ),
            ),
            BlocProvider<SettingsBloc>(
              create:
                  (context) => SettingsBloc(
                    authRepository: context.read<AuthRepository>(),
                  ),
            ),
          ],
          child: const MainScreen(),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    }
    return const Scaffold(
      body: Center(child: Text('حالة غير معروفة، يرجى إعادة تسجيل الدخول.')),
    );
  }
}

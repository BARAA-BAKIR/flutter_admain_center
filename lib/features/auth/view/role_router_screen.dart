import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';

// استيراد واجهات الأدوار المختلفة
import 'package:flutter_admain_center/features/teacher/view/main_screen.dart'; // واجهة الأستاذ
import 'package:flutter_admain_center/features/center_manager/view/center_main_screen.dart'; // واجهة مدير المركز
import 'package:flutter_admain_center/features/super_admin/view/super_admin_main_screen.dart'; // واجهة المدير العام

class RoleRouterScreen extends StatelessWidget {
  const RoleRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام BlocBuilder للاستماع إلى حالة المصادقة
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // المستخدم مسجل دخوله، الآن تحقق من دوره
          final user = state.user;

          // التحقق من الأدوار بالأولوية (من الأعلى إلى الأدنى)
          if (user.hasRole('مدير عام')) {
            return const SuperAdminMainScreen();
          } 
          else if (user.hasRole('مدير مركز')) {
            return const CenterMainScreen();
          } 
          else if (user.hasRole('استاذ')) {
            return MainScreen(); // هذه واجهة الأستاذ الحالية
          }
          else {
            // حالة احتياطية: إذا لم يكن للمستخدم أي دور معروف
            // يمكنك إظهار رسالة خطأ أو إعادته لشاشة الدخول
            return const Scaffold(
              body: Center(
                child: Text('ليس لديك صلاحيات للوصول إلى هذا التطبيق.'),
              ),
            );
          }
        }
        
        // إذا لم يكن المستخدم مسجل دخوله، أعده إلى شاشة الدخول
        // هذا السطر لن يتم الوصول إليه في العادة إذا تم استخدام هذه الشاشة بشكل صحيح
        return const CircularProgressIndicator(); // أو شاشة الدخول
      },
    );
  }
}

// في lib/features/teacher/view/widgets/no_halaqa_assigned_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart'; // <-- استيراد
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart'; // <-- استيراد
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart'; // <-- استيراد
import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart'; // <-- استيراد
import 'package:flutter_admain_center/features/teacher/view/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NoHalaqaAssignedScreen extends StatelessWidget {
  const NoHalaqaAssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحباً بك', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // زر للوصول إلى الإعدادات
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // ====================  هنا هو الحل الكامل والنهائي ====================
              Navigator.of(context).push(
                MaterialPageRoute(
                  // نستخدم MultiBlocProvider لتوفير كل الـ BLoCs التي تحتاجها شاشة الإعدادات
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      // 1. نوفر AuthBloc الحالي
                      BlocProvider.value(
                        value: context.read<AuthBloc>(),
                      ),
                      // 2. ننشئ SettingsBloc جديدًا
                      BlocProvider(
                        create: (ctx) => SettingsBloc(
                          authRepository: ctx.read<AuthRepository>(),
                        )..add(LoadSettings()),
                      ),
                      // 3. ننشئ ProfileBloc جديدًا
                      BlocProvider(
                        create: (ctx) => ProfileBloc(
                          teacherRepository: ctx.read<TeacherRepository>(),
                        ),
                      ),
                    ],
                    child: const SettingsScreen(),
                  ),
                ),
              );
              // =====================================================================
            },
          ),
        ],
      ),
      body: Center(
        // ... باقي الكود يبقى كما هو بدون تغيير
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 100,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              Text(
                'أهلاً بك يا أستاذ ${user.name}!',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.night_blue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'حسابك فعال وفي انتظار موافقة المدير وتعيين حلقة لك. يمكنك التواصل مع إدارة المركز للمتابعة.',
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              BlocBuilder<HalaqaBloc, HalaqaState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const CircularProgressIndicator(color: AppColors.steel_blue);
                  }
                  return ElevatedButton.icon(
                    onPressed: () {
                      context.read<HalaqaBloc>().add(FetchHalaqaData());
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'التحقق من التعيين',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.steel_blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

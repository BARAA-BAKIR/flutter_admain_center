import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_halaqa_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

// --- استيراد البلوكات والأقسام اللازمة ---
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'tabs/halaqas_tab.dart';
import 'tabs/teachers_tab.dart'; // <-- استيراد قسم الأساتذة الفعلي

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير كل البلوكات اللازمة لهذه الشاشة
    return MultiBlocProvider(
      providers: [
        // --- توفير البلوك الخاص بالحلقات ---
        BlocProvider(
          create:
              (context) => HalaqasBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(const FetchHalaqas()), // طلب بيانات الحلقات فوراً
        ),

        // ==================== هنا هو الإصلاح ====================
        // --- توفير البلوك الخاص بالأساتذة ---
        BlocProvider(
          create:
              (context) => TeachersBloc(
                centerManagerRepository:
                    context.read<CenterManagerRepository>(),
              )..add(const FetchTeachers()), // طلب بيانات الأساتذة فوراً
        ),
        // =======================================================
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              'الكادر التعليمي',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
            bottom: TabBar(
              labelStyle: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
              labelColor: AppColors.steel_blue,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: AppColors.steel_blue,
              indicatorWeight: 3,
              tabs: const [Tab(text: 'الحلقات'), Tab(text: 'الأساتذة')],
            ),
          ),
          body: const TabBarView(
            children: [
              // --- عرض الأقسام الفعلية ---
              HalaqasTab(),
              TeachersTab(), // <-- استبدال الـ Placeholder بالويدجت الحقيقية
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const AddHalaqaScreen()),
              );
              // إذا عادت الشاشة بنتيجة true، قم بتحديث قائمة الحلقات
              if (result == true && context.mounted) {
                context.read<HalaqasBloc>().add(const FetchHalaqas());
              }
            },
            backgroundColor: AppColors.steel_blue,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

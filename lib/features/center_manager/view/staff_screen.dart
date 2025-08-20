import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_halaqa_bloc/add_halaqa_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/add_teacher_bloc/add_teacher_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_halaqa_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_teacher_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/tabs/mosques_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'tabs/halaqas_tab.dart';
import 'tabs/teachers_tab.dart';

//  العودة إلى StatefulWidget لإدارة TabController
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

//  إضافة SingleTickerProviderStateMixin
class _StaffScreenState extends State<StaffScreen> with SingleTickerProviderStateMixin {
  //  تعريف TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    //  تهيئة TabController وإضافة مستمع (listener)
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      //  استدعاء setState() يجبر الواجهة على إعادة بناء الزر العائم
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //  دالة لفتح شاشة إضافة حلقة
  void _navigateToAddHalaqa(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddHalaqaBloc(repository: context.read<CenterManagerRepository>()),
          child: const AddHalaqaScreen(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<HalaqasBloc>().add(const FetchHalaqas());
    }
  }

  //  دالة لفتح شاشة إضافة أستاذ
  void _navigateToAddTeacher(BuildContext context) async {
    final newTeacher = await Navigator.of(context).push<Teacher>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddTeacherBloc(repository: context.read<CenterManagerRepository>()),
          child: const AddTeacherScreen(),
        ),
      ),
    );
    if (newTeacher != null && context.mounted) {
      context.read<TeachersBloc>().add(AddNewTeacherToList(newTeacher));
    }
  }
 Widget? _buildFloatingActionButton() {
    switch (_tabController.index) {
      case 0: // تاب الحلقات
        return FloatingActionButton.extended(
          onPressed: () => _navigateToAddHalaqa(context),
          label: const Text('إضافة حلقة'),
          icon: const Icon(Icons.add_circle_outline),
          backgroundColor: AppColors.teal_blue,
          heroTag: 'add_halaqa_tag',
        );
      case 1: // تاب الأساتذة
        return FloatingActionButton.extended(
          onPressed: () => _navigateToAddTeacher(context),
          label: const Text('إضافة أستاذ'),
          icon: const Icon(Icons.person_add_alt_1),
          backgroundColor: AppColors.teal_blue,
          heroTag: 'add_teacher_tag',
        );
      case 2: // تاب المساجد
        // الزر العائم الخاص بإضافة مسجد موجود داخل MosquesTab نفسه
        // لذلك نعيد null هنا لإخفاء الأزرار الأخرى.
        return null;
      default:
        return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    //  لا يوجد BlocProvider هنا، لأنه موجود في المستوى الأعلى (CenterMainScreen)
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('الكادر التعليمي', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController, //  ربط الـ TabBar بالـ Controller
          labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 16),
          labelColor: AppColors.steel_blue,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: AppColors.steel_blue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'الحلقات'),
            Tab(text: 'الأساتذة'),
          Tab(text: 'المساجد'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, //  ربط الـ TabBarView بالـ Controller
        children: const [
          HalaqasTab(),
          TeachersTab(),
          MosquesTab(),
        ],
      ),
      //  الآن الزر سيتغير بناءً على الـ Tab المحدد
      floatingActionButton:_buildFloatingActionButton(),
      //  _tabController.index == 0
      //     ? FloatingActionButton.extended(
      //         onPressed: () => _navigateToAddHalaqa(context),
      //         label: const Text('إضافة حلقة'),
      //         icon: const Icon(Icons.add_circle_outline),
      //         backgroundColor: AppColors.teal_blue,
      //         heroTag: 'add_halaqa_tag', //  إضافة tag فريد
      //       )
      //     : FloatingActionButton.extended(
      //         onPressed: () => _navigateToAddTeacher(context),
      //         label: const Text('إضافة أستاذ'),
      //         icon: const Icon(Icons.person_add_alt_1),
      //         backgroundColor: AppColors.steel_blue,
      //         heroTag: 'add_teacher_tag', //  إضافة tag فريد
      //       ),
    );
  }
}

// In progress_stages_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/progress_stages_bloc/progress_stages_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// ✅ أصبحت الشاشة الآن StatefulWidget بسيطًا جدًا
class ProgressStagesTab extends StatefulWidget {
  const ProgressStagesTab({super.key});

  @override
  State<ProgressStagesTab> createState() => _ProgressStagesTabState();
}

class _ProgressStagesTabState extends State<ProgressStagesTab> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند بناء الشاشة لأول مرة
    context.read<ProgressStagesBloc>().add(LoadProgressStages());
  }

  @override
  Widget build(BuildContext context) {
    // ❌ لا يوجد أي BlocProvider هنا
    return Scaffold(
      body: BlocBuilder<ProgressStagesBloc, ProgressStagesState>(
        builder: (context, state) {
          if (state is ProgressStagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProgressStagesLoaded) {
            if (state.stages.isEmpty) {
              return const Center(child: Text('لا توجد مراحل تقدم لعرضها.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProgressStagesBloc>().add(LoadProgressStages());
              },
              child: ListView.builder(
                itemCount: state.stages.length,
                itemBuilder: (context, index) {
                  final stage = state.stages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(stage.stageName, style: GoogleFonts.tajawal()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () => _showEditDialog(context, stage),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _showDeleteDialog(context, stage.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is ProgressStagesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('انقر على زر الإضافة لبدء العمل.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_progress',
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.steel_blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ... (دوال _showAddDialog, _showEditDialog, _showDeleteDialog تبقى كما هي)
  
  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('إضافة مرحلة تقدم جديدة', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم المرحلة', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ProgressStagesBloc>().add(AddProgressStage(name: controller.text));
                Navigator.pop(dialogContext);
              }
            },
            child: Text('إضافة', style: GoogleFonts.tajawal()),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, StudentProgressStage stage) {
    final TextEditingController controller = TextEditingController(text: stage.stageName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل مرحلة التقدم', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم المرحلة', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ProgressStagesBloc>().add(UpdateProgressStage(id: stage.id, name: controller.text));
                Navigator.pop(dialogContext);
              }
            },
            child: Text('تعديل', style: GoogleFonts.tajawal()),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف مرحلة التقدم', style: GoogleFonts.tajawal()),
        content: Text('هل أنت متأكد من حذف هذه المرحلة؟', style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              context.read<ProgressStagesBloc>().add(DeleteProgressStage(id: id));
              Navigator.pop(dialogContext);
            },
            child: Text('حذف', style: GoogleFonts.tajawal(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

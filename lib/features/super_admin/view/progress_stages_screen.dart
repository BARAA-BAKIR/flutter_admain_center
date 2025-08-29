// lib/features/super_admin/view/progress_stages_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_progress_stage_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/progress_stages_bloc/progress_stages_bloc.dart';

class ProgressStagesScreen extends StatelessWidget {
  const ProgressStagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مراحل تقدم الطلاب',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ProgressStagesBloc, ProgressStagesState>(
        builder: (context, state) {
          if (state is ProgressStagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProgressStagesLoaded) {
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        stage.stageName,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.steel_blue),
                            onPressed: () => _showEditDialog(context, stage),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, stage.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is ProgressStagesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: GoogleFonts.tajawal(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: GoogleFonts.tajawal(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              'لا توجد مراحل تقدم',
              style: GoogleFonts.tajawal(fontSize: 18),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.steel_blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إضافة مرحلة تقدم جديدة',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'اسم المرحلة',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textAlign: TextAlign.right,
          style: GoogleFonts.tajawal(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.tajawal(),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<ProgressStagesBloc>().add(
                  AddProgressStage(name: nameController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              'إضافة',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, StudentProgressStage stage) {
    final nameController = TextEditingController(text: stage.stageName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تعديل مرحلة التقدم',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'اسم المرحلة',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textAlign: TextAlign.right,
          style: GoogleFonts.tajawal(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.tajawal(),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<ProgressStagesBloc>().add(
                  UpdateProgressStage(id: stage.id, name: nameController.text.trim()),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              'حفظ',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه المرحلة؟',
          style: GoogleFonts.tajawal(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.tajawal(),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ProgressStagesBloc>().add(DeleteProgressStage( id:id));
              Navigator.pop(context);
            },
            child: Text(
              'حذف',
              style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
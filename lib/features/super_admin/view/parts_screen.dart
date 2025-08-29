// lib/features/super_admin/view/parts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/parts_bloc/parts_bloc.dart';

class PartsScreen extends StatelessWidget {
  const PartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الأجزاء الثابتة',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.steel_blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<PartsBloc, PartsState>(
        builder: (context, state) {
          if (state is PartsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PartsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PartsBloc>().add(LoadParts());
              },
              child: ListView.builder(
                itemCount: state.parts.length,
                itemBuilder: (context, index) {
                  final part = state.parts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        part.writing,
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
                            onPressed: () => _showEditDialog(context, part),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, part.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is PartsError) {
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
              'لا توجد أجزاء',
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
    final writingController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إضافة جزء جديد',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: writingController,
          decoration: InputDecoration(
            labelText: 'اسم الجزء',
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
              if (writingController.text.trim().isNotEmpty) {
                context.read<PartsBloc>().add(
                  AddPart(writing: writingController.text.trim()),
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

  void _showEditDialog(BuildContext context, Part part) {
    final writingController = TextEditingController(text: part.writing);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تعديل الجزء',
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: writingController,
          decoration: InputDecoration(
            labelText: 'اسم الجزء',
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
              if (writingController.text.trim().isNotEmpty) {
                context.read<PartsBloc>().add(
                  UpdatePart(id: part.id, writing: writingController.text.trim()),
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
          'هل أنت متأكد من حذف هذا الجزء؟',
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
              context.read<PartsBloc>().add(DeletePart( id:id));
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
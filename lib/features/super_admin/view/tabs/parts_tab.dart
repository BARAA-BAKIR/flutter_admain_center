// In parts_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/part_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/parts_bloc/parts_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// ✅ أصبحت الشاشة الآن StatefulWidget بسيطًا جدًا
class PartsTab extends StatefulWidget {
  const PartsTab({super.key});

  @override
  State<PartsTab> createState() => _PartsTabState();
}

class _PartsTabState extends State<PartsTab> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند بناء الشاشة لأول مرة
    // نفترض أن البلوك تم توفيره في مستوى أعلى (في RoleRouterScreen)
    context.read<PartsBloc>().add(LoadParts());
  }

  @override
  Widget build(BuildContext context) {
    // ❌ لا يوجد أي BlocProvider هنا
    // الواجهة تبنى مباشرة وتستخدم البلوك الموجود في السياق
    return Scaffold(
      body: BlocBuilder<PartsBloc, PartsState>(
        builder: (context, state) {
          if (state is PartsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PartsLoaded) {
            if (state.parts.isEmpty) {
              return const Center(child: Text('لا توجد أجزاء لعرضها.'));
            }
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
                    child: ListTile(
                      title: Text(part.writing, style: GoogleFonts.tajawal()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () => _showEditDialog(context, part),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _showDeleteDialog(context, part.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is PartsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('انقر على زر الإضافة لبدء العمل.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_parts',
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.steel_blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ... (دوال _showAddDialog, _showEditDialog, _showDeleteDialog تبقى كما هي)
  // ولكن تأكد من أنها تستخدم context.read<PartsBloc>() بشكل صحيح
  
  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('إضافة جزء جديد', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم الجزء', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<PartsBloc>().add(AddPart(writing: controller.text));
                Navigator.pop(dialogContext);
              }
            },
            child: Text('إضافة', style: GoogleFonts.tajawal()),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Part part) {
    final TextEditingController controller = TextEditingController(text: part.writing);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل الجزء', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم الجزء', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<PartsBloc>().add(UpdatePart(id: part.id, writing: controller.text));
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
        title: Text('حذف الجزء', style: GoogleFonts.tajawal()),
        content: Text('هل أنت متأكد من حذف هذا الجزء؟', style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              context.read<PartsBloc>().add(DeletePart(id: id));
              Navigator.pop(dialogContext);
            },
            child: Text('حذف', style: GoogleFonts.tajawal(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

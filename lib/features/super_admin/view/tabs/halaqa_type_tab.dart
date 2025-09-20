
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

// ✅ أصبحت الشاشة الآن StatelessWidget بسيطًا جدًا
class HalaqaTypesTab extends StatefulWidget {
  const HalaqaTypesTab({super.key});

  @override
  State<HalaqaTypesTab> createState() => _HalaqaTypesTabState();
}

class _HalaqaTypesTabState extends State<HalaqaTypesTab> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند بناء الشاشة لأول مرة
    // نفترض أن البلوك تم توفيره في مستوى أعلى
    context.read<HalaqaTypesBloc>().add(LoadHalaqaTypes());
  }

  @override
  Widget build(BuildContext context) {
    // ❌ لا يوجد أي BlocProvider هنا
    // الواجهة تبنى مباشرة وتستخدم البلوك الموجود في السياق
    return Scaffold(
      body: BlocBuilder<HalaqaTypesBloc, HalaqaTypesState>(
        builder: (context, state) {
          if (state is HalaqaTypesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HalaqaTypesLoaded) {
            if (state.types.isEmpty) {
              return const Center(child: Text('لا توجد أنواع حلقات لعرضها.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HalaqaTypesBloc>().add(LoadHalaqaTypes());
              },
              child: ListView.builder(
                itemCount: state.types.length,
                itemBuilder: (context, index) {
                  final type = state.types[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(type.name, style: GoogleFonts.tajawal()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () => _showEditDialog(context, type),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _showDeleteDialog(context, type.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is HalaqaTypesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('انقر على زر الإضافة لبدء العمل.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_halaqatype',
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.steel_blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ... (دوال _showAddDialog, _showEditDialog, _showDeleteDialog تبقى كما هي)
  // ولكن تأكد من أنها تستخدم context.read<HalaqaTypesBloc>() بشكل صحيح
  
  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('إضافة نوع حلقة جديد', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم النوع', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // ✅ استخدام context الأصلي الذي يملك البلوك
                context.read<HalaqaTypesBloc>().add(AddHalaqaType(name: controller.text));
                Navigator.pop(dialogContext);
              }
            },
            child: Text('إضافة', style: GoogleFonts.tajawal()),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, HalaqaType type) {
    final TextEditingController controller = TextEditingController(text: type.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تعديل نوع الحلقة', style: GoogleFonts.tajawal()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'اسم النوع', hintStyle: GoogleFonts.tajawal()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<HalaqaTypesBloc>().add(UpdateHalaqaType(id: type.id, name: controller.text));
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
        title: Text('حذف نوع الحلقة', style: GoogleFonts.tajawal()),
        content: Text('هل أنت متأكد من حذف هذا النوع؟', style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          TextButton(
            onPressed: () {
              context.read<HalaqaTypesBloc>().add(DeleteHalaqaType(id: id));
              Navigator.pop(dialogContext);
            },
            child: Text('حذف', style: GoogleFonts.tajawal(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

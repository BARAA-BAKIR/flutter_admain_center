import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class CentersManagementScreen extends StatelessWidget {
  const CentersManagementScreen({super.key});

  // دالة لعرض خيارات المركز
  void _showCenterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.bar_chart_rounded),
              title: Text('عرض الإحصائيات'),
              // onTap: () { /* TODO: Navigate to center details */ },
            ),
            const ListTile(
              leading: Icon(Icons.edit_rounded),
              title: Text('تعديل بيانات المركز'),
              // onTap: () { /* TODO: Navigate to edit center screen */ },
            ),
            const ListTile(
              leading: Icon(Icons.person_pin_rounded),
              title: Text('تغيير المدير المسؤول'),
              // onTap: () { /* TODO: Show change manager dialog */ },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('إدارة المراكز', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 12, // مثال: عدد المراكز
        itemBuilder: (context, index) {
          // استخدام نفس الويدجت المشترك مع تغيير بسيط في المحتوى
          return ListItemTile(
            title: 'المركز رقم ${index + 1}',
            subtitle: 'المدير المسؤول: أ. فلان الفلاني',
            // يمكنك استخدام أيقونة مختلفة هنا
            imageUrl: null, // Placeholder for a different icon
            onMoreTap: () => _showCenterOptions(context),
          );
        },
      ),
      // زر عائم لإضافة مركز جديد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: الانتقال إلى شاشة إضافة مركز جديد
        },
        label: const Text('إضافة مركز'),
        icon: const Icon(Icons.add_business_rounded),
        backgroundColor: AppColors.steel_blue,
      ),
    );
  }
}

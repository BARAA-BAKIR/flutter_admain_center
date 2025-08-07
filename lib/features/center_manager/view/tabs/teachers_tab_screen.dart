import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';

class TeachersTabScreen extends StatefulWidget {
  const TeachersTabScreen({super.key});

  @override
  State<TeachersTabScreen> createState() => _TeachersTabScreenState();
}

class _TeachersTabScreenState extends State<TeachersTabScreen> {
  // دالة لعرض خيارات الأستاذ
  void _showTeacherOptions(BuildContext context, String teacherName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.person_search_rounded),
              title: Text('عرض الملف الشخصي'),
              // onTap: () { /* TODO: Navigate to teacher profile */ },
            ),
            const ListTile(
              leading: Icon(Icons.edit_note_rounded),
              title: Text('تعديل البيانات'),
              // onTap: () { /* TODO: Navigate to edit teacher screen */ },
            ),
            const ListTile(
              leading: Icon(Icons.assignment_ind_rounded),
              title: Text('إسناد حلقة'),
              // onTap: () { /* TODO: Show assign halaqa dialog */ },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // استخدام نفس شريط البحث والفلترة
        SearchAndFilterBar(
          onFilterTap: () { /* TODO: Show teacher filter dialog */ },
          onSearchChanged: (query) { /* TODO: Implement search logic */ },
        ),
        Expanded(
          // TODO: استبدال ListView بـ BlocBuilder لجلب الأساتذة
          child: ListView.builder(
            itemCount: 15, // مثال
            itemBuilder: (context, index) {
              return ListItemTile(
                title: 'الأستاذ ${index + 1}',
                subtitle: 'يشرف على حلقة المهاجرين',
                imageUrl: null, // يمكنك إضافة رابط صورة الأستاذ هنا
                onMoreTap: () => _showTeacherOptions(context, 'الأستاذ ${index + 1}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

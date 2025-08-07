import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';

class AllStudentsTab extends StatefulWidget {
  const AllStudentsTab({super.key});

  @override
  State<AllStudentsTab> createState() => _AllStudentsTabState();
}

class _AllStudentsTabState extends State<AllStudentsTab> {
  // TODO: Add logic for pagination and fetching data

  void _showSuperAdminFilterDialog() {
    // نافذة الفلترة هنا ستكون أكثر تفصيلاً
    // TODO: Implement a more detailed filter dialog
    print("Show Super Admin Student Filter");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط البحث والفلترة
        SearchAndFilterBar(
          onFilterTap: _showSuperAdminFilterDialog,
          onSearchChanged: (query) { /* TODO: Implement search logic */ },
        ),
        // قائمة الطلاب
        Expanded(
          // TODO: Replace with BlocBuilder for real data
          child: ListView.builder(
            itemCount: 100, // مثال
            itemBuilder: (context, index) {
              return ListItemTile(
                title: 'الطالب ${index + 1} من النظام',
                // عرض اسم المركز هنا مهم جداً
                subtitle: 'مركز الشمال - حلقة المهاجرين',
                onMoreTap: () { /* TODO: Show limited options for Super Admin */ },
              );
            },
          ),
        ),
      ],
    );
  }
}

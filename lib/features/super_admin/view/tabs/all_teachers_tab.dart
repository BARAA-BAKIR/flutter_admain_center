import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';

class AllTeachersTab extends StatefulWidget {
  const AllTeachersTab({super.key});

  @override
  State<AllTeachersTab> createState() => _AllTeachersTabState();
}

class _AllTeachersTabState extends State<AllTeachersTab> {
  void _showSuperAdminTeacherFilter() {
    // TODO: Implement filter dialog for teachers (by center, etc.)
    print("Show Super Admin Teacher Filter");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAndFilterBar(
          onFilterTap: _showSuperAdminTeacherFilter,
          onSearchChanged: (query) { /* TODO: Implement search logic */ },
        ),
        Expanded(
          // TODO: Replace with BlocBuilder for real data
          child: ListView.builder(
            itemCount: 50, // مثال
            itemBuilder: (context, index) {
              return ListItemTile(
                title: 'الأستاذ ${index + 1} من النظام',
                subtitle: 'مركز الجنوب - حلقة الأنصار',
                onMoreTap: () { /* TODO: Show limited options for Super Admin */ },
              );
            },
          ),
        ),
      ],
    );
  }
}

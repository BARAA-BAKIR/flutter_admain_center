import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';

class AllTeachersTab extends StatefulWidget {
  const AllTeachersTab({super.key});

  @override
  State<AllTeachersTab> createState() => _AllTeachersTabState();
}

class _AllTeachersTabState extends State<AllTeachersTab> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAndFilterBar(
         
          onSearchChanged: (query) { /* TODO: Implement search logic */ }, hintText: '',
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

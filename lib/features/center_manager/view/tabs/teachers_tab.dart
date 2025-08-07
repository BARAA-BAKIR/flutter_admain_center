import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';

class TeachersTab extends StatefulWidget {
  const TeachersTab({super.key});

  @override
  State<TeachersTab> createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TeachersBloc>().add(FetchMoreTeachers());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeachersBloc, TeachersState>(
      builder: (context, state) {
        switch (state.status) {
          case TeachersStatus.failure:
            return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
          
          case TeachersStatus.success:
            if (state.teachers.isEmpty) {
              return const Center(child: Text('لا يوجد أساتذة لعرضهم.'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.teachers.length : state.teachers.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.teachers.length) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                final teacher = state.teachers[index];
                return ListItemTile(
                  title: teacher.fullName,
                  subtitle: 'الهاتف: ${teacher.phoneNumber} - البريد: ${teacher.email}',
                  onMoreTap: () { /* TODO: Show teacher options */ },
                );
              },
            );

          case TeachersStatus.loading:
          case TeachersStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

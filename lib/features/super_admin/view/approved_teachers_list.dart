import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovedTeachersList extends StatefulWidget {
  const ApprovedTeachersList({super.key});

  @override
  State<ApprovedTeachersList> createState() => _ApprovedTeachersListState();
}

class _ApprovedTeachersListState extends State<ApprovedTeachersList> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first created
    context.read<TeacherManagementBloc>().add(const FetchApprovedTeachers());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<TeacherManagementBloc>().add(FetchMoreApprovedTeachers());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<TeacherManagementBloc>().add(FetchApprovedTeachers(searchQuery: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAndFilterBar(
          onSearchChanged: _onSearchChanged,
          hintText: 'ابحث عن أستاذ بالاسم...',
        ),
        Expanded(
          child: BlocBuilder<TeacherManagementBloc, TeacherManagementState>(
            builder: (context, state) {
              if (state.approvedStatus == TeacherManagementStatus.loading && state.approvedTeachers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.approvedStatus == TeacherManagementStatus.failure && state.approvedTeachers.isEmpty) {
                return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
              }
              if (state.approvedTeachers.isEmpty) {
                return const Center(child: Text('لا يوجد أساتذة لعرضهم.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TeacherManagementBloc>().add(const FetchApprovedTeachers());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax ? state.approvedTeachers.length : state.approvedTeachers.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.approvedTeachers.length) {
                      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                    }
                    final teacher = state.approvedTeachers[index];
                    return ListItemTile(
                      title: teacher.fullName,
                      subtitle: 'المركز: ${teacher.centerName ?? 'N/A'} - الهاتف: ${teacher.phoneNumber ?? 'N/A'}',
                      onMoreTap: () {
                        // TODO: Implement options like view profile, edit, etc.
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

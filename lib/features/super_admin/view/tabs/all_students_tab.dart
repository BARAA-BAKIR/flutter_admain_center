import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This wrapper provides the BLoC to the screen
class AllStudentsTabWrapper extends StatelessWidget {
  const AllStudentsTabWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllStudentsBloc(
        repository: context.read<SuperAdminRepository>(),
      )..add(const FetchAllStudents()), // Fetch initial data
      child: const AllStudentsTab(),
    );
  }
}

class AllStudentsTab extends StatefulWidget {
  const AllStudentsTab({super.key});

  @override
  State<AllStudentsTab> createState() => _AllStudentsTabState();
}

class _AllStudentsTabState extends State<AllStudentsTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
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
      context.read<AllStudentsBloc>().add(FetchMoreAllStudents());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AllStudentsBloc>().add(FetchAllStudents(searchQuery: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAndFilterBar(
          onSearchChanged: _onSearchChanged,
          hintText: 'ابحث عن طالب بالاسم أو الرقم...',
          // TODO: Implement onFilterTap to show a dialog with Center and Halaqa filters
        ),
        Expanded(
          child: BlocBuilder<AllStudentsBloc, AllStudentsState>(
            builder: (context, state) {
              if (state.status == AllStudentsStatus.loading && state.students.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == AllStudentsStatus.failure && state.students.isEmpty) {
                return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
              }
              if (state.students.isEmpty) {
                return const Center(child: Text('لا يوجد طلاب لعرضهم.'));
              }
              return RefreshIndicator(
                onRefresh: () async => context.read<AllStudentsBloc>().add(const FetchAllStudents()),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax ? state.students.length : state.students.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.students.length) {
                      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                    }
                    final student = state.students[index];
                    final subtitle = 'المركز: ${student.centerName ?? 'N/A'} - الحلقة: ${student.halaqaName ?? 'N/A'}';
                    return ListItemTile(
                      title: student.fullName,
                      subtitle: subtitle,
                      onMoreTap: () {
                        // TODO: Implement options like view profile, transfer student, etc.
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

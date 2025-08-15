import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

// استيراد البلوك والمودل والريبوزيتوري اللازم
import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

// هذه الويدجت الآن يجب أن تُستدعى من مكان يوفر لها البلوك
class AllStudentsTabWrapper extends StatelessWidget {
  const AllStudentsTabWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllStudentsBloc(
        superAdminRepository: context.read<SuperAdminRepository>(),
      )..add(const FetchAllStudents()), // طلب البيانات فوراً
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
    if (_isBottom) {
      context.read<AllStudentsBloc>().add(FetchMoreAllStudents());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
        // شريط البحث (بدون فلترة)
        SearchAndFilterBar(
          onSearchChanged: _onSearchChanged, hintText: '',
        
        ),
        // قائمة الطلاب
        Expanded(
          // ===== ربط الواجهة بالبلوك الجديد =====
          child: BlocBuilder<AllStudentsBloc, AllStudentsState>(
            builder: (context, state) {
              switch (state.status) {
                case AllStudentsStatus.failure:
                  return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));

                case AllStudentsStatus.success:
                  if (state.students.isEmpty) {
                    return const Center(child: Text('لا يوجد طلاب يطابقون هذا البحث.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax ? state.students.length : state.students.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.students.length) {
                        return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                      }
                      final student = state.students[index];
                      // بناء النص الفرعي الذي يجمع اسم الحلقة والمركز
                     // final subtitle = '${student.center?.name ?? 'مركز غير محدد'} - ${student.halaqa?.name ?? 'بلا حلقة'}';
                      return ListItemTile(
                        title: student.fullName,
                        subtitle: 'subtitle',
                        onMoreTap: () { /* TODO: Show limited options for Super Admin */ },
                      );
                    },
                  );

                case AllStudentsStatus.initial:
                case AllStudentsStatus.loading:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

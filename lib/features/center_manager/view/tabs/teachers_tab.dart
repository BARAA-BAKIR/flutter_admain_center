import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';

class TeachersTab extends StatefulWidget {
  const TeachersTab({super.key});

  @override
  State<TeachersTab> createState() => _TeachersTabState();
}

class _TeachersTabState extends State<TeachersTab> {
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
      context.read<TeachersBloc>().add(FetchMoreTeachers());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<TeachersBloc>().add(FetchTeachers(searchQuery: query));
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _showteacherOptions(
    BuildContext context,
    int TeacherId,
    String halaqaName,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
//              ListTile(
//   leading: const Icon(Icons.person_search_rounded),
//   title: const Text('عرض الملف الشخصي'),
//   onTap: () {
//     Navigator.pop(ctx); // أغلق النافذة أولاً
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           // افترض أن لديك TeacherProfileBloc
//           create: (context) => TeacherProfileBloc(...)
//             ..add(FetchTeacherProfile(teacherId)),
//           child: const TeacherProfileScreen(),
//         ),
//       ),
//     );
//   },
// ),
// // تعديل البيانات
// ListTile(
//   leading: const Icon(Icons.edit_note_rounded),
//   title: const Text('تعديل البيانات'),
//   onTap: () {
//     Navigator.pop(ctx);
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           // افترض أن لديك EditTeacherBloc
//           create: (context) => EditTeacherBloc(...)
//             ..add(LoadTeacherForEdit(teacherId)),
//           child: const EditTeacherScreen(),
//         ),
//       ),
//     );
//   },
// ),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
                title: Text(
                  'حذف الأستاذ',
                  style: TextStyle(color: Colors.red.shade700),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder:
                        (dialogCtx) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: Text(
                            'هل أنت متأكد من رغبتك في حذف حلقة "$halaqaName"؟',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('إلغاء'),
                              onPressed: () => Navigator.pop(dialogCtx),
                            ),
                            TextButton(
                              child: const Text(
                                'حذف',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                context.read<TeachersBloc>().add(
                                  DeleteTeacher(TeacherId),
                                );
                                Navigator.pop(dialogCtx);
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAndFilterBar(
          onSearchChanged: _onSearchChanged,
          hintText: 'ابحث عن استاذ بالاسم او الرقم او الايميل...',
        ),
        Expanded(
          child: BlocBuilder<TeachersBloc, TeachersState>(
            builder: (context, state) {
              switch (state.status) {
                case TeachersStatus.failure:
                  return Center(
                    child: Text('فشل تحميل البيانات: ${state.errorMessage}'),
                  );

                case TeachersStatus.success:
                  if (state.teachers.isEmpty) {
                    return const Center(child: Text('لا يوجد أساتذة لعرضهم.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.hasReachedMax
                            ? state.teachers.length
                            : state.teachers.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.teachers.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final teacher = state.teachers[index];
                      return ListItemTile(
                        title: teacher.fullName,
                        subtitle:
                            'الهاتف: ${teacher.phoneNumber??'غير موجود'} - البريد: ${teacher.email ??'غير موجود'}',
                        onMoreTap: () {
                          _showteacherOptions(context, teacher.id, teacher.fullName);
                        },
                      );
                    },
                  );

                case TeachersStatus.loading:
                case TeachersStatus.initial:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        
      ],
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
// import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
// import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/view/add_edit_student_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AllStudentsTabWrapper extends StatelessWidget {
//   const AllStudentsTabWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//               AllStudentsBloc(repository: context.read<SuperAdminRepository>())
//                 ..add(const FetchAllStudents()),
//       child: const AllStudentsTab(),
//     );
//   }
// }

// class AllStudentsTab extends StatefulWidget {
//   const AllStudentsTab({super.key});
//   @override
//   State<AllStudentsTab> createState() => _AllStudentsTabState();
// }

// class _AllStudentsTabState extends State<AllStudentsTab> {
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (!_scrollController.hasClients) return;
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       context.read<AllStudentsBloc>().add(FetchMoreAllStudents());
//     }
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       context.read<AllStudentsBloc>().add(FetchAllStudents(searchQuery: query));
//     });
//   }

//   void _navigateToAddEditScreen({StudentListItem? student}) async {
//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder:
//             (_) => BlocProvider.value(
//               value: context.read<AllStudentsBloc>(),
//               child: AddEditStudentScreen(student: student),
//             ),
//       ),
//     );
//     if (result == true && mounted) {
//       context.read<AllStudentsBloc>().add(const FetchAllStudents());
//     }
//   }

//   void _showStudentOptions(BuildContext context, StudentListItem student) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.edit_rounded),
//               title: const Text('تعديل البيانات'),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 _navigateToAddEditScreen(student: student);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
//               title: Text(
//                 'حذف الطالب',
//                 style: TextStyle(color: Colors.red.shade700),
//               ),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 showDialog(
//                   context: context,
//                   builder:
//                       (dialogCtx) => AlertDialog(
//                         title: const Text('تأكيد الحذف'),
//                         content: Text(
//                           'هل أنت متأكد من رغبتك في حذف الطالب "${student.fullName}"؟',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(dialogCtx),
//                             child: const Text('إلغاء'),
//                           ),
//                           TextButton(
//                             child: const Text(
//                               'حذف',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             onPressed: () {
//                               context.read<AllStudentsBloc>().add(
//                                 DeleteStudent(student.id),
//                               );
//                               Navigator.pop(dialogCtx);
//                             },
//                           ),
//                         ],
//                       ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SearchAndFilterBar(
//             onSearchChanged: _onSearchChanged,
//             hintText: 'ابحث عن طالب بالاسم أو الرقم...',
//           ),
//           Expanded(
//             child: BlocBuilder<AllStudentsBloc, AllStudentsState>(
//               builder: (context, state) {
//                 if (state.status == AllStudentsStatus.loading &&
//                     state.students.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state.status == AllStudentsStatus.failure &&
//                     state.students.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'فشل تحميل البيانات: ${state.errorMessage ?? ''}',
//                     ),
//                   );
//                 }
//                 if (state.students.isEmpty) {
//                   return const Center(
//                     child: Text('لا يوجد طلاب يطابقون هذا البحث.'),
//                   );
//                 }
//                 return RefreshIndicator(
//                   onRefresh:
//                       () async => context.read<AllStudentsBloc>().add(
//                         const FetchAllStudents(),
//                       ),
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount:
//                         state.hasReachedMax
//                             ? state.students.length
//                             : state.students.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index >= state.students.length) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//                       final student = state.students[index];
//                       final centerName = student.centerName ?? 'غير معين';
//                       final halaqaName = student.halaqaName ?? 'غير معين';

//                       final subtitle =
//                           'المركز: $centerName - الحلقة: $halaqaName';

//                       return ListItemTile(
//                         title: student.fullName,
//                         subtitle: subtitle,
//                         onMoreTap: () => _showStudentOptions(context, student),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _navigateToAddEditScreen(),
//         heroTag: 'fab_add_student',
//         tooltip: 'إضافة طالب جديد',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/super_admin/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/all_students_bloc/all_students_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/add_edit_student_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllStudentsTabWrapper extends StatelessWidget {
  const AllStudentsTabWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllStudentsBloc(repository: context.read<SuperAdminRepository>())
        ..add(const FetchAllStudents()),
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<AllStudentsBloc>().add(FetchMoreAllStudents());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AllStudentsBloc>().add(FetchAllStudents(searchQuery: query));
    });
  }

  void _navigateToAddEditScreen({StudentListItem? student}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AllStudentsBloc>(),
          child: AddEditStudentScreen(student: student),
        ),
      ),
    );
    if (result == true && mounted) {
      context.read<AllStudentsBloc>().add(const FetchAllStudents());
    }
  }

  void _showStudentOptions(BuildContext context, StudentListItem student) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('تعديل البيانات'),
              onTap: () {
                Navigator.pop(ctx);
                _navigateToAddEditScreen(student: student);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
              title: Text('حذف الطالب', style: TextStyle(color: Colors.red.shade700)),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: Text('هل أنت متأكد من رغبتك في حذف الطالب "${student.fullName}"؟'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('إلغاء')),
                      TextButton(
                        child: const Text('حذف', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          context.read<AllStudentsBloc>().add(DeleteStudent(student.id));
                          Navigator.pop(dialogCtx);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchAndFilterBar(
            onSearchChanged: _onSearchChanged,
            hintText: 'ابحث عن طالب بالاسم أو الرقم...',
          ),
          Expanded(
            child: BlocBuilder<AllStudentsBloc, AllStudentsState>(
              buildWhen: (prev, current) => prev.listStatus != current.listStatus || prev.students.length != current.students.length,
              builder: (context, state) {
                if (state.listStatus == ListStatus.loading && state.students.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.listStatus == ListStatus.failure && state.students.isEmpty) {
                  return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage ?? ''}'));
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
                      final subtitle = 'المركز: ${student.centerName ?? 'غير معين'} - الحلقة: ${student.halaqaName ?? 'غير معين'}';
                      return ListItemTile(
                        title: student.fullName,
                        subtitle: subtitle,
                        onMoreTap: () => _showStudentOptions(context, student),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        heroTag: 'fab_add_student',

        tooltip: 'إضافة طالب جديد',
        child: const Icon(Icons.add),
      ),
    );
  }
}

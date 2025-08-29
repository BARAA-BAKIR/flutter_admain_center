// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
// import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
// import 'package:flutter_admain_center/data/models/super_admin/teacher_model.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ApprovedTeachersList extends StatefulWidget {
//   const ApprovedTeachersList({super.key});

//   @override
//   State<ApprovedTeachersList> createState() => _ApprovedTeachersListState();
// }

// class _ApprovedTeachersListState extends State<ApprovedTeachersList> {
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch initial data when the widget is first created
//     context.read<TeacherManagementBloc>().add(const FetchApprovedTeachers());
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
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.offset;
//     if (currentScroll >= (maxScroll * 0.9)) {
//       context.read<TeacherManagementBloc>().add(FetchMoreApprovedTeachers());
//     }
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       context.read<TeacherManagementBloc>().add(
//         FetchApprovedTeachers(searchQuery: query),
//       );
//     });
//   }

//   void _showTeacherOptions(BuildContext context, Teacher teacher) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.person_search_rounded),
//               title: const Text('عرض الملف الشخصي'),
//               onTap: () {
//                 /* TODO: Navigate to teacher profile */
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.edit_note_rounded),
//               title: const Text('تعديل البيانات'),
//               onTap: () {
//                 /* TODO: Navigate to edit teacher screen */
//               },
//             ),
//             // ✅ --- خيار الترقية ---
//             ListTile(
//               leading: const Icon(Icons.upgrade_rounded, color: Colors.blue),
//               title: const Text(
//                 'ترقية إلى مشرف',
//                 style: TextStyle(color: Colors.blue),
//               ),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 _showPromotionDialog(context, teacher);
//               },
//             ),
//             // delete with dialog
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text(
//                 'حذف الأستاذ',
//                 style: TextStyle(color: Colors.red),
//               ),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 showDialog(
//                   context: context,
//                   builder: (dialogCtx) => AlertDialog(
//                     title: const Text('تأكيد الحذف'),
//                     content: Text('هل أنت متأكد من حذف الأستاذ ${teacher.fullName}؟',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(dialogCtx),
//                         child: const Text('إلغاء'),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         onPressed: () {
//                           // context.read<TeacherManagementBloc>().add(
//                           //   DeleteTeacher(teacherId: teacher.id),
//                           // );
//                           Navigator.pop(dialogCtx);
//                         },
//                         child: const Text('حذف'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ✅ --- دالة لعرض نافذة الترقية ---
//   void _showPromotionDialog(BuildContext context, Teacher teacher) {
//     String? selectedRole;
//     final roles = ['مدير مركز', 'مدير عام', 'استاذ'];

//     showDialog(
//       context: context,
//       builder: (dialogCtx) {
//         return AlertDialog(
//           title: Text('ترقية الأستاذ: ${teacher.fullName}'),
//           content: DropdownButtonFormField<String>(
//             hint: const Text('اختر الدور الإداري الجديد'),
//             items:
//                 roles
//                     .map(
//                       (role) =>
//                           DropdownMenuItem(value: role, child: Text(role)),
//                     )
//                     .toList(),
//             onChanged: (value) => selectedRole = value,
//             validator: (value) => value == null ? 'الرجاء اختيار دور' : null,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogCtx),
//               child: const Text('إلغاء'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedRole != null) {
//                   context.read<TeacherManagementBloc>().add(
//                     PromoteTeacher(
//                       teacherId: teacher.id,
//                       newRole: selectedRole!,
//                     ),
//                   );
//                   Navigator.pop(dialogCtx);
//                 }
//               },
//               child: const Text('تأكيد الترقية'),
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
//             hintText: 'ابحث عن أستاذ بالاسم...',
//           ),
//           Expanded(
//             child: BlocBuilder<TeacherManagementBloc, TeacherManagementState>(
//               builder: (context, state) {
//                 if (state.approvedStatus == TeacherManagementStatus.loading &&
//                     state.approvedTeachers.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state.approvedStatus == TeacherManagementStatus.failure &&
//                     state.approvedTeachers.isEmpty) {
//                   return Center(
//                     child: Text('فشل تحميل البيانات: ${state.errorMessage}'),
//                   );
//                 }
//                 if (state.approvedTeachers.isEmpty) {
//                   return const Center(child: Text('لا يوجد أساتذة لعرضهم.'));
//                 }
//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     context.read<TeacherManagementBloc>().add(
//                       const FetchApprovedTeachers(),
//                     );
//                   },
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount:
//                         state.hasReachedMax
//                             ? state.approvedTeachers.length
//                             : state.approvedTeachers.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index >= state.approvedTeachers.length) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//                       final teacher = state.approvedTeachers[index];
//                       return ListItemTile(
//                         title: teacher.fullName,
//                         subtitle:
//                             'المركز: ${teacher.centerName ?? 'N/A'} - الهاتف: ${teacher.phoneNumber ?? 'N/A'}',
//                         onMoreTap: () => _showTeacherOptions(context, teacher),
//                       );
//                     },

//                     //add teacher item widget here
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         heroTag: 'fab_add_teacher',
//         onPressed: () {},
//         tooltip: 'إضافة أستاذ جديد',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/super_admin/teacher_model.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
// ✅ 1. استيراد الشاشة الجديدة
import 'package:flutter_admain_center/features/super_admin/view/add_edit_teacher_screen.dart';
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
      context.read<TeacherManagementBloc>().add(
            FetchApprovedTeachers(searchQuery: query),
          );
    });
  }

  // ✅ 2. إضافة دالة للانتقال إلى شاشة الإضافة/التعديل
  void _navigateToAddEditScreen({Teacher? teacher}) async {
    // نستخدم BlocProvider.value لتمرير نفس البلوك للشاشة الجديدة
    // هذا يضمن أن الشاشة الجديدة يمكنها إرسال الأحداث (Add/Update) لنفس البلوك
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TeacherManagementBloc>(),
          child: AddEditTeacherScreen(teacher: teacher),
        ),
      ),
    );

    // إذا عادت الشاشة بنتيجة 'true'، فهذا يعني أن هناك تغييراً قد حدث.
    // لا حاجة لاستدعاء fetch يدوياً لأن البلوك يقوم بذلك تلقائياً بعد نجاح الإضافة/التعديل.
    if (result == true) {
      // يمكن إضافة أي منطق هنا إذا لزم الأمر بعد العودة الناجحة
      print("Returned from Add/Edit screen with success.");
    }
  }

  void _showTeacherOptions(BuildContext context, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_search_rounded),
              title: const Text('عرض الملف الشخصي'),
              onTap: () {
                /* TODO: Navigate to teacher profile */
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: const Text('تعديل البيانات'),
              onTap: () {
                Navigator.pop(ctx);
                // ✅ 3. استدعاء دالة الانتقال للتعديل
                _navigateToAddEditScreen(teacher: teacher);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upgrade_rounded, color: Colors.blue),
              title: const Text(
                'ترقية إلى مشرف',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showPromotionDialog(context, teacher);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'حذف الأستاذ',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: Text(
                      'هل أنت متأكد من حذف الأستاذ ${teacher.fullName}؟',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx),
                        child: const Text('إلغاء'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          context.read<TeacherManagementBloc>().add(
                            DeleteTeacher( teacher.id),
                          );
                          Navigator.pop(dialogCtx);
                        },
                        child: const Text('حذف'),
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

  void _showPromotionDialog(BuildContext context, Teacher teacher) {
    String? selectedRole;
    final roles = ['مدير مركز', 'مدير عام'];

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('ترقية الأستاذ: ${teacher.fullName}'),
          content: DropdownButtonFormField<String>(
            hint: const Text('اختر الدور الإداري الجديد'),
            items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
            onChanged: (value) => selectedRole = value,
            validator: (value) => value == null ? 'الرجاء اختيار دور' : null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedRole != null) {
                  context.read<TeacherManagementBloc>().add(
                        PromoteTeacher(
                          teacherId: teacher.id,
                          newRole: selectedRole!,
                        ),
                      );
                  Navigator.pop(dialogCtx);
                }
              },
              child: const Text('تأكيد الترقية'),
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
            hintText: 'ابحث عن أستاذ بالاسم...',
          ),
          Expanded(
            child: BlocConsumer<TeacherManagementBloc, TeacherManagementState>(
              listener: (context, state) {
                // Listen for general errors, like promotion failure
                if (state.errorMessage != null && state.approvedStatus != TeacherManagementStatus.loading) {
                   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                     SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
                   );
                }
              },
              builder: (context, state) {
                if (state.approvedStatus == TeacherManagementStatus.loading && state.approvedTeachers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.approvedStatus == TeacherManagementStatus.failure && state.approvedTeachers.isEmpty) {
                  return Center(
                    child: Text('فشل تحميل البيانات: ${state.errorMessage ?? 'خطأ غير معروف'}'),
                  );
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
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final teacher = state.approvedTeachers[index];
                      return ListItemTile(
                        title: teacher.fullName,
                        subtitle: 'المركز: ${teacher.centerName ?? 'N/A'} - الهاتف: ${teacher.phoneNumber ?? 'N/A'}',
                        onMoreTap: () => _showTeacherOptions(context, teacher),
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
        heroTag: 'fab_add_teacher',
        // ✅ 4. استدعاء دالة الانتقال للإضافة
        onPressed: () => _navigateToAddEditScreen(),
        tooltip: 'إضافة أستاذ جديد',
        child: const Icon(Icons.add),
      ),
    );
  }
}

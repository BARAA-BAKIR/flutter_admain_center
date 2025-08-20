
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_teacher_bloc/edit_teacher_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teacher_profile_bloc/teacher_profile_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/teachers_bloc/teachers_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_teacher_screen.dart'; // استيراد الشاشة
import 'package:flutter_admain_center/features/center_manager/view/teacher_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<TeachersBloc>().add(FetchTeachers(searchQuery: query));
    });
  }

  void _showTeacherOptions(BuildContext context, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
     ListTile(
            leading: const Icon(Icons.visibility_outlined),
            title: const Text('عرض الملف الشخصي'),
            onTap: () {
              Navigator.pop(ctx); // أغلق القائمة السفلية
              Navigator.of(context).push(
                MaterialPageRoute(
                  // نوفر الـ repository للبلوك الجديد
                  builder: (_) => BlocProvider(
                    create: (context) => TeacherProfileBloc(repository:context.read<CenterManagerRepository>(),)
                      ..add(FetchTeacherProfile(teacher.id)), // نرسل حدث جلب البيانات فوراً
                    child: TeacherProfileScreen(teacherName: teacher.fullName),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_rounded),
            title: const Text('تعديل البيانات'),
            onTap: () async {
              Navigator.pop(ctx);
              // ✅ الإصلاح رقم 2: استدعاء الشاشة باستخدام MaterialPageRoute
              final updatedTeacher = await Navigator.of(context).push<Teacher>(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => EditTeacherBloc(repository: context.read<CenterManagerRepository>()),
                    // ✅ الإصلاح رقم 2 (تابع): تمرير الويدجت الصحيحة
                    child: EditTeacherScreen(teacherId: teacher.id),
                  ),
                ),
              );
              // ✅ الإصلاح رقم 3: إرسال الحدث باستخدام .add()
              if (updatedTeacher != null && context.mounted) {
                context.read<TeachersBloc>().add(UpdateTeacherInList(updatedTeacher));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
            title: Text('حذف الأستاذ', style: TextStyle(color: Colors.red.shade700)),
            onTap: () {
              Navigator.pop(ctx);
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: Text('هل أنت متأكد من رغبتك في حذف الأستاذ "${teacher.fullName}"؟'),
                  actions: [
                    TextButton(child: const Text('إلغاء'), onPressed: () => Navigator.pop(dialogCtx)),
                    TextButton(
                      child: const Text('حذف', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        context.read<TeachersBloc>().add(DeleteTeacher(teacher.id));
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TeachersBloc>().add(const FetchTeachers());
      },
      child: Column(
        children: [
          SearchAndFilterBar(
            onSearchChanged: _onSearchChanged,
            hintText: 'ابحث عن أستاذ بالاسم أو الرقم أو الإيميل...',
          ),
          Expanded(
            child: BlocConsumer<TeachersBloc, TeachersState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
                }
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green));
                }
              },
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
                          return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
                        }
                        final teacher = state.teachers[index];
                        return ListItemTile(
                          title: teacher.fullName,
                          subtitle: 'الهاتف: ${teacher.phoneNumber ?? 'غير متوفر'} - البريد: ${teacher.email ?? 'غير متوفر'}',
                          onMoreTap: () => _showTeacherOptions(context, teacher),
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
      ),
    );
  }
}

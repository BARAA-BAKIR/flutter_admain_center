import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/teacher_management_bloc/teacher_management_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PendingTeachersList extends StatefulWidget {
  const PendingTeachersList({super.key});

  @override
  State<PendingTeachersList> createState() => _PendingTeachersListState();
}

class _PendingTeachersListState extends State<PendingTeachersList> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherManagementBloc>().add(FetchPendingTeachers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherManagementBloc, TeacherManagementState>(
      builder: (context, state) {
        if (state.pendingStatus == TeacherManagementStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.pendingStatus == TeacherManagementStatus.failure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('فشل تحميل الطلبات: ${state.errorMessage}')),
              ElevatedButton.icon(
                onPressed:
                    () async => context.read<TeacherManagementBloc>().add(
                      FetchPendingTeachers(),
                    ),
                icon: Icon(Icons.replay_outlined),
                label: Text('إعادة المحاولة'),
              ),
            ],
          );
        }
        if (state.pendingTeachers.isEmpty) {
          return const Center(child: Text('لا توجد طلبات تسجيل معلقة حالياً.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<TeacherManagementBloc>().add(FetchPendingTeachers());
          },
          child: ListView.builder(
            itemCount: state.pendingTeachers.length,
            itemBuilder: (context, index) {
              final user = state.pendingTeachers[index];
              final formattedDate = DateFormat(
                'yyyy-MM-dd',
              ).format(DateTime.parse(user.createdAt));
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(
                    'المركز: ${user.centerName ?? 'N/A'}\nتاريخ الطلب: $formattedDate',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed:
                            () => context.read<TeacherManagementBloc>().add(
                              ApproveTeacherRequest(user.id),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed:
                            () => context.read<TeacherManagementBloc>().add(
                              RejectTeacherRequest(user.id),
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

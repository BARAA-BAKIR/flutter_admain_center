// In lib/features/teacher/view/completed_parts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/bloc/completed_parts/completed_parts_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedPartsScreen extends StatelessWidget {
  final int studentId;
  final String studentName;

  const CompletedPartsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompletedPartsBloc(
        repository: context.read<TeacherRepository>(),
      )..add(LoadStudentParts(studentId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الأجزاء المنجزة لـ: $studentName', style: GoogleFonts.tajawal()),
        ),
        body: BlocConsumer<CompletedPartsBloc, CompletedPartsState>(
          listener: (context, state) {
            if (state.status == PartsStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ'), backgroundColor: Colors.red),
              );
            } else if (state.status == PartsStatus.success && state.successMessage != null) { 
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green),
              ); 
                Navigator.pop(context);}
          },
          builder: (context, state) {
            if (state.status == PartsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.parts.isEmpty) {
              return const Center(child: Text('لا توجد أجزاء لعرضها.'));
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.parts.length,
                    itemBuilder: (context, index) {
                      final part = state.parts[index];
                      final bool isCompleted = part['is_completed'] ?? false;
                      return ChoiceChip(
                        label: Text(part['writing'], style: GoogleFonts.tajawal()),
                        selected: isCompleted,
                        onSelected: (selected) {
                          context.read<CompletedPartsBloc>().add(TogglePartSelection(part['id']));
                        },
                        selectedColor: Colors.green.shade400,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(color: isCompleted ? Colors.white : Colors.black),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: state.status == PartsStatus.submitting
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ التغييرات'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            context.read<CompletedPartsBloc>().add(SyncCompletedParts(studentId));
                           
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// // lib/features/teacher/view/student_follow_up_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/features/teacher/bloc/follow_up_bloc.dart';

// class StudentFollowUpScreen extends StatelessWidget {
//   final int studentId;
//   final int groupId;
//   final String studentName;
//   final bool isEditing;

//   const StudentFollowUpScreen({
//     super.key,
//     required this.studentId,
//     required this.groupId,
//     required this.studentName,
//     required this.isEditing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FollowUpBloc(
//         teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
//         studentId: studentId,
//         groupId: groupId,
//         isEditing: isEditing,
//       )..add(LoadInitialData()),
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           title: Text('متابعة: $studentName', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//           backgroundColor: AppColors.steel_blue,
//           foregroundColor: Colors.white,
//         ),
//         body: BlocListener<FollowUpBloc, FollowUpState>(
//           listener: (context, state) {
//             if (state.saveSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح'), backgroundColor: Colors.green));
//               Navigator.of(context).pop();
//             }
//             if (state.error != null) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: Colors.red));
//             }
//           },
//           child: BlocBuilder<FollowUpBloc, FollowUpState>(
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   // _buildDateField(state.),
//                   // const SizedBox(height: 16),
//                   _buildMemorizationCard(context, state),
//                   const SizedBox(height: 16),
//                   _buildReviewCard(context, state),
//                   const SizedBox(height: 16),
//                   _buildDutyCard(context, state),
//                   const SizedBox(height: 32),
//                   if (state.isSaving)
//                     const Center(child: CircularProgressIndicator())
//                   else
//                     ElevatedButton(
//                       onPressed: () => context.read<FollowUpBloc>().add(SaveFollowUpData()),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.steel_blue,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                       ),
//                       child: Text('حفظ المتابعة', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMemorizationCard(BuildContext context, FollowUpState state) {
//     return _buildSectionCard(
//       title: '📖 الحفظ الجديد',
//       child: Column(
//         children: [
//           // --- هذا هو الإصلاح ---
//           _buildCountInput(
//             label: 'عدد صفحات الحفظ',
//             controller: TextEditingController(text: state.savedPagesCount.toString()),
//             onChanged: (value) => context.read<FollowUpBloc>().add(SavedPagesChanged(value)),
//           ),
//           const SizedBox(height: 16),
//           _buildScoreSlider(
//             label: 'تقييم الحفظ:',
//             value: state.memorizationScore,
//             onChanged: (value) => context.read<FollowUpBloc>().add(MemorizationScoreChanged(value)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReviewCard(BuildContext context, FollowUpState state) {
//     return _buildSectionCard(
//       title: '📚 المراجعة',
//       child: Column(
//         children: [
//           // --- هذا هو الإصلاح ---
//           _buildCountInput(
//             label: 'عدد صفحات المراجعة',
//             controller: TextEditingController(text: state.reviewedPagesCount.toString()),
//             onChanged: (value) => context.read<FollowUpBloc>().add(ReviewedPagesChanged(value)),
//           ),
//           const SizedBox(height: 16),
//           _buildScoreSlider(
//             label: 'تقييم المراجعة:',
//             value: state.reviewScore,
//             onChanged: (value) => context.read<FollowUpBloc>().add(ReviewScoreChanged(value)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDutyCard(BuildContext context, FollowUpState state) {
//     return _buildSectionCard(
//       title: '📝 الواجب المطلوب',
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildCountInput(
//                   label: 'من صفحة',
//                   controller: TextEditingController(text: state.dutyFromPage.toString()),
//                   onChanged: (value) => context.read<FollowUpBloc>().add(DutyFromPageChanged(value)),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildCountInput(
//                   label: 'إلى صفحة',
//                   controller: TextEditingController(text: state.dutyToPage.toString()),
//                   onChanged: (value) => context.read<FollowUpBloc>().add(DutyToPageChanged(value)),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: TextEditingController(text: state.dutyRequiredParts),
//             onChanged: (value) => context.read<FollowUpBloc>().add(DutyRequiredPartsChanged(value)),
//             style: GoogleFonts.tajawal(),
//             decoration: InputDecoration(
//               labelText: 'الأجزاء المطلوبة (مثال: عم، تبارك)',
//               labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCountInput({
//     required String label,
//     required TextEditingController controller,
//     required ValueChanged<String> onChanged,
//   }) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       style: GoogleFonts.tajawal(),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       keyboardType: TextInputType.number,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//     );
//   }

//   Widget _buildScoreSlider({required String label, required int value, required ValueChanged<int> onChanged}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.tajawal(fontSize: 16, color: AppColors.night_blue)),
//         Row(
//           children: [
//             Expanded(
//               child: Slider(
//                 value: value.toDouble(),
//                 onChanged: (newRating) => onChanged(newRating.toInt()),
//                 min: 0,
//                 max: 5,
//                 divisions: 5,
//                 label: value.toString(),
//                 activeColor: AppColors.golden_orange,
//               ),
//             ),
//             Text(value.toString(), style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.golden_orange)),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionCard({required String title, required Widget child}) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.night_blue)),
//             const Divider(height: 24, thickness: 0.5),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/features/teacher/view/student_follow_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/teacher/bloc/follow_up_bloc.dart';
import 'package:intl/intl.dart';

class StudentFollowUpScreen extends StatelessWidget {
  final int studentId;
  final int groupId;
  final String studentName;
  final bool isEditing;

  const StudentFollowUpScreen({
    super.key,
    required this.studentId,
    required this.groupId,
    required this.studentName,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FollowUpBloc(
            teacherRepository: RepositoryProvider.of<TeacherRepository>(
              context,
            ),
            studentId: studentId,
            groupId: groupId,
            isEditing: isEditing,
          )..add(LoadInitialData()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            'متابعة: $studentName',
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.steel_blue,
          foregroundColor: Colors.white,
        ),
        body: BlocListener<FollowUpBloc, FollowUpState>(
          listener: (context, state) {
           
            if (state.saveStatus == SaveStatus.syncedToServer) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم الترحيل إلى السيرفر بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(
                context,
              ).pop(true); // نرجع true للإشارة إلى أن البيانات تم ترحيلها
            }
            if (state.saveStatus == SaveStatus.savedLocally) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم الحفظ محلياً'),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              Navigator.of(
                context,
              ).pop(true); // نرجع true للإشارة إلى أن البيانات تم حفظها
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 30.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<FollowUpBloc, FollowUpState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildDateField(state.date),
                  const SizedBox(height: 16),
                  _buildFollowUpCard(context, state),
                  const SizedBox(height: 16),
                  _buildDutyCard(context, state),
                  const SizedBox(height: 32),
                  if (state.isSaving)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed:
                          () => context.read<FollowUpBloc>().add(
                            SaveFollowUpData(),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.steel_blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'حفظ المتابعة',
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String date) {
    String formattedDate;

    try {
      // --- هذا هو الجزء الذي تم تعديله ---
      // =================================================================
      // 1. نتحقق أولاً من أن النص ليس فارغاً
      if (date.isNotEmpty) {
        // 2. نحاول تحليل التاريخ القادم من الحالة (state)
        final parsedDate = DateTime.parse(date);
        formattedDate = DateFormat('EEEE, yyyy-MM-dd', 'ar').format(parsedDate);
      } else {
        // 3. إذا كان النص فارغاً، نستخدم تاريخ اليوم الحالي
        formattedDate = DateFormat(
          'EEEE, yyyy-MM-dd',
          'ar',
        ).format(DateTime.now());
      }
      // =================================================================
    } catch (e) {
      // 4. إذا فشل التحليل لأي سبب آخر، نستخدم تاريخ اليوم الحالي كخطة بديلة
      print("Date parsing error: $e. Falling back to today's date.");
      formattedDate = DateFormat(
        'EEEE, yyyy-MM-dd',
        'ar',
      ).format(DateTime.now());
    }

    return _buildSectionCard(
      title: '📅 تاريخ اليوم',
      child: Center(
        child: Text(
          formattedDate,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpCard(BuildContext context, FollowUpState state) {
    return _buildSectionCard(
      title: '📖 المتابعة اليومية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCountInput(
            label: 'عدد صفحات الحفظ',
            initialValue: state.savedPagesCount.toString(),
            onChanged:
                (value) =>
                    context.read<FollowUpBloc>().add(SavedPagesChanged(value)),
          ),
          const SizedBox(height: 16),
          Text(
            'تقييم الحفظ:',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: AppColors.night_blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildScoreChips(
            selectedValue: state.memorizationScore,
            onSelected:
                (score) => context.read<FollowUpBloc>().add(
                  MemorizationScoreChanged(score),
                ),
          ),
          const SizedBox(height: 24),
          _buildCountInput(
            label: 'عدد صفحات المراجعة',
            initialValue: state.reviewedPagesCount.toString(),
            onChanged:
                (value) => context.read<FollowUpBloc>().add(
                  ReviewedPagesChanged(value),
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'تقييم المراجعة:',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: AppColors.night_blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildScoreChips(
            selectedValue: state.reviewScore,
            onSelected:
                (score) =>
                    context.read<FollowUpBloc>().add(ReviewScoreChanged(score)),
          ),
        ],
      ),
    );
  }

  Widget _buildDutyCard(BuildContext context, FollowUpState state) {
    return _buildSectionCard(
      title: '📝 الواجب المطلوب',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCountInput(
                  label: 'من صفحة',
                  initialValue: state.dutyFromPage.toString(),
                  onChanged:
                      (value) => context.read<FollowUpBloc>().add(
                        DutyFromPageChanged(value),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCountInput(
                  label: 'إلى صفحة',
                  initialValue: state.dutyToPage.toString(),
                  onChanged:
                      (value) => context.read<FollowUpBloc>().add(
                        DutyToPageChanged(value),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: state.dutyRequiredParts,
            onChanged:
                (value) => context.read<FollowUpBloc>().add(
                  DutyRequiredPartsChanged(value),
                ),
            style: GoogleFonts.tajawal(),
            decoration: InputDecoration(
              labelText: 'الأجزاء المطلوبة (مثال: عم، تبارك)',
              labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- الويدجتس المساعدة ---

  Widget _buildScoreChips({
    required int selectedValue,
    required ValueChanged<int> onSelected,
  }) {
    final scores = {
      'ممتاز جداً': 5,
      'ممتاز': 4,
      'جيد جداً': 3,
      'جيد': 2,
      'ضعيف': 1,
      'إعادة': 0,
    };

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          scores.entries.map((entry) {
            final isSelected = selectedValue == entry.value;
            return ChoiceChip(
              label: Text(entry.key),
              labelStyle: GoogleFonts.tajawal(
                color: isSelected ? Colors.white : AppColors.night_blue,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(entry.value);
                }
              },
              selectedColor: AppColors.teal_blue,
              backgroundColor: Colors.grey.shade200,
              pressElevation: 0,
            );
          }).toList(),
    );
  }

  Widget _buildCountInput({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: GoogleFonts.tajawal(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.night_blue,
              ),
            ),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }
}

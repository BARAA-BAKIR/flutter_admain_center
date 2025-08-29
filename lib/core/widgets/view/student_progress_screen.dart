// // lib/features/common/view/student_progress_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_progress_bloc/student_progress_bloc.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_progress_bloc/student_progress_event.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_progress_bloc/student_progress_state.dart';
// import 'package:flutter_admain_center/data/models/student_model.dart';

// class StudentProgressScreen extends StatelessWidget {
//   final Student student;

//   const StudentProgressScreen({super.key, required this.student});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'تقدم الطالب: ${student.fullName}',
//           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.steel_blue,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocBuilder<StudentProgressBloc, StudentProgressState>(
//         builder: (context, state) {
//           if (state is StudentProgressLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is StudentProgressLoaded) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async {
//                       context.read<StudentProgressBloc>().add(
//                         LoadStudentProgress(student.id),
//                       );
//                     },
//                     child: ListView.builder(
//                       itemCount: state.progress.length,
//                       itemBuilder: (context, index) {
//                         final progress = state.progress[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(16),
//                             title: Text(
//                               progress.stage?.stageName ?? 'غير محدد',
//                               style: GoogleFonts.tajawal(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'الحلقة: ${progress.halaqa?.name ?? 'غير محدد'}',
//                                   style: GoogleFonts.tajawal(),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'تاريخ البدء: ${progress.entryDate}',
//                                   style: GoogleFonts.tajawal(),
//                                 ),
//                                 if (progress.graduationDate != null) ...[
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'تاريخ التخرج: ${progress.graduationDate}',
//                                     style: GoogleFonts.tajawal(),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                             trailing: progress.graduationDate == null
//                                 ? Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(
//                                       'نشط',
//                                       style: GoogleFonts.tajawal(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton(
//                     onPressed: () => _showUpdateProgressDialog(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.steel_blue,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'تحديث تقدم الطالب',
//                       style: GoogleFonts.tajawal(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else if (state is StudentProgressError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'حدث خطأ',
//                     style: GoogleFonts.tajawal(fontSize: 20),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     state.message,
//                     style: GoogleFonts.tajawal(),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Center(
//             child: Text(
//               'لا توجد بيانات تقدم',
//               style: GoogleFonts.tajawal(fontSize: 18),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showUpdateProgressDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => BlocProvider(
//         create: (context) => StudentProgressBloc()..add(LoadProgressStages()),
//         child: AlertDialog(
//           title: Text(
//             'تحديث تقدم الطالب',
//             style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//           ),
//           content: BlocBuilder<StudentProgressBloc, StudentProgressState>(
//             builder: (context, state) {
//               if (state is ProgressStagesLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is ProgressStagesLoaded) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     DropdownButtonFormField<int>(
//                       items: state.stages.map((stage) {
//                         return DropdownMenuItem(
//                           value: stage.id,
//                           child: Text(
//                             stage.stageName,
//                             textAlign: TextAlign.right,
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {},
//                       decoration: InputDecoration(
//                         labelText: 'المرحلة',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<int>(
//                       items: state.halaqas.map((halaqa) {
//                         return DropdownMenuItem(
//                           value: halaqa.id,
//                           child: Text(
//                             halaqa.name,
//                             textAlign: TextAlign.right,
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {},
//                       decoration: InputDecoration(
//                         labelText: 'الحلقة',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//               return const Center(child: Text('لا توجد بيانات'));
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 'إلغاء',
//                 style: GoogleFonts.tajawal(),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // تحديث تقدم الطالب
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'تحديث',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
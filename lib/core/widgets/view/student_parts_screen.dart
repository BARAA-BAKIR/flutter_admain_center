// // lib/features/common/view/student_parts_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_parts_bloc/student_parts_bloc.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_parts_bloc/student_parts_event.dart';
// import 'package:flutter_admain_center/features/common/bloc/student_parts_bloc/student_parts_state.dart';
// import 'package:flutter_admain_center/data/models/student_model.dart';

// class StudentPartsScreen extends StatelessWidget {
//   final Student student;

//   const StudentPartsScreen({super.key, required this.student});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'الأجزاء المنجزة: ${student.fullName}',
//           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.steel_blue,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocBuilder<StudentPartsBloc, StudentPartsState>(
//         builder: (context, state) {
//           if (state is StudentPartsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is StudentPartsLoaded) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async {
//                       context.read<StudentPartsBloc>().add(
//                         LoadStudentParts(student.id),
//                       );
//                     },
//                     child: ListView.builder(
//                       itemCount: state.completedParts.length,
//                       itemBuilder: (context, index) {
//                         final part = state.completedParts[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(16),
//                             title: Text(
//                               part.part.writing,
//                               style: GoogleFonts.tajawal(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                             subtitle: Text(
//                               'تاريخ الإضافة: ${part.createdAt}',
//                               style: GoogleFonts.tajawal(),
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _confirmDelete(context, part.partId),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton(
//                     onPressed: () => _showAddPartDialog(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.steel_blue,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'إضافة جزء جديد',
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
//           } else if (state is StudentPartsError) {
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
//               'لا توجد أجزاء منجزة',
//               style: GoogleFonts.tajawal(fontSize: 18),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showAddPartDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => BlocProvider(
//         create: (context) => StudentPartsBloc()..add(LoadParts()),
//         child: AlertDialog(
//           title: Text(
//             'إضافة جزء جديد',
//             style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//           ),
//           content: BlocBuilder<StudentPartsBloc, StudentPartsState>(
//             builder: (context, state) {
//               if (state is PartsLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is PartsLoaded) {
//                 return DropdownButtonFormField<int>(
//                   items: state.parts.map((part) {
//                     return DropdownMenuItem(
//                       value: part.id,
//                       child: Text(
//                         part.writing,
//                         textAlign: TextAlign.right,
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {},
//                   decoration: InputDecoration(
//                     labelText: 'اختر الجزء',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 );
//               }
//               return const Center(child: Text('لا توجد أجزاء'));
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
//                 // إضافة الجزء
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'إضافة',
//                 style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext context, int partId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'تأكيد الحذف',
//           style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'هل أنت متأكد من حذف هذا الجزء؟',
//           style: GoogleFonts.tajawal(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: GoogleFonts.tajawal(),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<StudentPartsBloc>().add(RemoveCompletedPart(partId));
//               Navigator.pop(context);
//             },
//             child: Text(
//               'حذف',
//               style: GoogleFonts.tajawal(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
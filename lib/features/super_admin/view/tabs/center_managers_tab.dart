// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
// import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/center_managers_bloc/center_managers_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart'; // ✅ استيراد مكتبة التاريخ

// class CenterManagersTab extends StatelessWidget {
//   const CenterManagersTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CenterManagersBloc(
//         repository: context.read<SuperAdminRepository>(),
//       )..add(LoadCenterManagers()),
//       child: const CenterManagersView(),
//     );
//   }
// }

// class CenterManagersView extends StatelessWidget {
//   const CenterManagersView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<CenterManagersBloc, CenterManagersState>(
//         builder: (context, state) {
//           if (state is CenterManagersLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is CenterManagersError) {
//             return Center(child: Text('فشل تحميل البيانات: ${state.message}'));
//           }
//           if (state is CenterManagersLoaded) {
//             if (state.managers.isEmpty) {
//               return const Center(child: Text('لا يوجد مدراء مراكز لعرضهم.'));
//             }
//             return RefreshIndicator(
//               onRefresh: () async => context.read<CenterManagersBloc>().add(LoadCenterManagers()),
//               child: ListView.builder(
//                 itemCount: state.managers.length,
//                 itemBuilder: (context, index) {
//                   final manager = state.managers[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     child: ListTile(
//                       leading: const CircleAvatar(child: Icon(Icons.person_pin_rounded)),
//                       title: Text('${manager.firstName}${' '}${manager.lastName}', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//                       subtitle: Text('المركز: ${manager.centerName ?? 'غير معين'}'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.more_vert),
//                         onPressed: () => _showOptions(context, manager),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddEditDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showOptions(BuildContext context, CenterManagerModel manager) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) => Wrap(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.edit),
//             title: const Text('تعديل'),
//             onTap: () {
//               Navigator.pop(ctx);
//               _showAddEditDialog(context, manager: manager);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.delete, color: Colors.red),
//             title: const Text('حذف', style: TextStyle(color: Colors.red)),
//             onTap: () {
//               Navigator.pop(ctx);
//               showDialog(
//                 context: context,
//                 builder: (dialogCtx) => AlertDialog(
//                   title: const Text('تأكيد الحذف'),
//                   content: Text('هل أنت متأكد من حذف المدير ${manager.fullName}؟'),
//                   actions: [
//                     TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('إلغاء')),
//                     TextButton(
//                       onPressed: () {
//                         context.read<CenterManagersBloc>().add(DeleteCenterManager(manager.id));
//                         Navigator.pop(dialogCtx);
//                       },
//                       child: const Text('حذف', style: TextStyle(color: Colors.red)),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   // ✅ التعديل الكامل على دالة عرض نافذة الإضافة والتعديل
//   void _showAddEditDialog(BuildContext context, {CenterManagerModel? manager}) {
//     final formKey = GlobalKey<FormState>();

//     // تهيئة كل الـ Controllers
//     final firstNameController = TextEditingController(text: manager?.firstName ?? '');
//     final lastNameController = TextEditingController(text: manager?.lastName ?? '');
//     final fatherNameController = TextEditingController(text: manager?.fatherName ?? '');
//     final motherNameController = TextEditingController(text: manager?.motherName ?? '');
//     final emailController = TextEditingController(text: manager?.email ?? '');
//     final passwordController = TextEditingController();
//     final phoneController = TextEditingController(text: manager?.phoneNumber ?? '');
//     final addressController = TextEditingController(text: manager?.address ?? '');
//     final docNumberController = TextEditingController(text: manager?.documentNumber ?? '');
//     final educationController = TextEditingController(text: manager?.educationLevel ?? '');
//     final salaryController = TextEditingController(text: manager?.salary?.toString() ?? '');

//     // متغيرات لحفظ قيم التاريخ والجنس
//     DateTime? birthDate = manager != null ? DateTime.tryParse(manager.birthDate) : null;
//     DateTime? startDate = manager != null ? DateTime.tryParse(manager.startDate) : null;
//     String? gender = manager?.gender;

//     showDialog(
//       context: context,
//       builder: (dialogCtx) {
//         return AlertDialog(
//           title: Text(manager == null ? 'إضافة مدير جديد' : 'تعديل المدير'),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Form(
//                 key: formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CustomTextField(controller: firstNameController, labelText: 'الاسم الأول', icon: Icons.person, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: lastNameController, labelText: 'الاسم الأخير', icon: Icons.person, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: fatherNameController, labelText: 'اسم الأب', icon: Icons.person, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: motherNameController, labelText: 'اسم الأم', icon: Icons.person, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: emailController, labelText: 'البريد الإلكتروني', icon: Icons.email, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       if (manager == null) ...[
//                         const SizedBox(height: 8),
//                         CustomTextField(controller: passwordController, labelText: 'كلمة المرور', icon: Icons.lock, isPassword: true, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       ],
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: phoneController, labelText: 'رقم الهاتف', icon: Icons.phone, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: addressController, labelText: 'العنوان', icon: Icons.home, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: docNumberController, labelText: 'رقم الوثيقة', icon: Icons.description, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: educationController, labelText: 'المستوى التعليمي', icon: Icons.school, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//                       const SizedBox(height: 8),
//                       CustomTextField(controller: salaryController, labelText: 'الراتب (اختياري)', icon: Icons.attach_money, isRequired: false, keyboardType: TextInputType.number),
//                       const SizedBox(height: 8),
//                       // حقل اختيار الجنس
//                       DropdownButtonFormField<String?>( // 1. السماح بالنوع String? (يقبل null)
//                       value: gender,
//                       hint: const Text('الجنس (اختياري)'),
//                       // 2. إضافة عنصر فارغ يمثل القيمة null
//                       items: [
//                         const DropdownMenuItem<String?>(
//                           value: null,
//                           child: Text('غير محدد', style: TextStyle(color: Colors.grey)),
//                         ),
//                         ...['ذكر', 'انثى'].map((g) => DropdownMenuItem(value: g, child: Text(g))),
//                       ],
//                       onChanged: (value) => setState(() => gender = value),
//                       // 3. إزالة الـ validator لجعل الحقل اختياريًا
//                       // validator: (v) => v == null ? 'مطلوب' : null, // تم حذف هذا السطر
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.wc),
//                       ),
//                     ),
//                       const SizedBox(height: 8),
//                       // حقول اختيار التاريخ
//                       _buildDatePicker(context, 'تاريخ الميلاد', birthDate, (date) => setState(() => birthDate = date)),
//                       _buildDatePicker(context, 'تاريخ بدء العمل', startDate, (date) => setState(() => startDate = date)),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('إلغاء')),
//             ElevatedButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate() && birthDate != null && startDate != null && gender != null) {
//                   final data = {
//                     'first_name': firstNameController.text,
//                     'last_name': lastNameController.text,
//                     'father_name': fatherNameController.text,
//                     'mother_name': motherNameController.text,
//                     'email': emailController.text,
//                     'phone_number': phoneController.text,
//                     'address': addressController.text,
//                     'document_number': docNumberController.text,
//                     'education_level': educationController.text,
//                     'salary': salaryController.text,
//                     'gender': gender,
//                     'birth_date': DateFormat('yyyy-MM-dd').format(birthDate!),
//                     'start_date': DateFormat('yyyy-MM-dd').format(startDate!),
//                     if (manager == null) 'password': passwordController.text,
//                   };
//                   if (manager == null) {
//                     context.read<CenterManagersBloc>().add(AddCenterManager(data));
//                   } else {
//                     context.read<CenterManagersBloc>().add(UpdateCenterManager(manager.id, data));
//                   }
//                   Navigator.pop(dialogCtx);
//                 }
//               },
//               child: const Text('حفظ'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // دالة مساعدة لبناء حقل اختيار التاريخ
//   Widget _buildDatePicker(BuildContext context, String label, DateTime? date, Function(DateTime) onDateSelected) {
//     return TextButton.icon(
//       icon: const Icon(Icons.calendar_today),
//       label: Text(date == null ? label : DateFormat('yyyy-MM-dd').format(date)),
//       onPressed: () async {
//         final pickedDate = await showDatePicker(
//           context: context,
//           initialDate: date ?? DateTime.now(),
//           firstDate: DateTime(1950),
//           lastDate: DateTime.now(),
//         );
//         if (pickedDate != null) {
//           onDateSelected(pickedDate);
//         }
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/center_managers_bloc/center_managers_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/add_edit_manager_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CenterManagersTab extends StatelessWidget {
  const CenterManagersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CenterManagersBloc(
            repository: context.read<SuperAdminRepository>(),
          ),
      child: const CenterManagersView(),
    );
  }
}

class CenterManagersView extends StatefulWidget {
  const CenterManagersView({super.key});

  @override
  State<CenterManagersView> createState() => _CenterManagersViewState();
}

class _CenterManagersViewState extends State<CenterManagersView> {
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CenterManagersBloc>().add(
        LoadCenterManagers(searchQuery: query),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('center_managers_tab'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          final state = context.read<CenterManagersBloc>().state;
          if (state is! CenterManagersLoaded &&
              state is! CenterManagersLoading) {
            context.read<CenterManagersBloc>().add(LoadCenterManagers());
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  labelText: 'ابحث عن اسم مدير أو مركز...',
                  prefixIcon: const Icon(Icons.search),

                  border: OutlineInputBorder(
                    gapPadding: 6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<CenterManagersBloc, CenterManagersState>(
                listener: (context, state) {
                  if (state is CenterManagersError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('فشل العملية: ${state.message}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CenterManagersLoading &&
                      state is! CenterManagersLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CenterManagersLoaded) {
                    if (state.managers.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد مدراء مراكز لعرضهم.'),
                      );
                    }
                    if (state.isSearching) {
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh:
                          () async => context.read<CenterManagersBloc>().add(
                            LoadCenterManagers(),
                          ),
                      child: ListView.builder(
                        itemCount: state.managers.length,
                        itemBuilder: (context, index) {
                          final manager = state.managers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person_pin_rounded),
                              ),
                              title: Text(
                                manager.fullName,
                                style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'المركز: ${manager.centerName ?? 'غير معين'}',
                                style: GoogleFonts.tajawal(),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => _showOptions(context, manager),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text('جاري التحميل...')),
                      ElevatedButton.icon(
                        onPressed:
                            () async => context.read<CenterManagersBloc>().add(
                              LoadCenterManagers(),
                            ),
                        icon: Icon(Icons.replay_outlined),
                        label: Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_manager',
          onPressed: () => _navigateToAddEditScreen(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _navigateToAddEditScreen(
    BuildContext context, {
    CenterManagerModel? manager,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<CenterManagersBloc>(),
              child: AddEditManagerScreen(manager: manager),
            ),
      ),
    );
  }

  void _showOptions(BuildContext context, CenterManagerModel manager) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(' تعديل مدير مركز'),
                onTap: () {
                  Navigator.pop(ctx);
                  _navigateToAddEditScreen(context, manager: manager);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'حذف مدير مركز',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder:
                        (dialogCtx) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: Text(
                            'هل أنت متأكد من حذف المدير ${manager.fullName}؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogCtx),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<CenterManagersBloc>().add(
                                  DeleteCenterManager(manager.id),
                                );
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text('تم الحذف بنجاح'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                Navigator.pop(dialogCtx);
                              },
                              child: const Text(
                                'حذف',
                                style: TextStyle(color: Colors.red),
                              ),
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
}

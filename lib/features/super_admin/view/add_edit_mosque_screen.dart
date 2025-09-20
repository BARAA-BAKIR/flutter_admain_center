// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
// import 'package:flutter_admain_center/data/models/super_admin/mosque_model.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/mosque_bloc/mosques_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AddEditMosqueScreen extends StatefulWidget {
//   final MosqueModel? mosque; // إذا كان null، فهذه عملية إضافة

//   const AddEditMosqueScreen({super.key, this.mosque});

//   @override
//   State<AddEditMosqueScreen> createState() => _AddEditMosqueScreenState();
// }

// class _AddEditMosqueScreenState extends State<AddEditMosqueScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   int? _selectedCenterId;

//   // TODO: ستحتاج إلى طريقة لجلب قائمة المراكز هنا
//   // في الوقت الحالي، سنستخدم قائمة وهمية
//   final List<Map<String, dynamic>> _centers = [
//     {'id': 1, 'name': 'مركز الشام'},
//     {'id': 2, 'name': 'مركز حلب'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.mosque != null) {
//       _nameController.text = widget.mosque!.name;
//       _addressController.text = widget.mosque!.address;
//       // TODO: يجب أن يكون لديك ID المركز هنا
//       // _selectedCenterId = widget.mosque!.centerId;
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final data = {
//         'name': _nameController.text,
//         'address': _addressController.text,
//         'center_id': _selectedCenterId,
//       };

//       if (widget.mosque == null) {
//         context.read<MosquesBloc>().add(AddMosque(data));
//       } else {
//         context.read<MosquesBloc>().add(UpdateMosque(widget.mosque!.id, data));
//       }
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.mosque == null ? 'إضافة مسجد جديد' : 'تعديل المسجد'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16.0),
//           children: [
//             CustomTextField(
//               controller: _nameController,
//               labelText: 'اسم المسجد',
//               icon: Icons.mosque_rounded,
//               validator: (v) => v!.isEmpty ? 'اسم المسجد مطلوب' : null,
//             ),
//             const SizedBox(height: 16),
//             CustomTextField(
//               controller: _addressController,
//               labelText: 'عنوان المسجد',
//               icon: Icons.location_on_rounded,
//               validator: (v) => v!.isEmpty ? 'العنوان مطلوب' : null,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<int>(
//               value: _selectedCenterId,
//               hint: const Text('اختر المركز'),
//               items: _centers.map((center) {
//                 return DropdownMenuItem<int>(
//                   value: center['id'],
//                   child: Text(center['name']),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _selectedCenterId = value),
//               validator: (value) => value == null ? 'يجب اختيار مركز' : null,
//               decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.business_rounded)),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: _submitForm,
//               icon: const Icon(Icons.save_rounded),
//               label: Text(widget.mosque == null ? 'إضافة المسجد' : 'حفظ التعديلات'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/super_admin/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/add_edit_mosque_bloc/add_edit_mosque_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/mosque_bloc/mosques_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ 1. أصبح هذا الويدجت هو نقطة الدخول، ويوفر البلوك
class AddEditMosqueScreen extends StatelessWidget {
  final MosqueModel? mosque;

  const AddEditMosqueScreen({super.key, this.mosque});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AddEditMosqueBloc(
            repository: context.read<SuperAdminRepository>(),
            mosqueToEdit: mosque,
          )..add(LoadMosquePrerequisites()), // ✅ طلب البيانات فوراً
      child: const AddEditMosqueView(),
    );
  }
}

// ✅ 2. هذا الويدجت يعرض الواجهة فقط
class AddEditMosqueView extends StatefulWidget {
  const AddEditMosqueView({super.key});

  @override
  State<AddEditMosqueView> createState() => _AddEditMosqueViewState();
}

class _AddEditMosqueViewState extends State<AddEditMosqueView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  int? _selectedCenterId;

  @override
  void initState() {
    super.initState();
    // جلب بيانات المسجد الموجود (إذا كنا في وضع التعديل)
    final mosque = context.read<AddEditMosqueBloc>().mosqueToEdit;
    if (mosque != null) {
      _nameController.text = mosque.name;
      _addressController.text = mosque.address;
      _selectedCenterId = mosque.centerId; // نفترض وجود centerId في الموديل
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddEditMosqueBloc>();
      final data = {
        'name': _nameController.text,
        'address': _addressController.text,
        'center_id': _selectedCenterId,
      };

      if (bloc.mosqueToEdit == null) {
        bloc.add(SubmitNewMosque(data));
      } else {
        bloc.add(SubmitMosqueUpdate(data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AddEditMosqueBloc>().mosqueToEdit == null
              ? 'إضافة مسجد جديد'
              : 'تعديل المسجد',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      body: BlocListener<AddEditMosqueBloc, AddEditMosqueState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            // أبلغ القائمة الرئيسية بإعادة التحميل
            context.read<MosquesBloc>().add(const FetchMosques());
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    context.read<AddEditMosqueBloc>().mosqueToEdit != null
                        ? 'تم الحفظ بنجاح'
                        : 'تمت الإضافة بنجاح',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.of(context).pop();
          }
          if (state.status == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل العملية: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AddEditMosqueBloc, AddEditMosqueState>(
          builder: (context, state) {
            if (state.status == FormStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'اسم المسجد',
                    icon: Icons.mosque_rounded,
                    validator: (v) => v!.isEmpty ? 'اسم المسجد مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'عنوان المسجد',
                    icon: Icons.location_on_rounded,
                    validator: (v) => v!.isEmpty ? 'العنوان مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  // ✅ 3. بناء القائمة المنسدلة من الحالة
                  DropdownButtonFormField<int>(
                    value: _selectedCenterId,
                    hint: const Text('اختر المركز'),
                    items:
                        state.availableCenters.map((center) {
                          return DropdownMenuItem<int>(
                            value: center.id,
                            child: Text(center.name),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() => _selectedCenterId = value),
                    validator:
                        (value) => value == null ? 'يجب اختيار مركز' : null,
                    decoration: const InputDecoration(
                      label: Text('المركز'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business_rounded),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed:
                        state.status == FormStatus.submitting
                            ? null
                            : _submitForm,
                    icon:
                        state.status == FormStatus.submitting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.save_rounded),
                    label: Text(
                      context.read<AddEditMosqueBloc>().mosqueToEdit == null
                          ? 'إضافة المسجد'
                          : 'حفظ التعديلات',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.light_blue,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

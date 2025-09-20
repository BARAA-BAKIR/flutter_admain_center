
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/add_edit_center_bloc/add_edit_center_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditCenterScreen extends StatelessWidget {
  final CenterModel? center;
  const AddEditCenterScreen({super.key, this.center});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditCenterBloc(
        repository: context.read<SuperAdminRepository>(),
        centerId: center?.id,
      )..add(LoadCenterPrerequisites(centerIdToEdit: center?.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(center == null ? 'إضافة مركز جديد' : 'تعديل مركز: ${center!.name}'
              , style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
        ),
        body: AddEditCenterView(isEditing: center != null),
      ),
    );
  }
}

class AddEditCenterView extends StatefulWidget {
  final bool isEditing;
  const AddEditCenterView({super.key, required this.isEditing});

  @override
  State<AddEditCenterView> createState() => _AddEditCenterViewState();
}

class _AddEditCenterViewState extends State<AddEditCenterView> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _regionController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  int? _selectedManagerId;
  bool _isPopulated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddEditCenterBloc>();
      final centerData = {
        'name': _nameController.text,
        'manager_id': _selectedManagerId,
        'region': _regionController.text,
        'governorate': _governorateController.text,
        'city': _cityController.text,
        'address': _addressController.text,
      };

      if (widget.isEditing) {
        bloc.add(SubmitCenterUpdate(data: centerData));
      } else {
        bloc.add(SubmitNewCenter(data: centerData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditCenterBloc, AddEditCenterState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(widget.isEditing ? 'تم الحفظ بنجاح' : 'تمت الإضافة بنجاح'),
              backgroundColor: Colors.green,
            ));
          Navigator.of(context).pop(true);
        }
        if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text('فشل العملية: ${state.errorMessage ?? 'خطأ غير معروف'}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ));
        }
      },
      builder: (context, state) {
        if (state.status == FormStatus.loaded && widget.isEditing && state.initialData != null && !_isPopulated) {
          final data = state.initialData!;
          _nameController.text = data.name;
          _regionController.text = data.region ?? '';
          _governorateController.text = data.governorate;
          _cityController.text = data.city;
          _addressController.text = data.address ?? '';
          _selectedManagerId = data.managerId;
          _isPopulated = true;
        }

        if (state.status == FormStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
 final uniqueManagers = <Map<String, dynamic>>[];
      final seenIds = <int>{}; // مجموعة لتتبع الـ IDs التي تمت رؤيتها

      for (final manager in state.potentialManagers) {
        final managerId = manager['id'] as int;
        if (seenIds.add(managerId)) { // .add() ترجع true إذا كانت القيمة جديدة
          uniqueManagers.add(manager);
        }
      }
  final List<DropdownMenuItem<int?>> dropdownItems = [
        // ✅ الخطوة 1: أضف العنصر الأول يدوياً ليكون خيار "بدون مدير"
        // قيمته ستكون null لتمييزه
        const DropdownMenuItem<int?>(
          value: null,
          child: Text(
            '-- بدون مدير --',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
          ),
        ),
      ];

      // ✅ الخطوة 2: أضف باقي المدراء الفريدين إلى القائمة
      for (final manager in uniqueManagers) {
        dropdownItems.add(
          DropdownMenuItem<int?>(
            value: manager['id'] as int,
            child: Text(manager['name'] as String),
          ),
        );
      }
      // 2. التأكد من أن القيمة المختارة الحالية صالحة وموجودة في القائمة الفريدة
      final isManagerIdValid = uniqueManagers.any((m) => m['id'] == _selectedManagerId);

        return Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                  
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'اسم المركز',
                      icon: Icons.business,
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    // ... (باقي الحقول كما هي)
                    const SizedBox(height: 16),
                    
                   
                  DropdownButtonFormField<int?>(
                    menuMaxHeight: 300,
                    // ✅ الإصلاح: استخدم القيمة فقط إذا كانت صالحة
                    value: isManagerIdValid ? _selectedManagerId : null,
                    hint: const Text('اختر المدير المسؤول'),
                    // ✅ الإصلاح: استخدم القائمة الفريدة
                   items: dropdownItems,
                    onChanged: (value) => setState(() => _selectedManagerId = value),
                    decoration: const InputDecoration(
                      label: Text('المدير'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_search),
                    ),
                  ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _governorateController,
                      labelText: 'المحافظة',
                      icon: Icons.location_city,
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _cityController,
                      labelText: 'المدينة/القرية',
                      icon: Icons.location_on,
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _regionController,
                      labelText: 'المنطقة (اختياري)',
                      icon: Icons.map,
                      isRequired: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      labelText: 'العنوان التفصيلي (اختياري)',
                      icon: Icons.home,
                      isRequired: false,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.status == FormStatus.submitting ? null : () => _submitForm(context),
                  icon: const Icon(Icons.save_rounded),
                  label: state.status == FormStatus.submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.isEditing ? 'حفظ التعديلات' : 'إضافة المركز'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.light_blue,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
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
      )..add(LoadCenterPrerequisites(centerToEdit: center)),
      child: AddEditCenterView(isEditing: center != null),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'تعديل المركز' : 'إضافة مركز جديد'),
      ),
      body: BlocConsumer<AddEditCenterBloc, AddEditCenterState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            Navigator.of(context).pop(true);
          }
          if (state.status == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل العملية: ${state.errorMessage}'), backgroundColor: Colors.red),
            );
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
            _selectedManagerId = data.id;
            _isPopulated = true;
          }

          if (state.status == FormStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                CustomTextField(controller: _nameController, labelText: 'اسم المركز', icon: Icons.business, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedManagerId,
                  hint: const Text('اختر المدير المسؤول'),
                  items: state.potentialManagers.map((manager) {
                    return DropdownMenuItem<int>(value: manager['id'], child: Text(manager['name']));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedManagerId = value),
                  validator: (value) => value == null ? 'يجب اختيار مدير' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(controller: _governorateController, labelText: 'المحافظة', icon: Icons.location_city, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 16),
                CustomTextField(controller: _cityController, labelText: 'المدينة/القرية', icon: Icons.location_on, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 16),
                CustomTextField(controller: _regionController, labelText: 'المنطقة', icon: Icons.map, isRequired: false),
                const SizedBox(height: 16),
                CustomTextField(controller: _addressController, labelText: 'العنوان التفصيلي', icon: Icons.home, isRequired: false),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: state.status == FormStatus.submitting ? null : () => _submitForm(context),
                  child: state.status == FormStatus.submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.isEditing ? 'حفظ التعديلات' : 'إضافة المركز'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/add_edit_halaqa_bloc/add_edit_halaqa_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditHalaqaScreen extends StatelessWidget {
  final HalaqaModel? halaqa;

  const AddEditHalaqaScreen({super.key, this.halaqa});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditHalaqaBloc(
        repository: context.read<SuperAdminRepository>(),
      )..add(LoadHalaqaPrerequisites()),
      child: AddEditHalaqaView(halaqa: halaqa),
    );
  }
}

class AddEditHalaqaView extends StatefulWidget {
  final HalaqaModel? halaqa;

  const AddEditHalaqaView({super.key, this.halaqa});

  @override
  State<AddEditHalaqaView> createState() => _AddEditHalaqaViewState();
}

class _AddEditHalaqaViewState extends State<AddEditHalaqaView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _selectedCenterId;
  int? _selectedMosqueId;
  int? _selectedTypeId;

  @override
  void initState() {
    super.initState();
    if (widget.halaqa != null) {
      _nameController.text = widget.halaqa!.name;
      _selectedCenterId = widget.halaqa!.centerId;
      _selectedMosqueId = widget.halaqa!.mosqueId;
      _selectedTypeId = widget.halaqa!.typeId;
      
      // ✅ عند التعديل، اطلب جلب المساجد للمركز المحدد مسبقاً
      if (_selectedCenterId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<AddEditHalaqaBloc>().add(CenterSelected(_selectedCenterId!));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddEditHalaqaBloc>();
      final data = {
        'name': _nameController.text,
        'mosque_id': _selectedMosqueId,
        'type': _selectedTypeId, // تم تصحيحها في الرد السابق
      };

      // ✅ 2. التمييز بين الإضافة والتعديل
      if (widget.halaqa == null) {
        bloc.add(SubmitHalaqa(data));
      } else {
        bloc.add(SubmitHalaqaUpdate(widget.halaqa!.id, data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.halaqa == null ? 'إضافة حلقة جديدة' : 'تعديل الحلقة',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      body: BlocConsumer<AddEditHalaqaBloc, AddEditHalaqaState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            context.read<HalaqasBloc>().add(const FetchHalaqas());
              ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(widget.halaqa !=null ? 'تم الحفظ بنجاح' : 'تمت الإضافة بنجاح'),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).pop();
          }
          if (state.status == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل العملية: ${state.errorMessage}'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FormStatus.loading && state.centers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'اسم الحلقة',
                  icon: Icons.groups_2_rounded,
                  validator: (v) => v!.isEmpty ? 'اسم الحلقة مطلوب' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  
                  menuMaxHeight: 300,
                  value: _selectedCenterId,
                  hint: const Text('1. اختر المركز'),
                  items: state.centers.map((center) => DropdownMenuItem(value: center['id'] as int, child: Text(center['name'].toString()))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCenterId = value;
                      _selectedMosqueId = null;
                    });
                    if (value != null) {
                      context.read<AddEditHalaqaBloc>().add(CenterSelected(value));
                    }
                  },
                  validator: (v) => v == null ? 'الرجاء اختيار مركز' : null,
                  decoration: const InputDecoration(
                    label:Text('المركز')
                    ,border: OutlineInputBorder(), prefixIcon: Icon(Icons.business_rounded)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                   menuMaxHeight: 300,
                  value: _selectedMosqueId,
                  hint: const Text('2. اختر المسجد'),
                  items: state.mosques.map((mosque) => DropdownMenuItem(value: mosque['id'] as int, child: Text(mosque['name'].toString()))).toList(),
                  onChanged: (value) => setState(() => _selectedMosqueId = value),
                  validator: (v) => v == null ? 'الرجاء اختيار مسجد' : null,
                  decoration: const InputDecoration(
                    label:Text('المسجد') 
                  ,border:
                   OutlineInputBorder(), prefixIcon: Icon(Icons.mosque_rounded)),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                   menuMaxHeight: 300,
                  value: _selectedTypeId,
                  hint: const Text('3. اختر نوع الحلقة'),
                  items: state.halaqaTypes.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name))).toList(),
                  onChanged: (value) => setState(() => _selectedTypeId = value),
                  validator: (v) => v == null ? 'الرجاء اختيار نوع الحلقة' : null,
                  decoration: const InputDecoration(label: Text('نوع الحلقة'),border: OutlineInputBorder(), prefixIcon: Icon(Icons.category_rounded)),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.light_blue,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: state.status == FormStatus.submitting ? null : _submitForm,
                  icon: state.status == FormStatus.submitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    
                    widget.halaqa == null ? 'إضافة الحلقة' : 'حفظ التعديلات',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold,
                    
                  )
                  
                    ,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

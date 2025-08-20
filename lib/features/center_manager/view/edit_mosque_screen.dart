// lib/features/center_manager/view/edit_mosque_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_mosque_bloc/edit_mosque_bloc.dart';

class EditMosqueScreen extends StatelessWidget {
  final Mosque mosque;
  const EditMosqueScreen({super.key, required this.mosque});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMosqueBloc(
        repository: context.read<CenterManagerRepository>(),
      ),
      // ✅✅✅ الإصلاح رقم 1: استخدام BlocListener هنا في المستوى الأعلى ✅✅✅
      child: BlocListener<EditMosqueBloc, EditMosqueState>(
        listener: (context, state) {
          // لا نضع أي شيء له علاقة بالـ UI هنا، فقط الـ SnackBar والـ Navigator
          if (state.status == FormStatus.submissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('تم تحديث المسجد بنجاح!'), backgroundColor: Colors.green),
              );
            Navigator.of(context).pop(state.updatedMosque);
          }
          if (state.status == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'فشلت عملية التحديث'), backgroundColor: Colors.red),
              );
          }
        },
        // الابن هو الواجهة الفعلية
        child: _EditMosqueForm(mosque: mosque),
      ),
    );
  }
}

class _EditMosqueForm extends StatefulWidget {
  final Mosque mosque;
  const _EditMosqueForm({required this.mosque});

  @override
  State<_EditMosqueForm> createState() => _EditMosqueFormState();
}

class _EditMosqueFormState extends State<_EditMosqueForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.mosque.name);
    _addressController = TextEditingController(text: widget.mosque.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // لا نتحقق من حالة البلوك هنا، فقط نرسل الحدث
    if (_formKey.currentState!.validate()) {
      final mosqueData = {
        'name': _nameController.text,
        'address': _addressController.text,
      };
      context.read<EditMosqueBloc>().add(
            EditMosqueSubmitted(widget.mosque.id, mosqueData),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅✅✅ الإصلاح رقم 2: استخدام BlocBuilder لمراقبة حالة الزر فقط ✅✅✅
    final isSubmitting = context.select((EditMosqueBloc bloc) => bloc.state.status == FormStatus.submissionInProgress);

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل: ${widget.mosque.name}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const SizedBox(height: 20),
            _buildTextFormField(_nameController, 'اسم المسجد', Icons.mosque),
            const SizedBox(height: 20),
            _buildTextFormField(_addressController, 'العنوان', Icons.location_on_outlined),
            const SizedBox(height: 40),
            // ✅✅✅ الإصلاح رقم 3: بناء الزر بناءً على المتغير isSubmitting ✅✅✅
            if (isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt, color: Colors.white),
                label: const Text('حفظ التعديلات', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                // تعطيل الزر أثناء الإرسال لمنع الضغطات المتكررة
                onPressed: isSubmitting ? null : _submitForm,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}

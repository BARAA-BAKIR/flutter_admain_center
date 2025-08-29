import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/profile_boc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // لاستخدام DateFormat

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  // متغيرات حالة للحقول الخاصة
  String? _selectedGender;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.userProfile;
    if (profile != null) {
      // تعبئة الـ Controllers العادية
      _controllers['name'] = TextEditingController(text: profile.name);
      _controllers['email'] = TextEditingController(text: profile.email);
      if (profile.employee != null) {
        final emp = profile.employee!;
        _controllers['first_name'] = TextEditingController(text: emp.firstName);
        _controllers['last_name'] = TextEditingController(text: emp.lastName);
        _controllers['father_name'] = TextEditingController(text: emp.fatherName);
        _controllers['mother_name'] = TextEditingController(text: emp.motherName);
        _controllers['birth_date'] = TextEditingController(text: emp.birthDate);
        _controllers['education_level'] = TextEditingController(text: emp.educationLevel);
        _controllers['address'] = TextEditingController(text: emp.address);
        _controllers['phone_number'] = TextEditingController(text: emp.phoneNumber);
        _controllers['document_number'] = TextEditingController(text: emp.documentNumber);
        
        // تعبئة متغيرات الحالة الخاصة
        _selectedGender = emp.gender;
        if (emp.employeeadmin != null) {
          _controllers['administrative_role'] = TextEditingController(text: emp.employeeadmin!.administrativeRole);
          _isActive = emp.employeeadmin!.status == 'نشط';
        }
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = _controllers.map((key, value) => MapEntry(key, value.text));
      
      // إضافة قيم الحقول الخاصة
      data['gender'] = _selectedGender ?? '';
      data['status'] = _isActive ? 'نشط' : 'غير نشط';
      
      data['current_password'] = context.read<ProfileBloc>().state.currentPassword!;
      context.read<ProfileBloc>().add(ProfileInfoUpdated(data: data));
    }
  }

  // دالة لعرض منتقي التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_controllers['birth_date']!.text) ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _controllers['birth_date']!.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success) {
              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('تم التحديث بنجاح!'), backgroundColor: Colors.green));
              Navigator.of(context).pop();
            } else if (state.status == ProfileStatus.failure) {
              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'فشل التحديث'), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            if (state.userProfile == null) return const Center(child: Text('خطأ: لا يوجد مستخدم.'));
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle('معلومات الحساب'),
                  _buildTextField('name', 'الاسم الكامل'),
                  _buildTextField('email', 'البريد الإلكتروني'),
                  
                  if (state.userProfile!.employee != null) ...[
                    _buildSectionTitle('المعلومات الشخصية'),
                    _buildTextField('first_name', 'الاسم الأول'),
                    _buildTextField('last_name', 'اسم العائلة'),
                    _buildTextField('father_name', 'اسم الأب'),
                    _buildTextField('mother_name', 'اسم الأم'),
                    
                    // ✅ حقل التاريخ المحسّن
                    _buildDateField('birth_date', 'تاريخ الميلاد'),

                    _buildTextField('document_number', 'رقم الوثيقة'),
                    
                    // ✅ حقل الجنس المحسّن
                    _buildGenderDropdown(),

                    _buildTextField('education_level', 'المستوى التعليمي'),
                    _buildTextField('address', 'العنوان'),
                    _buildTextField('phone_number', 'رقم الهاتف'),
                  ],
                  
                  if (state.userProfile!.employee?.employeeadmin != null) ...[
                    _buildSectionTitle('معلومات الدور الإداري'),
                    // ✅ حقل الدور للقراءة فقط
                    _buildReadOnlyField('administrative_role', 'الدور الإداري'),
                    
                    // ✅ حقل الحالة المحسّن
                    _buildStatusSwitch(),
                  ],
                  
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.status == ProfileStatus.submitting ? null : _submitForm,
                    child: state.status == ProfileStatus.submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ التغييرات'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // -- واجهات مساعدة جديدة ومحسّنة --

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
    );
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), contentPadding: const EdgeInsets.all(12)),
        validator: (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  Widget _buildReadOnlyField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildDateField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
        validator: (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          labelText: 'الجنس',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
        items: ['ذكر', 'انثى'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        validator: (value) => value == null ? 'الرجاء اختيار الجنس' : null,
      ),
    );
  }

  Widget _buildStatusSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: const Text('الحالة'),
        subtitle: Text(_isActive ? 'نشط' : 'غير نشط'),
        value: _isActive,
        onChanged: (bool value) {
          setState(() {
            _isActive = value;
          });
        },
        secondary: Icon(_isActive ? Icons.check_circle : Icons.cancel, color: _isActive ? Colors.green : Colors.red),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

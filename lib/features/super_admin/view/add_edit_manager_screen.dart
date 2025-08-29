import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/custom_text_field.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/add_edit_manager_bloc/add_edit_manager_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/center_managers_bloc/center_managers_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEditManagerScreen extends StatelessWidget {
  final CenterManagerModel? manager;

  const AddEditManagerScreen({super.key, this.manager});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AddEditManagerBloc(
            repository: context.read<SuperAdminRepository>(),
          )..add(LoadManagerPrerequisites(managerToEdit: manager)),
      child: AddEditManagerView(manager: manager),
    );
  }
}

class AddEditManagerView extends StatefulWidget {
  final CenterManagerModel? manager;
  const AddEditManagerView({super.key, this.manager});

  @override
  State<AddEditManagerView> createState() => _AddEditManagerViewState();
}

class _AddEditManagerViewState extends State<AddEditManagerView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _educationController = TextEditingController();
  final _salaryController = TextEditingController();

  // State variables
  int? _selectedUserId;
  int? _selectedCenterId;
  DateTime? _birthDate;
  DateTime? _startDate;
  String? _gender;

  @override
  void initState() {
    super.initState();
    if (widget.manager != null) {
      final m = widget.manager!;
      _firstNameController.text = m.firstName;
      _lastNameController.text = m.lastName;
      _fatherNameController.text = m.fatherName;
      _motherNameController.text = m.motherName;
      _emailController.text = m.email;
      _phoneController.text = m.phoneNumber ?? '';
      _addressController.text = m.address ?? '';
      _docNumberController.text = m.documentNumber ?? '';
      _educationController.text = m.educationLevel;
      _salaryController.text = m.salary?.toString() ?? '';
      _birthDate = DateTime.tryParse(m.birthDate);
      _startDate = DateTime.tryParse(m.startDate);
      _gender = m.gender;
      _selectedUserId = m.id;
      _selectedCenterId = m.centerId;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _docNumberController.dispose();
    _educationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddEditManagerBloc>();
      final data = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'father_name': _fatherNameController.text,
        'mother_name': _motherNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'address': _addressController.text,
        'document_number': _docNumberController.text,
        'education_level': _educationController.text,
        'salary':
            _salaryController.text.isNotEmpty ? _salaryController.text : null,
        'gender': _gender,
        'birth_date':
            _birthDate != null
                ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                : null,
        'start_date':
            _startDate != null
                ? DateFormat('yyyy-MM-dd').format(_startDate!)
                : null,
        'center_id': _selectedCenterId,
      };

      if (widget.manager == null) {
        if (_selectedUserId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء اختيار موظف لترقيته')),
          );
          return;
        }
        data['user_id'] = _selectedUserId;
        if (_passwordController.text.isNotEmpty) {
          data['password'] = _passwordController.text;
        }
        bloc.add(SubmitNewManager(data: data));
      } else {
        bloc.add(
          SubmitManagerUpdate(managerId: widget.manager!.id, data: data),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.manager == null ? 'إضافة مدير' : 'تعديل مدير',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<AddEditManagerBloc, AddEditManagerState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            context.read<CenterManagersBloc>().add(LoadCenterManagers());
            Navigator.of(context).pop();
          }
          if (state.status == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل العملية: ${state.errorMessage ?? ''}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FormStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final unassignedCenters = state.unassignedCenters ?? [];
          final List<DropdownMenuItem<int?>> centerItems = [
            // الخيار الأول دائماً هو "بدون مركز"
            const DropdownMenuItem<int?>(value: null, child: Text('بدون مركز')),
          ];

          // ✅ 2. إضافة المراكز غير المعينة
          for (var center in unassignedCenters) {
            centerItems.add(
              DropdownMenuItem(
                value: center['id'] as int,
                child: Text(center['name'].toString()),
              ),
            );
          }

          // ✅ 3. في وضع التعديل، تأكد من وجود المركز الحالي للمدير في القائمة
          if (widget.manager != null && widget.manager!.centerId != null) {
            // ابحث إذا كان المركز الحالي موجوداً بالفعل في القائمة
            final isCenterAlreadyInList = centerItems.any(
              (item) => item.value == widget.manager!.centerId,
            );

            // إذا لم يكن موجوداً، قم بإضافته
            if (!isCenterAlreadyInList) {
              centerItems.add(
                DropdownMenuItem(
                  value: widget.manager!.centerId,
                  child: Text(
                    widget.manager!.centerName ?? 'المركز الحالي',
                  ), // استخدم اسم المركز إذا كان متاحاً
                ),
              );
            }
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'الاسم الأول',
                  icon: Icons.person,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'الاسم الأخير',
                  icon: Icons.person,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _fatherNameController,
                  labelText: 'اسم الأب',
                  icon: Icons.person,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _motherNameController,
                  labelText: 'اسم الأم',
                  icon: Icons.person,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  icon: Icons.email,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                if (widget.manager == null) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'كلمة المرور',
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  ),
                ],
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  icon: Icons.phone,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _addressController,
                  labelText: 'العنوان',
                  icon: Icons.home,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _docNumberController,
                  labelText: 'رقم الوثيقة',
                  icon: Icons.description,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _educationController,
                  labelText: 'المستوى التعليمي',
                  icon: Icons.school,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _salaryController,
                  labelText: 'الراتب (اختياري)',
                  icon: Icons.attach_money,
                  isRequired: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    icon: const Icon(Icons.wc),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: _gender,
                  hint: const Text('الجنس'),
                  items:
                      ['ذكر', 'انثى']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _gender = value),
                  validator: (v) => v == null ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  context,
                  'تاريخ الميلاد',
                  _birthDate,
                  (date) => setState(() => _birthDate = date),
                ),
                _buildDatePicker(
                  context,
                  'تاريخ بدء العمل',
                  _startDate,
                  (date) => setState(() => _startDate = date),
                ),
                const SizedBox(height: 16),
                // This ListTile was removed as it's now redundant
                // if (widget.manager != null && widget.manager!.centerName != null)
                //   ListTile(...)

                // ...

                // ✅ 4. استخدام القائمة التي تم بناؤها
                DropdownButtonFormField<int?>(
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    icon: const Icon(Icons.business_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: _selectedCenterId,
                  hint: const Text('تعيين لمركز (اختياري)'),
                  items: centerItems, // <-- استخدام القائمة الآمنة
                  onChanged:
                      (value) => setState(() => _selectedCenterId = value),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.light_blue,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed:
                      state.status == FormStatus.submitting
                          ? null
                          : _submitForm,
                  child:
                      state.status == FormStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('حفظ'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? date,
    Function(DateTime) onDateSelected,
  ) {
    return TextButton.icon(
      icon: const Icon(Icons.calendar_today),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      label: Text(
        date == null
            ? label
            : '$label${' : '}${DateFormat('yyyy-MM-dd').format(date)}',
      ),
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}

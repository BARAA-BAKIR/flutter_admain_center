import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/teacher/view/completed_parts_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/teacher/bloc/follow_up/follow_up_bloc.dart';
import 'package:intl/intl.dart';

class StudentFollowUpScreen extends StatefulWidget {
  final int studentId;
  final int groupId;
  final String studentName;
  final bool isEditing;

  const StudentFollowUpScreen({
    super.key,
    required this.studentId,
    required this.groupId,
    required this.studentName,
    required this.isEditing,
  });

  @override
  State<StudentFollowUpScreen> createState() => _StudentFollowUpScreenState();
}

class _StudentFollowUpScreenState extends State<StudentFollowUpScreen> {
  // تعريف الـ Controllers
  late final TextEditingController _savedPagesController;
  late final TextEditingController _reviewedPagesController;
  late final TextEditingController _dutyFromController;
  late final TextEditingController _dutyToController;
  late final TextEditingController _dutyPartsController;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Controllers
    _savedPagesController = TextEditingController();
    _reviewedPagesController = TextEditingController();
    _dutyFromController = TextEditingController();
    _dutyToController = TextEditingController();
    _dutyPartsController = TextEditingController();
  }

  @override
  void dispose() {
    // التخلص من الـ Controllers
    _savedPagesController.dispose();
    _reviewedPagesController.dispose();
    _dutyFromController.dispose();
    _dutyToController.dispose();
    _dutyPartsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FollowUpBloc(
            teacherRepository: RepositoryProvider.of<TeacherRepository>(
              context,
            ),
            studentId: widget.studentId,
            groupId: widget.groupId,
            isEditing: widget.isEditing,
          )..add(LoadInitialData()),
      child: BlocConsumer<FollowUpBloc, FollowUpState>(
        listener: (context, state) {
          if (state.saveStatus == SaveStatus.syncedToServer) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('تم الترحيل إلى السيرفر بنجاح'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.of(context).pop(true);
          }
          if (state.saveStatus == SaveStatus.savedLocally) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text('تم الحفظ محلياً للمزامنة لاحقاً'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.all(16),
                  backgroundColor: Colors.orange,
                ),
              );
            Navigator.of(context).pop(true);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          // الجزء الأهم: تحديث قيم الـ Controllers عندما تأتي البيانات
          if (!state.isLoading && state.error == null) {
            // التحقق من أن النص في المتحكم مختلف قبل تحديثه لتجنب الحلقات اللانهائية
            if (_savedPagesController.text !=
                state.savedPagesCount.toString()) {
              _savedPagesController.text = state.savedPagesCount.toString();
            }
            if (_reviewedPagesController.text !=
                state.reviewedPagesCount.toString()) {
              _reviewedPagesController.text =
                  state.reviewedPagesCount.toString();
            }
            if (_dutyFromController.text != state.dutyFromPage.toString()) {
              _dutyFromController.text = state.dutyFromPage.toString();
            }
            if (_dutyToController.text != state.dutyToPage.toString()) {
              _dutyToController.text = state.dutyToPage.toString();
            }
            if (_dutyPartsController.text != state.dutyRequiredParts) {
              _dutyPartsController.text = state.dutyRequiredParts;
            }
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              title: Text(
                'متابعة: ${widget.studentName}',
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.steel_blue,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body:
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildDateField(state.date),
                        const SizedBox(height: 16),
                        _buildFollowUpCard(context, state),
                        const SizedBox(height: 16),
                        _buildDutyCard(context, state),
                        const SizedBox(height: 32),
                        // ====================  الكود الجديد ====================
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          title: '📖 الأجزاء المنجزة',
                          child: Center(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.checklist_rtl_rounded),
                              label: const Text('إدارة الأجزاء المنجزة'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CompletedPartsScreen(
                                          studentId: widget.studentId,
                                          studentName: widget.studentName,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (state.isSaving)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed:
                                () => context.read<FollowUpBloc>().add(
                                  SaveFollowUpData(),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.steel_blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'حفظ المتابعة',
                              style: GoogleFonts.tajawal(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
          );
        },
      ),
    );
  }

  Widget _buildDateField(String date) {
    String formattedDate;
    try {
      if (date.isNotEmpty) {
        final parsedDate = DateTime.parse(date);
        formattedDate = DateFormat('EEEE, yyyy-MM-dd', 'ar').format(parsedDate);
      } else {
        formattedDate = DateFormat(
          'EEEE, yyyy-MM-dd',
          'ar',
        ).format(DateTime.now());
      }
    } catch (e) {
      formattedDate = DateFormat(
        'EEEE, yyyy-MM-dd',
        'ar',
      ).format(DateTime.now());
    }

    return _buildSectionCard(
      title: '📅 تاريخ اليوم',
      child: Center(
        child: Text(
          formattedDate,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.night_blue,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpCard(BuildContext context, FollowUpState state) {
    return _buildSectionCard(
      title: '📖 المتابعة اليومية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCountInput(
            label: 'عدد صفحات الحفظ',
            controller: _savedPagesController,
            onChanged:
                (value) =>
                    context.read<FollowUpBloc>().add(SavedPagesChanged(value)),
          ),
          const SizedBox(height: 16),
          Text(
            'تقييم الحفظ:',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: AppColors.night_blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildScoreChips(
            selectedValue: state.memorizationScore,
            onSelected:
                (score) => context.read<FollowUpBloc>().add(
                  MemorizationScoreChanged(score),
                ),
          ),
          const SizedBox(height: 24),
          _buildCountInput(
            label: 'عدد صفحات المراجعة',
            controller: _reviewedPagesController,
            onChanged:
                (value) => context.read<FollowUpBloc>().add(
                  ReviewedPagesChanged(value),
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'تقييم المراجعة:',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: AppColors.night_blue,
            ),
          ),
          const SizedBox(height: 8),
          _buildScoreChips(
            selectedValue: state.reviewScore,
            onSelected:
                (score) =>
                    context.read<FollowUpBloc>().add(ReviewScoreChanged(score)),
          ),
        ],
      ),
    );
  }

  Widget _buildDutyCard(BuildContext context, FollowUpState state) {
    return _buildSectionCard(
      title: '📝 الواجب المطلوب',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCountInput(
                  label: 'من صفحة',
                  controller: _dutyFromController,
                  onChanged:
                      (value) => context.read<FollowUpBloc>().add(
                        DutyFromPageChanged(value),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCountInput(
                  label: 'إلى صفحة',
                  controller: _dutyToController,
                  onChanged:
                      (value) => context.read<FollowUpBloc>().add(
                        DutyToPageChanged(value),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dutyPartsController,
            onChanged:
                (value) => context.read<FollowUpBloc>().add(
                  DutyRequiredPartsChanged(value),
                ),
            style: GoogleFonts.tajawal(),
            decoration: InputDecoration(
              labelText: 'الأجزاء المطلوبة (مثال: عم، تبارك)',
              labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChips({
    required int selectedValue,
    required ValueChanged<int> onSelected,
  }) {
    final scores = {
      'ممتاز جداً': 5,
      'ممتاز': 4,
      'جيد جداً': 3,
      'جيد': 2,
      'ضعيف': 1,
      'إعادة': 0,
    };
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          scores.entries.map((entry) {
            final isSelected = selectedValue == entry.value;
            return ChoiceChip(
              label: Text(entry.key),
              labelStyle: GoogleFonts.tajawal(
                color: isSelected ? Colors.white : AppColors.night_blue,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onSelected(entry.value);
              },
              selectedColor: AppColors.teal_blue,
              backgroundColor: Colors.grey.shade200,
              pressElevation: 0,
            );
          }).toList(),
    );
  }

  Widget _buildCountInput({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.tajawal(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(color: AppColors.night_blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.night_blue,
              ),
            ),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }
}

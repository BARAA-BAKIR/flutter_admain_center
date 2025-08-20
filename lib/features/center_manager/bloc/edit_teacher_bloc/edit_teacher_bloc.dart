// lib/features/center_manager/bloc/edit_teacher_bloc/edit_teacher_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_diatls_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_teacher_event.dart'; // <-- الخطوة 1: استيراد ملف الأحداث
part 'edit_teacher_state.dart'; // <-- الخطوة 1: استيراد ملف الحالات

class EditTeacherBloc extends Bloc<EditTeacherEvent, EditTeacherState> {
  final CenterManagerRepository _repository;

  EditTeacherBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const EditTeacherState()) {
    on<LoadTeacherForEdit>(_onLoadTeacherForEdit);
    on<SubmitTeacherUpdate>(_onSubmitTeacherUpdate);
  }

  // دالة معالجة حدث جلب البيانات
  Future<void> _onLoadTeacherForEdit(
    LoadTeacherForEdit event,
    Emitter<EditTeacherState> emit,
  ) async {
    emit(state.copyWith(status: EditTeacherStatus.loading));
    final result = await _repository.getTeacherDetails(event.teacherId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: EditTeacherStatus.failure,
        errorMessage: failure.message,
      )),
      (teacherData) => emit(state.copyWith(
        status: EditTeacherStatus.success,
        initialData: teacherData,
      )),
    );
  }

  // دالة معالجة حدث إرسال التحديثات
  Future<void> _onSubmitTeacherUpdate(
    SubmitTeacherUpdate event,
    Emitter<EditTeacherState> emit,
  ) async {
    emit(state.copyWith(status: EditTeacherStatus.submitting));
    final result = await _repository.updateTeacherDetails(event.teacherId, event.data);
    result.fold(
      (failure) => emit(state.copyWith(
        status: EditTeacherStatus.failure,
        errorMessage: failure.message,
      )),
      (updatedData) {
        // عند النجاح، أرسل حالة النجاح مع البيانات المحدثة
        emit(state.copyWith(
          status: EditTeacherStatus.success,
          initialData: updatedData,
        ));
      },
    );
  }
}

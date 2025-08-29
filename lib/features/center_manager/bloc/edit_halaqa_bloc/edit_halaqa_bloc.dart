// lib/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/core/error/failures.dart';
import 'package:flutter_admain_center/data/models/center_maneger/add_halaqa_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_selection_model.dart';
import 'package:flutter_admain_center/data/models/center_maneger/teacher_selection_model.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';

part 'edit_halaqa_event.dart';
part 'edit_halaqa_state.dart';

class EditHalaqaBloc extends Bloc<EditHalaqaEvent, EditHalaqaState> {
  final CenterManagerRepository _repository;

  EditHalaqaBloc({required CenterManagerRepository repository})
      : _repository = repository,
        super(const EditHalaqaState()) {
    on<LoadAllEditData>(_onLoadAllEditData);
    on<SelectionChanged>(_onSelectionChanged);
    on<SubmitHalaqaUpdate>(_onSubmitUpdate);
  }

// In lib/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart

Future<void> _onLoadAllEditData(LoadAllEditData event, Emitter<EditHalaqaState> emit) async {
  // 1. إصدار حالة التحميل
  emit(state.copyWith(status: EditHalaqaStatus.loading));

  // 2. جلب كل البيانات بالتوازي
  final results = await Future.wait([
    _repository.getHalaqaForEdit(event.halaqaId),
    _repository.getTeachersForSelection(),
    _repository.getMosquesForSelection(),
    _repository.getHalaqaTypesForSelection(),
  ]);

  // 3. استخراج النتائج بأمان
  final halaqaResult = results[0] as Either<Failure, Map<String, dynamic>>;
  final teachersResult = results[1] as Either<Failure, List<TeacherSelectionModel>>;
  final mosquesResult = results[2] as Either<Failure, List<MosqueSelectionModel>>;
  final typesResult = results[3] as Either<Failure, List<Map<String, dynamic>>>;

  // 4. التحقق من وجود أي خطأ في أي من الطلبات
  String? firstError;
  halaqaResult.fold((f) => firstError = f.message, (r) => null);
  if (firstError == null) teachersResult.fold((f) => firstError = f.message, (r) => null);
  if (firstError == null) mosquesResult.fold((f) => firstError = f.message, (r) => null);
  if (firstError == null) typesResult.fold((f) => firstError = f.message, (r) => null);

  // إذا كان هناك أي خطأ، أصدر حالة الفشل وتوقف
  if (firstError != null) {
    emit(state.copyWith(status: EditHalaqaStatus.failure, errorMessage: firstError));
    return;
  }

  // 5. بما أنه لا يوجد أخطاء، استخرج البيانات الفعلية
  final initialHalaqaData = halaqaResult.getOrElse(() => {});
  final availableTeachers = teachersResult.getOrElse(() => []);
  final availableMosques = mosquesResult.getOrElse(() => []);
  final halaqaTypes = typesResult.getOrElse(() => []);

  // 6. ✅ --- هذا هو الجزء المصحح والمهم --- ✅
  // استخراج الكائنات الفرعية من البيانات الأولية
  final halaqa = initialHalaqaData['halaqa'] as Map<String, dynamic>?;
  final progress = initialHalaqaData['progress'] as Map<String, dynamic>?;

  // التأكد من أن البيانات الأساسية موجودة
  if (halaqa == null) {
    emit(state.copyWith(status: EditHalaqaStatus.failure, errorMessage: 'بيانات الحلقة الأساسية مفقودة.'));
    return;
  }

  // البحث عن القيم الأولية باستخدام الأسماء الصحيحة من الـ JSON
  final initialMosque = availableMosques.firstWhereOrNull((m) => m.id == halaqa['mosque_id']);
  final initialType = halaqaTypes.firstWhereOrNull((t) => t['id'] == halaqa['type']); // <-- تم التصحيح
  final initialTeacher = (progress != null)
      ? availableTeachers.firstWhereOrNull((t) => t.id == progress['teacher_id']) // <-- تم التصحيح
      : null;

  // 7. إصدار حالة النجاح النهائية مع كل البيانات
  emit(state.copyWith(
    status: EditHalaqaStatus.success,
    initialHalaqaData: initialHalaqaData,
    availableTeachers: availableTeachers,
    availableMosques: availableMosques,
    halaqaTypes: halaqaTypes,
    // تعيين القيم المختارة في الحالة ليتم استخدامها في الواجهة
    selectedMosque: initialMosque,
    selectedHalaqaType: initialType,
    selectedTeacher: initialTeacher,
    // استخدم ValueGetter لتمرير null بشكل صريح إذا لم يتم العثور على مشرف
    unselectTeacher: initialTeacher == null,
  ));
}

// In lib/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart

void _onSelectionChanged(SelectionChanged event, Emitter<EditHalaqaState> emit) {
  // هذه الدالة مسؤولة عن تحديث القيم المختارة في الحالة
  emit(state.copyWith(
    selectedMosque: event.selectedMosque,
    selectedHalaqaType: event.selectedHalaqaType,
    selectedTeacher: event.selectedTeacher,
    // إذا تم تمرير unselectTeacher، قم بتعيين الأستاذ إلى null
    unselectTeacher: event.unselectTeacher,
  ));
}


  Future<void> _onSubmitUpdate(SubmitHalaqaUpdate event, Emitter<EditHalaqaState> emit) async {
    emit(state.copyWith(status: EditHalaqaStatus.submitting));
    final result = await _repository.updateHalaqa(event.halaqaId, event.halaqaData);
    result.fold(
      (failure) => emit(state.copyWith(status: EditHalaqaStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: EditHalaqaStatus.success, clearInitialData: true)),
    );
  }
}

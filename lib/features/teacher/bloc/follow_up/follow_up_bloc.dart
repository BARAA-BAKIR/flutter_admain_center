// lib/features/teacher/blocs/follow_up/follow_up_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/data/models/teacher/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/teacher/duty_model.dart';

part 'follow_up_event.dart';
part 'follow_up_state.dart';

class FollowUpBloc extends Bloc<FollowUpEvent, FollowUpState> {
  final TeacherRepository _teacherRepository;
  final int _studentId;
  final int _halaqaId;
  final bool _isEditing;

  FollowUpBloc({
    required TeacherRepository teacherRepository,
    required int studentId,
    required int groupId,
    required bool isEditing,
  })  : _teacherRepository = teacherRepository,
        _studentId = studentId,
        _halaqaId = groupId,
        _isEditing = isEditing,
        super(FollowUpState(date: DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
    on<LoadInitialData>(_onLoadInitialData);
    on<SavedPagesChanged>((event, emit) =>
        emit(state.copyWith(savedPagesCount: int.tryParse(event.count) ?? 0)));
    on<ReviewedPagesChanged>((event, emit) =>
        emit(state.copyWith(reviewedPagesCount: int.tryParse(event.count) ?? 0)));
    on<MemorizationScoreChanged>((event, emit) =>
        emit(state.copyWith(memorizationScore: event.score)));
    on<ReviewScoreChanged>((event, emit) =>
        emit(state.copyWith(reviewScore: event.score)));
    on<DutyFromPageChanged>((event, emit) =>
        emit(state.copyWith(dutyFromPage: int.tryParse(event.value) ?? 0)));
    on<DutyToPageChanged>((event, emit) =>
        emit(state.copyWith(dutyToPage: int.tryParse(event.value) ?? 0)));
    on<DutyRequiredPartsChanged>((event, emit) =>
        emit(state.copyWith(dutyRequiredParts: event.value)));
    on<SaveFollowUpData>(_onSaveFollowUpData);
  }

  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<FollowUpState> emit) async {
    if (_isEditing) {
      emit(state.copyWith(isLoading: true));

      // استخدام fold للتعامل مع نتيجة الـ Repository
      final result = await _teacherRepository.getFollowUpAndDutyForStudent(
        _studentId,
        state.date,
      );

      result.fold(
        // حالة الفشل (Left)
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        // حالة النجاح (Right)
        (data) {
          // 'data' هي الآن Map<String, dynamic>
          final DailyFollowUpModel? followUp = data['followUp'];
          final DutyModel? duty = data['duty'];

          // نقوم بتحديث الحالة بالبيانات التي تم جلبها
          emit(state.copyWith(
            isLoading: false,
            savedPagesCount: followUp?.savedPagesCount,
            reviewedPagesCount: followUp?.reviewedPagesCount,
            memorizationScore: followUp?.memorizationScore,
            reviewScore: followUp?.reviewScore,
            dutyFromPage: duty?.startPage,
            dutyToPage: duty?.endPage,
            dutyRequiredParts: duty?.requiredParts,
          ));
        },
      );
    }
  }

  Future<void> _onSaveFollowUpData(SaveFollowUpData event, Emitter<FollowUpState> emit) async {
    emit(state.copyWith(isSaving: true, error: null, saveStatus: SaveStatus.initial));

    // 1. إنشاء مودل المتابعة من الحالة الحالية للـ BLoC
    final followUpModel = DailyFollowUpModel(
      studentId: _studentId,
      halaqaId: _halaqaId,
      date: state.date,
      savedPagesCount: state.savedPagesCount,
      reviewedPagesCount: state.reviewedPagesCount,
      memorizationScore: state.memorizationScore,
      reviewScore: state.reviewScore,
      attendance: 1, // نفترض أن المستخدم في هذه الشاشة هو حاضر دائماً
    );

    // 2. إنشاء مودل الواجب من الحالة الحالية للـ BLoC
    final dutyModel = DutyModel(
      studentId: _studentId,
      startPage: state.dutyFromPage,
      endPage: state.dutyToPage,
      requiredParts: state.dutyRequiredParts,
    );

    // 3. استدعاء دالة الحفظ في الـ Repository
    final result = await _teacherRepository.storeFollowUpAndDuty(followUpModel, dutyModel);

    // 4. استخدام fold لتحديث حالة الـ BLoC بناءً على نتيجة المزامنة
    result.fold(
      // حالة الفشل (Left)
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          error: 'فشل حفظ البيانات: ${failure.message}',
         // saveStatus: SaveStatus.initial, // أو أي حالة فشل مناسبة
        ));
      },
      // حالة النجاح (Right)
      (wasSynced) {
        // 'wasSynced' هي الآن bool
        emit(state.copyWith(
          isSaving: false,
          saveStatus: wasSynced ? SaveStatus.syncedToServer : SaveStatus.savedLocally,
        ));
      },
    );
  }
}
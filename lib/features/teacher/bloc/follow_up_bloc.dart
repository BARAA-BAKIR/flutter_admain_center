import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/data/models/daily_follow_up_model.dart';
import 'package:flutter_admain_center/data/models/duty_model.dart';

part 'follow_up_event.dart';
part 'follow_up_state.dart';

class FollowUpBloc extends Bloc<FollowUpEvent, FollowUpState> {
  final TeacherRepository _teacherRepository;
  final int _studentId;
  final int _halaqaId;
  final bool _isEditing; // متغير داخلي للاحتفاظ بحالة التعديل

  FollowUpBloc({
    required TeacherRepository teacherRepository,
    required int studentId,
    required int groupId, // نستقبلها كـ groupId لتبقى متوافقة مع الواجهة
    required bool isEditing,
  })  : _teacherRepository = teacherRepository,
        _studentId = studentId,
        _halaqaId = groupId, // نعينها للمتغير الداخلي _halaqaId
        _isEditing = isEditing, // نحفظ حالة التعديل
        super(const FollowUpState(date: '')) { // نستخدم الكونستركتور الافتراضي للحالة
    
    // تسجيل كل معالجات الأحداث
    on<LoadInitialData>(_onLoadInitialData);
    on<SavedPagesChanged>((event, emit) => emit(state.copyWith(savedPagesCount: int.tryParse(event.count) ?? 0)));
    on<ReviewedPagesChanged>((event, emit) => emit(state.copyWith(reviewedPagesCount: int.tryParse(event.count) ?? 0)));
    on<MemorizationScoreChanged>((event, emit) => emit(state.copyWith(memorizationScore: event.score)));
    on<ReviewScoreChanged>((event, emit) => emit(state.copyWith(reviewScore: event.score)));
    on<DutyFromPageChanged>((event, emit) => emit(state.copyWith(dutyFromPage: int.tryParse(event.value) ?? 0)));
    on<DutyToPageChanged>((event, emit) => emit(state.copyWith(dutyToPage: int.tryParse(event.value) ?? 0)));
    on<DutyRequiredPartsChanged>((event, emit) => emit(state.copyWith(dutyRequiredParts: event.value)));
    on<SaveFollowUpData>(_onSaveFollowUpData);
  }

  // =================================================================
  // --- معالج جلب البيانات (تم إصلاحه بالكامل) ---
  // =================================================================
  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<FollowUpState> emit) async {
    // نستخدم المتغير الداخلي _isEditing
    if (_isEditing) {
      emit(state.copyWith(isLoading: true));
      
      // هذه الدالة تجلب من المحلي أولاً، وهو المطلوب
      final data = await _teacherRepository.getFollowUpAndDutyForStudent(
        _studentId,
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

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
    }
    // إذا لم يكن في وضع التعديل (isEditing = false)، لا نفعل شيئاً
    // وتبقى الحالة على قيمها الافتراضية (أصفار ونصوص فارغة)
  }

  // =================================================================
  // --- معالج الحفظ (تم إصلاحه بالكامل) ---
  // =================================================================
  Future<void> _onSaveFollowUpData(SaveFollowUpData event, Emitter<FollowUpState> emit) async {
    emit(state.copyWith(isSaving: true, error: null, saveStatus: SaveStatus.initial));
    
    try {
      // 1. إنشاء مودل المتابعة من الحالة الحالية للـ BLoC
      final followUpModel = DailyFollowUpModel(
        studentId: _studentId,
        halaqaId: _halaqaId,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
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

      // 3. استدعاء دالة الحفظ في الـ Repository واستقبال حالة المزامنة
      final bool wasSynced = await _teacherRepository.storeFollowUpAndDuty(followUpModel, dutyModel);

      // 4. تحديث حالة الـ BLoC بناءً على نتيجة المزامنة
      emit(state.copyWith(
        isSaving: false,
        saveStatus: wasSynced ? SaveStatus.syncedToServer : SaveStatus.savedLocally,
      ));

    } catch (e) {
      emit(state.copyWith(isSaving: false, error: 'فشل حفظ البيانات: ${e.toString()}'));
    }
  }
}

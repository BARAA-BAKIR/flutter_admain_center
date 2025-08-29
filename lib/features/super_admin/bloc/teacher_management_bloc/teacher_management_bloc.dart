import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_filter_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/ending_user_model.dart';
import 'package:flutter_admain_center/data/models/super_admin/teacher_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'teacher_management_event.dart';
part 'teacher_management_state.dart';

class TeacherManagementBloc extends Bloc<TeacherManagementEvent, TeacherManagementState> {
  final SuperAdminRepository _repository;

  TeacherManagementBloc({required SuperAdminRepository repository})
      : _repository = repository,
        super(const TeacherManagementState()) {
    on<FetchApprovedTeachers>(_onFetchApproved);
    on<FetchMoreApprovedTeachers>(_onFetchMoreApproved);
    on<FetchPendingTeachers>(_onFetchPending);
    on<ApproveTeacherRequest>(_onApprove);
    on<RejectTeacherRequest>(_onReject);
    on<PromoteTeacher>(_onPromote);
    on<AddTeacher>(_onAddTeacher);
on<UpdateTeacher>(_onUpdateTeacher);
    on<DeleteTeacher>(_onDeleteTeacher);
    on<FetchPrerequisitesForTeacherForm>(_onFetchPrerequisites);
  }
// Future<void> _onFetchPrerequisites(
//   FetchPrerequisitesForTeacherForm event,
//   Emitter<TeacherManagementState> emit,
// ) async {
//   emit(state.copyWith(isLoadingPrerequisites: true));
//   final centersResult = await _repository.getCentersForFilter();
//   centersResult.fold(
//     (failure) {
//       // Handle error if needed, maybe set an error message in the state
//       emit(state.copyWith(isLoadingPrerequisites: false));
//     },
//     (centers) {
//       emit(state.copyWith(
//         centersList: centers,
//         isLoadingPrerequisites: false,
//       ));
//     },
//   );
// }
Future<void> _onFetchPrerequisites(
  FetchPrerequisitesForTeacherForm event,
  Emitter<TeacherManagementState> emit,
) async {
  emit(state.copyWith(isLoadingPrerequisites: true));
  
  // استدعاء الدالة التي تعيد الآن List<Map<String, dynamic>>
  final centersResult = await _repository.getCentersForFilter();
  
  centersResult.fold(
    (failure) {
      // التعامل مع الخطأ
      emit(state.copyWith(isLoadingPrerequisites: false, formError: failure.message));
    },
    (centersAsMaps) {
      // ✅  الإصلاح الرئيسي هنا: تحويل قائمة الخرائط إلى قائمة موديلات
      try {
        final centersAsModels = centersAsMaps
            .map((json) => CenterFilterModel.fromJson(json))
            .toList();
        
        emit(state.copyWith(
          centersList: centersAsModels, // تمرير قائمة الموديلات
          isLoadingPrerequisites: false,
        ));
      } catch (e) {
        // التعامل مع خطأ التحويل (إذا كان الـ JSON غير صالح)
        emit(state.copyWith(
          isLoadingPrerequisites: false,
          formError: 'خطأ في تحليل بيانات المراكز: $e',
        ));
      }
    },
  );
}
  Future<void> _onFetchApproved(FetchApprovedTeachers event, Emitter<TeacherManagementState> emit) async {
    emit(state.copyWith(approvedStatus: TeacherManagementStatus.loading, currentPage: 1, hasReachedMax: false));
    final result = await _repository.getApprovedTeachers(page: 1, searchQuery: event.searchQuery);
    result.fold(
      (failure) => emit(state.copyWith(approvedStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final teachers = (paginatedData['data'] as List).map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          approvedStatus: TeacherManagementStatus.success,
          approvedTeachers: teachers,
          hasReachedMax: paginatedData['next_page_url'] == null,
          currentPage: paginatedData['current_page'],
        ));
      },
    );
  }

  Future<void> _onFetchMoreApproved(FetchMoreApprovedTeachers event, Emitter<TeacherManagementState> emit) async {
    if (state.hasReachedMax || state.approvedStatus == TeacherManagementStatus.loading) return;

    emit(state.copyWith(approvedStatus: TeacherManagementStatus.loading));
    final nextPage = state.currentPage + 1;
    final result = await _repository.getApprovedTeachers(page: nextPage);

    result.fold(
      (failure) => emit(state.copyWith(approvedStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (paginatedData) {
        final newTeachers = (paginatedData['data'] as List).map((json) => Teacher.fromJson(json)).toList();
        emit(state.copyWith(
          approvedStatus: TeacherManagementStatus.success,
          approvedTeachers: List.of(state.approvedTeachers)..addAll(newTeachers),
          currentPage: paginatedData['current_page'],
          hasReachedMax: paginatedData['next_page_url'] == null,
        ));
      },
    );
  }

  Future<void> _onFetchPending(FetchPendingTeachers event, Emitter<TeacherManagementState> emit) async {
    emit(state.copyWith(pendingStatus: TeacherManagementStatus.loading));
    final result = await _repository.getPendingTeachers();
    result.fold(
      (failure) => emit(state.copyWith(pendingStatus: TeacherManagementStatus.failure, errorMessage: failure.message)),
      (users) => emit(state.copyWith(pendingStatus: TeacherManagementStatus.success, pendingTeachers: users)),
    );
  }
Future<void> _onApprove(ApproveTeacherRequest event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.approveTeacher(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, actionStatus: TeacherActionStatus.failure)),
      (_) {
        // إزالة الطلب من قائمة الانتظار
        final updatedList = List<PendingUser>.from(state.pendingTeachers)..removeWhere((u) => u.id == event.userId);
        emit(state.copyWith(
          pendingTeachers: updatedList, 
          pendingStatus: TeacherManagementStatus.success,
          actionStatus: TeacherActionStatus.success,
          successMessage: 'تمت الموافقة على الأستاذ بنجاح'
        ));
        // ✅ إعادة تحميل قائمة الموافق عليهم لإظهار الأستاذ الجديد
        add(const FetchApprovedTeachers());
      },
    );
  }

  Future<void> _onReject(RejectTeacherRequest event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.rejectTeacher(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, actionStatus: TeacherActionStatus.failure)),
      (_) {
        final updatedList = List<PendingUser>.from(state.pendingTeachers)..removeWhere((u) => u.id == event.userId);
        emit(state.copyWith(
          pendingTeachers: updatedList, 
          pendingStatus: TeacherManagementStatus.success,
          actionStatus: TeacherActionStatus.success,
          successMessage: 'تم رفض الطلب'
        ));
      },
    );
  }

  // ✅ --- إضافة دالة الترقية ---
  Future<void> _onPromote(PromoteTeacher event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.promoteTeacher(teacherId: event.teacherId, newRole: event.newRole);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, actionStatus: TeacherActionStatus.failure)),
      (_) {
        emit(state.copyWith(
          actionStatus: TeacherActionStatus.success,
          successMessage: 'تمت ترقية الأستاذ بنجاح'
        ));
        // يمكنك هنا إزالة الأستاذ من قائمة الموافق عليهم إذا أردت، أو تحديث دوره
        add(const FetchApprovedTeachers());
      }
    );
  }
  // ... (أضف هذه الدوال داخل البلوك)
Future<void> _onAddTeacher(AddTeacher event, Emitter<TeacherManagementState> emit) async {
  emit(state.copyWith(formStatus: FormStatus.submitting, formError: null));
  final result = await _repository.addTeacher(event.data);
  result.fold(
    (failure) => emit(state.copyWith(formStatus: FormStatus.failure, formError: failure.message)),
    (_) {
      emit(state.copyWith(formStatus: FormStatus.success));
      add(const FetchApprovedTeachers()); // لتحديث القائمة تلقائياً
    },
  );
}

Future<void> _onUpdateTeacher(UpdateTeacher event, Emitter<TeacherManagementState> emit) async {
  emit(state.copyWith(formStatus: FormStatus.submitting, formError: null));
  final result = await _repository.updateTeacher(teacherId: event.teacherId, data: event.data);
  result.fold(
    (failure) => emit(state.copyWith(formStatus: FormStatus.failure, formError: failure.message)),
    (_) {
      emit(state.copyWith(formStatus: FormStatus.success));
      add(const FetchApprovedTeachers()); // لتحديث القائمة تلقائياً
    },
  );
}
Future<void> _onDeleteTeacher(DeleteTeacher event, Emitter<TeacherManagementState> emit) async {
    final result = await _repository.deleteTeacher(event.teacherId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message, actionStatus: TeacherActionStatus.failure)),
      (_) {
        final updatedList = List<Teacher>.from(state.approvedTeachers)..removeWhere((t) => t.id == event.teacherId);
        emit(state.copyWith(
          approvedTeachers: updatedList,
          actionStatus: TeacherActionStatus.success,
          successMessage: 'تم حذف الأستاذ بنجاح'
        ));
      },
    );
  }
}

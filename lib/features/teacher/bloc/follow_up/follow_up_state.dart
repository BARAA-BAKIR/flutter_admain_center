// // lib/features/teacher/bloc/follow_up_state.dart
// part of 'follow_up_bloc.dart';
// enum FollowUpStatus { initial, loading, success, failure, submitting }

// class FollowUpState {
//   final int savedPagesCount;
//   final int reviewedPagesCount;
//   final int memorizationScore;
//   final int reviewScore;
//   final bool isLoading;
//   final bool isSaving;
//   final String? error;
//   final bool saveSuccess;
//    final FollowUpStatus status;

// final int dutyFromPage;
//   final int dutyToPage;
//   final String dutyRequiredParts;

//   const FollowUpState({
//     this.savedPagesCount = 0,
//     this.reviewedPagesCount = 0,
//     this.memorizationScore = 3, // قيمة افتراضية في منتصف السلايدر
//     this.reviewScore = 3, // قيمة افتراضية في منتصف السلايدر
//     this.isLoading = false,
//     this.isSaving = false,
//     this.error,
//     this.saveSuccess = false,
//     this.status = FollowUpStatus.initial,

//     this.dutyFromPage = 0,
//     this.dutyToPage = 0,
//     this.dutyRequiredParts = '',
//   });

//   FollowUpState copyWith({
//     int? savedPagesCount,
//     int? reviewedPagesCount,
//     int? memorizationScore,
//     int? reviewScore,
//     bool? isLoading,
//     bool? isSaving,
//     String? error,
//     bool? saveSuccess,
//      int? dutyFromPage,
//     int? dutyToPage,
//     String? dutyRequiredParts,
//     FollowUpStatus? status,
//   }) {
//     return FollowUpState(
//       savedPagesCount: savedPagesCount ?? this.savedPagesCount,
//       reviewedPagesCount: reviewedPagesCount ?? this.reviewedPagesCount,
//       memorizationScore: memorizationScore ?? this.memorizationScore,
//       reviewScore: reviewScore ?? this.reviewScore,
//       isLoading: isLoading ?? this.isLoading,
//       isSaving: isSaving ?? this.isSaving,
//       error: error,
//       saveSuccess: saveSuccess ?? this.saveSuccess,
//       status: status ?? this.status,

//       dutyFromPage: dutyFromPage ?? this.dutyFromPage,
//       dutyToPage: dutyToPage ?? this.dutyToPage,
//       dutyRequiredParts: dutyRequiredParts ?? this.dutyRequiredParts,
//     );
//   }
// }
// lib/features/teacher/bloc/follow_up_state.dart
part of 'follow_up_bloc.dart';

enum SaveStatus { initial, savedLocally, syncedToServer }

class FollowUpState {
  final bool isLoading;
  final bool isSaving;
  final bool saveSuccess;
  final String? error;
  final SaveStatus saveStatus;
  // بيانات المتابعة
  final int savedPagesCount;
  final int reviewedPagesCount;
  final int memorizationScore; // 0-5
  final int reviewScore; // 0-5
  // بيانات الواجب
  final int dutyFromPage;
  final int dutyToPage;
  final String dutyRequiredParts;
  final String date;
  const FollowUpState({
    this.isLoading = false,
    this.isSaving = false,
    this.saveSuccess = false,
    this.error,
    this.saveStatus = SaveStatus.initial,
    this.savedPagesCount = 0,
    this.reviewedPagesCount = 0,
    this.memorizationScore = 4, // ممتاز
    this.reviewScore = 4, // ممتاز
    this.dutyFromPage = 0,
    this.dutyToPage = 0,
    this.dutyRequiredParts = '',
    required this.date,
  });
  factory FollowUpState.initial() {
    return FollowUpState(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }
  FollowUpState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? saveSuccess,
    String? error,
    SaveStatus? saveStatus,
    int? savedPagesCount,
    int? reviewedPagesCount,
    int? memorizationScore,
    int? reviewScore,
    int? dutyFromPage,
    int? dutyToPage,
    String? dutyRequiredParts,
  }) {
    return FollowUpState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      error: error,
      saveStatus: saveStatus ?? this.saveStatus,
      savedPagesCount: savedPagesCount ?? this.savedPagesCount,
      reviewedPagesCount: reviewedPagesCount ?? this.reviewedPagesCount,
      memorizationScore: memorizationScore ?? this.memorizationScore,
      reviewScore: reviewScore ?? this.reviewScore,
      dutyFromPage: dutyFromPage ?? this.dutyFromPage,
      dutyToPage: dutyToPage ?? this.dutyToPage,
      dutyRequiredParts: dutyRequiredParts ?? this.dutyRequiredParts,
      date: date,
    );
  }
}

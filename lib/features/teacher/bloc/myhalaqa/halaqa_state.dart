// في lib/features/teacher/bloc/myhalaqa/halaqa_state.dart
part of 'halaqa_bloc.dart';

class HalaqaState extends Equatable {
  final bool noHalaqaAssigned;
  final bool isLoading;
  final String? error;
  final MyhalaqaModel? halaqa;
  final bool isRefreshing;

  const HalaqaState({
    this.isLoading = false,
    this.noHalaqaAssigned = false,
    this.error,
    this.halaqa,
    this.isRefreshing = false,
  });

  // ====================  هنا هو الحل الكامل والنهائي ====================
  HalaqaState copyWith({
    bool? isLoading,
    // استخدمنا كائنًا خاصًا للسماح بمسح الخطأ
    ValueGetter<String?>? error, 
    // استخدمنا كائنًا خاصًا للسماح بتعيين الحلقة إلى null
    ValueGetter<MyhalaqaModel?>? halaqa, 
    bool? noHalaqaAssigned,
    bool? isRefreshing,
  }) {
    return HalaqaState(
      isLoading: isLoading ?? this.isLoading,
      // إذا تم تمرير `error`، استخدم قيمته (حتى لو كانت null)، وإلا احتفظ بالقيمة القديمة
      error: error != null ? error() : this.error,
      // إذا تم تمرير `halaqa`، استخدم قيمته (حتى لو كانت null)، وإلا احتفظ بالقيمة القديمة
      halaqa: halaqa != null ? halaqa() : this.halaqa,
      noHalaqaAssigned: noHalaqaAssigned ?? this.noHalaqaAssigned,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
  // =====================================================================

  @override
  List<Object?> get props => [halaqa, isLoading, error, noHalaqaAssigned, isRefreshing];
}

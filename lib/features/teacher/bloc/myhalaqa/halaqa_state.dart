part of 'halaqa_bloc.dart';

// الحالة الآن ستحتوي على كائن الحلقة كاملاً

class HalaqaState  {
final bool noHalaqaAssigned;
  final bool isLoading;
  final String? error;
  final MyhalaqaModel? halaqa; // كائن الحلقة كاملاً
  final bool isRefreshing; // حالة التحديث
  const HalaqaState({
    this.isLoading = false,
    this.noHalaqaAssigned=false,
    this.error,
    this.halaqa,
    this.isRefreshing = false, // حالة التحديث
  });

  // دالة لنسخ الحالة وتحديثها بسهولة
  HalaqaState copyWith({
    bool? isLoading,
    String? error,
    MyhalaqaModel? halaqa,
bool? noHalaqaAssigned,
    bool? isRefreshing, // حالة التحديث
  }) {
    return HalaqaState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      halaqa: halaqa ?? this.halaqa,
       noHalaqaAssigned: noHalaqaAssigned ?? this.noHalaqaAssigned, // <-- تحديث القيمة
     
      isRefreshing: isRefreshing ?? this.isRefreshing, // حالة التحديث
    );
  }

  List<Object?> get props => [isLoading, error, halaqa , isRefreshing];
}

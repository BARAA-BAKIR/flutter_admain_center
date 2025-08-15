part of 'halaqa_details_bloc.dart';

enum HalaqaDetailsStatus { initial, loading, success, failure }

class HalaqaDetailsState extends Equatable {
  final HalaqaDetailsStatus status;
  final Halaqa? halaqa;
  final String? errorMessage;

  const HalaqaDetailsState({
    this.status = HalaqaDetailsStatus.initial,
    this.halaqa,
    this.errorMessage,
  });

  //  تصحيح نوع المعلمة هنا
  HalaqaDetailsState copyWith({
    HalaqaDetailsStatus? status,
    Halaqa? halaqa, //  يجب أن تكون Halaqa? لتطابق الحقل في الكلاس
    String? errorMessage,
  }) {
    return HalaqaDetailsState(
      status: status ?? this.status,
      halaqa: halaqa ?? this.halaqa,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, halaqa, errorMessage];
}

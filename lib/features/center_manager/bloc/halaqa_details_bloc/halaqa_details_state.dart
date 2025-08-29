// In lib/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_state.dart

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

// In lib/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_state.dart

HalaqaDetailsState copyWith({
  HalaqaDetailsStatus? status,
  Halaqa? halaqa,
  String? errorMessage,
}) {
  // هذا هو المنطق الذي يجب أن يكون.
  // إذا لم يتم تمرير `halaqa`، فإن `this.halaqa` سيستخدم.
  // إذا تم تمرير `halaqa`، فإن القيمة الجديدة ستستخدم.
  // المشكلة ليست هنا، بل في المحلل.
  // لذا، سنقوم بالتحويل الصريح في الـ BLoC.
  return HalaqaDetailsState(
    status: status ?? this.status,
    halaqa: halaqa ?? this.halaqa,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

  @override
  List<Object?> get props => [status, halaqa, errorMessage];
}

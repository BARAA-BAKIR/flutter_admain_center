// lib/features/teacher/blocs/halaqa_info/halaqa_info_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/data/models/teacher/halaqa_model.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:meta/meta.dart';

part 'halaqa_info_event.dart';
part 'halaqa_info_state.dart';

class HalaqaInfoBloc extends Bloc<HalaqaInfoEvent, HalaqaInfoState> {
  final TeacherRepository halaqaRepository;

  HalaqaInfoBloc({required this.halaqaRepository}) : super(HalaqaInfoInitial()) {
    on<FetchHalaqaInfo>((event, emit) async {
      emit(HalaqaInfoLoading());

      // استخدام fold للتعامل مع النتيجة
      final result = await halaqaRepository.fetchHalaqaInfo(event.halaqaId);
      
      result.fold(
        // حالة الفشل (Left)
        (failure) {
          emit(HalaqaInfoFailure(errorMessage: failure.message));
        },
        // حالة النجاح (Right)
        (halaqaData) {
          emit(HalaqaInfoSuccess(halaqaData: halaqaData));
        },
      );
    });
  }
}
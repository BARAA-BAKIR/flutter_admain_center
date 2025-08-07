part of 'halaqa_info_bloc.dart';


abstract class HalaqaInfoState {}

class HalaqaInfoInitial extends HalaqaInfoState {}

class HalaqaInfoLoading extends HalaqaInfoState {}

class HalaqaInfoSuccess extends HalaqaInfoState {
  final HalaqaModel halaqaData; 

  HalaqaInfoSuccess({required this.halaqaData});
}

class HalaqaInfoFailure extends HalaqaInfoState {
  final String errorMessage;

  HalaqaInfoFailure({required this.errorMessage});
}

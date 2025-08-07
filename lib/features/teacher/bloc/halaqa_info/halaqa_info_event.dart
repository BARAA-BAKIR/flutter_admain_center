part of 'halaqa_info_bloc.dart';

@immutable
abstract class HalaqaInfoEvent {}

class FetchHalaqaInfo extends HalaqaInfoEvent {
  final int halaqaId;

  FetchHalaqaInfo({required this.halaqaId});
}

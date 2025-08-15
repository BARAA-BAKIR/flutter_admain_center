part of 'halaqa_details_bloc.dart';

abstract class HalaqaDetailsEvent extends Equatable {
  const HalaqaDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchHalaqaDetails extends HalaqaDetailsEvent {
  final int halaqaId;
  const FetchHalaqaDetails(this.halaqaId);
}

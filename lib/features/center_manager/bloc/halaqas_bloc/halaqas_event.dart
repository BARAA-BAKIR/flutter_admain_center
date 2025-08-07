part of 'halaqas_bloc.dart';

abstract class HalaqasEvent extends Equatable {
  const HalaqasEvent();
  @override
  List<Object?> get props => [];
}

class FetchHalaqas extends HalaqasEvent {
  final String? searchQuery;
  const FetchHalaqas({this.searchQuery});
}

class FetchMoreHalaqas extends HalaqasEvent {}
class DeleteHalaqa extends HalaqasEvent {
  final int halaqaId;
  const DeleteHalaqa(this.halaqaId);
}
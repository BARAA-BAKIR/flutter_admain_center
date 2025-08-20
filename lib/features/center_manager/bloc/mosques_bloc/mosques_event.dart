part of 'mosques_bloc.dart';

abstract class MosquesEvent extends Equatable {
  const MosquesEvent();
  @override
  List<Object> get props => [];
}

class FetchMosques extends MosquesEvent {
  final String? searchQuery;
  const FetchMosques({this.searchQuery});
}

class FetchMoreMosques extends MosquesEvent {}
class DeleteMosque extends MosquesEvent {
  final int mosqueId;
  const DeleteMosque(this.mosqueId);
}
class UpdateMosqueInList extends MosquesEvent {
  final Mosque updatedMosque;
  const UpdateMosqueInList(this.updatedMosque);
}

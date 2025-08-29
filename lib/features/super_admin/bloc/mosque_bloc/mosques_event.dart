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

// ✅ الأحداث الجديدة
class AddMosque extends MosquesEvent {
  final Map<String, dynamic> data;
  const AddMosque(this.data);
}

class UpdateMosque extends MosquesEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateMosque(this.id, this.data);
}

class DeleteMosque extends MosquesEvent {
  final int id;
  const DeleteMosque(this.id);
}

part of 'centers_bloc.dart';

abstract class CentersEvent extends Equatable {
  const CentersEvent();
  @override
  List<Object?> get props => [];
}

// Fetch the first page of centers
class FetchCenters extends CentersEvent {
  final String? searchQuery;
  const FetchCenters({this.searchQuery});
}

// Fetch more centers for pagination
class FetchMoreCenters extends CentersEvent {}

// Delete a center
class DeleteCenter extends CentersEvent {
  final int centerId;
  const DeleteCenter(this.centerId);
}

part of 'edit_mosque_bloc.dart';

abstract class EditMosqueEvent extends Equatable {
  const EditMosqueEvent();
  @override
  List<Object> get props => [];
}

class EditMosqueSubmitted extends EditMosqueEvent {
  final int mosqueId;
  final Map<String, dynamic> mosqueData;

  const EditMosqueSubmitted(this.mosqueId, this.mosqueData);

  @override
  List<Object> get props => [mosqueId, mosqueData];
}

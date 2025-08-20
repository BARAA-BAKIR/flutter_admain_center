part of 'create_mosque_bloc.dart';

abstract class CreateMosqueEvent extends Equatable {
  const CreateMosqueEvent();
  @override
  List<Object> get props => [];
}

class CreateMosqueSubmitted extends CreateMosqueEvent {
  final Map<String, dynamic> mosqueData;
  const CreateMosqueSubmitted(this.mosqueData);
}

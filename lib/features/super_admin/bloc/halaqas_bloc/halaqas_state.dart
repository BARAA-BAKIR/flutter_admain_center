part of 'halaqas_bloc.dart';

@immutable
abstract class HalaqasState extends Equatable {
  const HalaqasState();
  @override
  List<Object> get props => [];
}

class HalaqasInitial extends HalaqasState {}
class HalaqasLoading extends HalaqasState {}
class HalaqasLoaded extends HalaqasState {
  final List<HalaqaModel> halaqas;
  const HalaqasLoaded(this.halaqas);
  @override
  List<Object> get props => [halaqas];
}
class HalaqasError extends HalaqasState {
  final String message;
  const HalaqasError(this.message);
  @override
  List<Object> get props => [message];
}

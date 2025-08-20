part of 'filter_data_bloc.dart';

abstract class FilterDataEvent extends Equatable {
  const FilterDataEvent();
  @override
  List<Object> get props => [];
}

class LoadFilterData extends FilterDataEvent {}

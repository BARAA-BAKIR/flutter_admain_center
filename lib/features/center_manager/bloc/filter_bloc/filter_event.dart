part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
  @override
  List<Object> get props => [];
}

// حدث لجلب بيانات الفلاتر (الحلقات والمراحل) من الـ API
class LoadFilterData extends FilterEvent {}

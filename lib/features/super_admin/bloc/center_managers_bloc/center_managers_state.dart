
part of 'center_managers_bloc.dart';

abstract class CenterManagersState extends Equatable {
  const CenterManagersState();

  @override
  List<Object> get props => [];
}

class CenterManagersInitial extends CenterManagersState {}

class CenterManagersLoading extends CenterManagersState {}

class CenterManagersLoaded extends CenterManagersState {
  final List<CenterManagerModel> managers;
  final bool isSearching; // ✅ أضف هذا المتغير

  const CenterManagersLoaded(this.managers, {this.isSearching = false});

  // دالة مساعدة لنسخ الحالة
  CenterManagersLoaded copyWith({
    List<CenterManagerModel>? managers,
    bool? isSearching,
  }) {
    return CenterManagersLoaded(
      managers ?? this.managers,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [managers, isSearching];
}

class CenterManagersError extends CenterManagersState {
  final String message;

  const CenterManagersError(this.message);

  @override
  List<Object> get props => [message];
}
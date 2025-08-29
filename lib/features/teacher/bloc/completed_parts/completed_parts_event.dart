// In lib/features/teacher/bloc/completed_parts/completed_parts_event.dart
part of 'completed_parts_bloc.dart';

abstract class CompletedPartsEvent extends Equatable {
  const CompletedPartsEvent();
  @override
  List<Object> get props => [];
}

class LoadStudentParts extends CompletedPartsEvent {
  final int studentId;
  const LoadStudentParts(this.studentId);
}

class TogglePartSelection extends CompletedPartsEvent {
  final int partId;
  const TogglePartSelection(this.partId);
}

class SyncCompletedParts extends CompletedPartsEvent {
  final int studentId;
  const SyncCompletedParts(this.studentId);
}

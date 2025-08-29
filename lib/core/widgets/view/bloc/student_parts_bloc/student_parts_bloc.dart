// // lib/features/common/bloc/student_parts_bloc/student_parts_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:flutter_admain_center/data/models/part_model.dart';
// import 'package:flutter_admain_center/data/models/parts_completed_model.dart';
// import 'package:flutter_admain_center/data/repositories/student_repository.dart';

// part 'student_parts_event.dart';
// part 'student_parts_state.dart';

// class StudentPartsBloc extends Bloc<StudentPartsEvent, StudentPartsState> {
//   final StudentRepository repository;

//   StudentPartsBloc({required this.repository}) : super(StudentPartsInitial()) {
//     on<LoadStudentParts>(_onLoadStudentParts);
//     on<AddCompletedPart>(_onAddCompletedPart);
//     on<RemoveCompletedPart>(_onRemoveCompletedPart);
//     on<LoadParts>(_onLoadParts);
//   }

//   Future<void> _onLoadStudentParts(
//     LoadStudentParts event,
//     Emitter<StudentPartsState> emit,
//   ) async {
//     emit(StudentPartsLoading());
//     try {
//       final parts = await repository.getStudentCompletedParts(event.studentId);
//       emit(StudentPartsLoaded(parts));
//     } catch (e) {
//       emit(StudentPartsError(e.toString()));
//     }
//   }

//   Future<void> _onAddCompletedPart(
//     AddCompletedPart event,
//     Emitter<StudentPartsState> emit,
//   ) async {
//     try {
//       await repository.addCompletedPart(event.studentId, event.partId);
//       add(LoadStudentParts(event.studentId));
//     } catch (e) {
//       emit(StudentPartsError(e.toString()));
//     }
//   }

//   Future<void> _onRemoveCompletedPart(
//     RemoveCompletedPart event,
//     Emitter<StudentPartsState> emit,
//   ) async {
//     try {
//       await repository.removeCompletedPart(event.studentId, event.partId);
//       add(LoadStudentParts(event.studentId));
//     } catch (e) {
//       emit(StudentPartsError(e.toString()));
//     }
//   }

//   Future<void> _onLoadParts(
//     LoadParts event,
//     Emitter<StudentPartsState> emit,
//   ) async {
//     try {
//       final parts = await repository.getParts();
//       emit(PartsLoaded(parts));
//     } catch (e) {
//       emit(StudentPartsError(e.toString()));
//     }
//   }
// }
// // lib/features/common/bloc/student_progress_bloc/student_progress_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:flutter_admain_center/data/models/student_progress_model.dart';
// import 'package:flutter_admain_center/data/models/student_progress_stage_model.dart';
// import 'package:flutter_admain_center/data/models/halaqa_model.dart';
// import 'package:flutter_admain_center/data/repositories/student_repository.dart';

// part 'student_progress_event.dart';
// part 'student_progress_state.dart';

// class StudentProgressBloc extends Bloc<StudentProgressEvent, StudentProgressState> {
//   final StudentRepository repository;

//   StudentProgressBloc({required this.repository}) : super(StudentProgressInitial()) {
//     on<LoadStudentProgress>(_onLoadStudentProgress);
//     on<UpdateStudentProgress>(_onUpdateStudentProgress);
//     on<LoadProgressStages>(_onLoadProgressStages);
//     on<LoadHalaqats>(_onLoadHalaqats);
//   }

//   Future<void> _onLoadStudentProgress(
//     LoadStudentProgress event,
//     Emitter<StudentProgressState> emit,
//   ) async {
//     emit(StudentProgressLoading());
//     try {
//       final progress = await repository.getStudentProgress(event.studentId);
//       emit(StudentProgressLoaded(progress));
//     } catch (e) {
//       emit(StudentProgressError(e.toString()));
//     }
//   }

//   Future<void> _onUpdateStudentProgress(
//     UpdateStudentProgress event,
//     Emitter<StudentProgressState> emit,
//   ) async {
//     try {
//       await repository.updateStudentProgress(
//         event.studentId,
//         event.levelId,
//         event.groupId,
//         event.entryDate,
//         event.graduationDate,
//       );
//       add(LoadStudentProgress(event.studentId));
//     } catch (e) {
//       emit(StudentProgressError(e.toString()));
//     }
//   }

//   Future<void> _onLoadProgressStages(
//     LoadProgressStages event,
//     Emitter<StudentProgressState> emit,
//   ) async {
//     try {
//       final stages = await repository.getProgressStages();
//       emit(ProgressStagesLoaded(stages));
//     } catch (e) {
//       emit(StudentProgressError(e.toString()));
//     }
//   }

//   Future<void> _onLoadHalaqats(
//     LoadHalaqats event,
//     Emitter<StudentProgressState> emit,
//   ) async {
//     try {
//       final halaqats = await repository.getHalaqats();
//       emit(HalaqatsLoaded(halaqats));
//     } catch (e) {
//       emit(StudentProgressError(e.toString()));
//     }
//   }
// }
// class EditTeacherBloc extends Bloc<EditTeacherEvent, EditTeacherState> {
//   // ...
//   on<LoadTeacherForEdit>((event, emit) async {
//     emit(state.copyWith(status: EditTeacherStatus.loading));
//     final result = await _repository.getTeacherDetails(event.teacherId);
//     result.fold(
//       (f) => emit(state.copyWith(status: EditTeacherStatus.failure, errorMessage: f.message)),
//       (data) => emit(state.copyWith(status: EditTeacherStatus.success, initialData: data)),
//     );
//   });

//   on<SubmitTeacherUpdate>((event, emit) async {
//     emit(state.copyWith(status: EditTeacherStatus.submitting));
//     final result = await _repository.updateTeacherDetails(event.teacherId, event.data);
//     result.fold(
//       (f) => emit(state.copyWith(status: EditTeacherStatus.failure, errorMessage: f.message)),
//       (updatedData) {
//         // أرسل النجاح مع البيانات المحدثة
//         emit(state.copyWith(status: EditTeacherStatus.success, initialData: updatedData));
//       },
//     );
//   });
// }

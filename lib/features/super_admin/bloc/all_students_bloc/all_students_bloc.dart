import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/center_maneger/student_list_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// استورد الـ Repository الخاص بالمدير العام

part 'all_students_event.dart';
part 'all_students_state.dart';

class AllStudentsBloc extends Bloc<AllStudentsEvent, AllStudentsState> {
  final SuperAdminRepository superAdminRepository;

  AllStudentsBloc({required this.superAdminRepository}) : super(const AllStudentsState()) {
    on<FetchAllStudents>(_onFetchAllStudents);
    on<FetchMoreAllStudents>(_onFetchMoreAllStudents);
  }

  Future<void> _onFetchAllStudents(FetchAllStudents event, Emitter<AllStudentsState> emit) async {
    emit(state.copyWith(status: AllStudentsStatus.loading, hasReachedMax: false, currentPage: 1));
    // final result = await superAdminRepository.getAllStudents(page: 1, searchQuery: event.searchQuery);
    // ... (نفس منطق معالجة النتائج في StudentsBloc)
  }

  Future<void> _onFetchMoreAllStudents(FetchMoreAllStudents event, Emitter<AllStudentsState> emit) async {
    if (state.hasReachedMax || state.status == AllStudentsStatus.loading) return;
    // ... (نفس منطق جلب المزيد من البيانات)
  }
}

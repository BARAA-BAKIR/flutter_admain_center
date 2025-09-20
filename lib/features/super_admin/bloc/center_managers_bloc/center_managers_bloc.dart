import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_manager.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'center_managers_event.dart';
part 'center_managers_state.dart';

class CenterManagersBloc extends Bloc<CenterManagersEvent, CenterManagersState> {
  final SuperAdminRepository repository;

  CenterManagersBloc({required this.repository}) : super(CenterManagersInitial()) {
    on<LoadCenterManagers>(_onLoad);
    on<AddCenterManager>(_onAdd);
    on<UpdateCenterManager>(_onUpdate);
    on<DeleteCenterManager>(_onDelete);
  }

  // في ملف center_managers_bloc.dart

Future<void> _onLoad(LoadCenterManagers event, Emitter<CenterManagersState> emit) async {
  // في حالة البحث، لا نريد أن نعرض شاشة تحميل كاملة،
  // بل نبقي على البيانات القديمة ونعرض مؤشر تحميل صغير.
  // لذلك، سنتحقق من الحالة الحالية.
  final currentState = state;
  if (currentState is CenterManagersLoaded) {
    // إذا كنا نبحث، نصدر حالة جديدة مع isSearching = true
    emit(currentState.copyWith(isSearching: true));
  } else {
    // إذا كانت هذه هي المرة الأولى للتحميل، نعرض شاشة تحميل كاملة
    emit(CenterManagersLoading());
  }

  // ✅ الإصلاح: قم بتمرير قيمة البحث من الحدث إلى الريبو
  final result = await repository.getCenterManagers(searchQuery: event.searchQuery);

  result.fold(
    (failure) => emit(CenterManagersError(failure.message)),
    (managers) => emit(CenterManagersLoaded(managers)),
  );
}


  Future<void> _onAdd(AddCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.addCenterManager(event.data);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }

  Future<void> _onUpdate(UpdateCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.updateCenterManager(id: event.id, data: event.data);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }

  Future<void> _onDelete(DeleteCenterManager event, Emitter<CenterManagersState> emit) async {
    final result = await repository.deleteCenterManager(event.id);
    result.fold(
      (failure) { /* Handle error */ },
      (_) => add(LoadCenterManagers()),
    );
  }
}

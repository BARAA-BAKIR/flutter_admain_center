// // lib/features/super_admin/bloc/halaqa_types_bloc/halaqa_types_bloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

// part 'halaqa_types_event.dart';
// part 'halaqa_types_state.dart';

// class HalaqaTypesBloc extends Bloc<HalaqaTypesEvent, HalaqaTypesState> {
//   final SuperAdminRepository repository;

//   HalaqaTypesBloc({required this.repository}) : super(HalaqaTypesInitial()) {
//     on<LoadHalaqaTypes>(_onLoadHalaqaTypes);
//     on<AddHalaqaType>(_onAddHalaqaType);
//     on<UpdateHalaqaType>(_onUpdateHalaqaType);
//     on<DeleteHalaqaType>(_onDeleteHalaqaType);
//   }

//   Future<void> _onLoadHalaqaTypes(
//     LoadHalaqaTypes event,
//     Emitter<HalaqaTypesState> emit,
//   ) async {
//     emit(HalaqaTypesLoading());
//     try {
//       final types = await repository.getHalaqaTypes();
//       emit(HalaqaTypesLoaded(types as List<HalaqaType>));
//     } catch (e) {
//       emit(HalaqaTypesError(e.toString()));
//     }
//   }

//   Future<void> _onAddHalaqaType(
//     AddHalaqaType event,
//     Emitter<HalaqaTypesState> emit,
//   ) async {
//     try {
//       await repository.addHalaqaType(event.name);
//       add(LoadHalaqaTypes());
//     } catch (e) {
//       emit(HalaqaTypesError(e.toString()));
//     }
//   }

//   Future<void> _onUpdateHalaqaType(
//     UpdateHalaqaType event,
//     Emitter<HalaqaTypesState> emit,
//   ) async {
//     try {
//       await repository.updateHalaqaType(event.id, event.name);
//       add(LoadHalaqaTypes());
//     } catch (e) {
//       emit(HalaqaTypesError(e.toString()));
//     }
//   }

//   Future<void> _onDeleteHalaqaType(
//     DeleteHalaqaType event,
//     Emitter<HalaqaTypesState> emit,
//   ) async {
//     try {
//       await repository.deleteHalaqaType(event.id);
//       add(LoadHalaqaTypes());
//     } catch (e) {
//       emit(HalaqaTypesError(e.toString()));
//     }
//   }
// }
// halaqa_types_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_type_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';

part 'halaqa_types_event.dart';
part 'halaqa_types_state.dart';

class HalaqaTypesBloc extends Bloc<HalaqaTypesEvent, HalaqaTypesState> {
  final SuperAdminRepository repository;

  HalaqaTypesBloc({required this.repository}) : super(HalaqaTypesInitial()) {
    on<LoadHalaqaTypes>(_onLoadHalaqaTypes);
    on<AddHalaqaType>(_onAddHalaqaType);
    on<UpdateHalaqaType>(_onUpdateHalaqaType);
    on<DeleteHalaqaType>(_onDeleteHalaqaType);
  }

  Future<void> _onLoadHalaqaTypes(
    LoadHalaqaTypes event,
    Emitter<HalaqaTypesState> emit,
  ) async {
    emit(HalaqaTypesLoading());
    final result = await repository.getHalaqaTypes();
    result.fold(
      (failure) => emit(HalaqaTypesError(failure.message)),
      (types) => emit(HalaqaTypesLoaded(types)),
    );
  }

  Future<void> _onAddHalaqaType(
    AddHalaqaType event,
    Emitter<HalaqaTypesState> emit,
  ) async {
    emit(HalaqaTypesLoading());
    final result = await repository.addHalaqaType(event.name);
    result.fold(
      (failure) => emit(HalaqaTypesError(failure.message)),
      (_) => add(LoadHalaqaTypes()),
    );
  }

  Future<void> _onUpdateHalaqaType(
    UpdateHalaqaType event,
    Emitter<HalaqaTypesState> emit,
  ) async {
    emit(HalaqaTypesLoading());
    final result = await repository.updateHalaqaType(event.id, event.name);
    result.fold(
      (failure) => emit(HalaqaTypesError(failure.message)),
      (_) => add(LoadHalaqaTypes()),
    );
  }

  Future<void> _onDeleteHalaqaType(
    DeleteHalaqaType event,
    Emitter<HalaqaTypesState> emit,
  ) async {
    emit(HalaqaTypesLoading());
    final result = await repository.deleteHalaqaType(event.id);
    result.fold(
      (failure) => emit(HalaqaTypesError(failure.message)),
      (_) => add(LoadHalaqaTypes()),
    );
  }
}
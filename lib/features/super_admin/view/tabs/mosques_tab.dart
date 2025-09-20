// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
// import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/mosque_bloc/mosques_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MosquesTab extends StatelessWidget {
//   const MosquesTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => MosquesBloc(
//         repository: context.read<SuperAdminRepository>(),
//       ),
//       child: const MosquesView(),
//     );
//   }
// }

// class MosquesView extends StatefulWidget {
//   const MosquesView({super.key});

//   @override
//   State<MosquesView> createState() => _MosquesViewState();
// }

// class _MosquesViewState extends State<MosquesView> {
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     context.read<MosquesBloc>().add(const FetchMosques());
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (!_scrollController.hasClients) return;
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       context.read<MosquesBloc>().add(FetchMoreMosques());
//     }
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       context.read<MosquesBloc>().add(FetchMosques(searchQuery: query));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SearchAndFilterBar(
//             onSearchChanged: _onSearchChanged,
//             hintText: 'ابحث عن مسجد أو مركز...',
//           ),
//           Expanded(
//             child: BlocBuilder<MosquesBloc, MosquesState>(
//               builder: (context, state) {
//                 if (state.status == MosquesStatus.loading && state.mosques.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state.status == MosquesStatus.failure && state.mosques.isEmpty) {
//                   return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
//                 }
//                 if (state.mosques.isEmpty) {
//                   return const Center(child: Text('لا توجد مساجد لعرضها.'));
//                 }
//                 return RefreshIndicator(
//                   onRefresh: () async => context.read<MosquesBloc>().add(const FetchMosques()),
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount: state.hasReachedMax ? state.mosques.length : state.mosques.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index >= state.mosques.length) {
//                         return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
//                       }
//                       final mosque = state.mosques[index];
//                       return ListItemTile(
//                         icon: const Icon(Icons.mosque_rounded),
//                         title: mosque.name,
//                         subtitle: 'المركز: ${mosque.centerName ?? 'غير محدد'} - العنوان: ${mosque.address}',
//                         onMoreTap: () {
//                           // TODO: Show Edit/Delete options
//                         },
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Navigate to Add Mosque Screen
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/super_admin/mosque_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/mosque_bloc/mosques_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/add_edit_mosque_screen.dart'; // ✅ استيراد الشاشة الجديدة
import 'package:flutter_bloc/flutter_bloc.dart';

class MosquesTab extends StatelessWidget {
  const MosquesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MosquesBloc(repository: context.read<SuperAdminRepository>())
                ..add(const FetchMosques()), // ✅ طلب البيانات عند إنشاء البلوك
      child: const MosquesView(),
    );
  }
}

class MosquesView extends StatefulWidget {
  const MosquesView({super.key});

  @override
  State<MosquesView> createState() => _MosquesViewState();
}

class _MosquesViewState extends State<MosquesView> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<MosquesBloc>().add(FetchMoreMosques());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MosquesBloc>().add(FetchMosques(searchQuery: query));
    });
  }

  // ✅ دالة للانتقال إلى شاشة الإضافة/التعديل
  void _navigateToAddEdit(MosqueModel? mosque) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<MosquesBloc>(),
              child: AddEditMosqueScreen(mosque: mosque),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light_gray,
      body: Column(
        children: [
          SearchAndFilterBar(
            onSearchChanged: _onSearchChanged,
            hintText: 'ابحث عن مسجد أو مركز...',
          ),
          Expanded(
            child: BlocBuilder<MosquesBloc, MosquesState>(
              builder: (context, state) {
                if (state.status == MosquesStatus.loading &&
                    state.mosques.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == MosquesStatus.failure &&
                    state.mosques.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'فشل تحميل البيانات: ${state.errorMessage}',
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            () async => context.read<MosquesBloc>().add(
                              const FetchMosques(),
                            ),
                        icon: Icon(Icons.replay_outlined),
                        label: Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }
                if (state.mosques.isEmpty) {
                  return const Center(child: Text('لا توجد مساجد لعرضها.'));
                }
                return RefreshIndicator(
                  onRefresh:
                      () async =>
                          context.read<MosquesBloc>().add(const FetchMosques()),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.hasReachedMax
                            ? state.mosques.length
                            : state.mosques.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.mosques.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final mosque = state.mosques[index];
                      return ListItemTile(
                        icon: const Icon(Icons.mosque_rounded),
                        title: mosque.name,
                        subtitle:
                            'المركز: ${mosque.centerName ?? 'غير محدد'} - العنوان: ${mosque.address}',
                        // ✅ تفعيل قائمة الخيارات
                        onMoreTap: () => _showOptions(context, mosque),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_mosques',
        onPressed:
            () => _navigateToAddEdit(null), // استدعاء دالة الانتقال للإضافة
        child: const Icon(Icons.add),
      ),
    );
  }

  // ✅ دالة لعرض قائمة الخيارات (تعديل/حذف)
  void _showOptions(BuildContext context, MosqueModel mosque) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('تعديل بيانات المسجد'),
              onTap: () {
                Navigator.pop(ctx);
                _navigateToAddEdit(mosque); // استدعاء دالة الانتقال للتعديل
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
              title: Text(
                'حذف المسجد',
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder:
                      (dialogCtx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text(
                          'هل أنت متأكد من رغبتك في حذف مسجد "${mosque.name}"؟',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            child: const Text(
                              'حذف',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              context.read<MosquesBloc>().add(
                                DeleteMosque(mosque.id),
                              );
                                ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text('تم الحذف بنجاح'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              Navigator.pop(dialogCtx);
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

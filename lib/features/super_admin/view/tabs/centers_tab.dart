// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
// import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
// import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
// import 'package:flutter_admain_center/features/super_admin/bloc/centers_bloc/centers_bloc.dart';
// import 'package:flutter_admain_center/features/super_admin/view/add_edit_center_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// // ✅ 1. أصبح هذا الويدجت هو الويدجت الوحيد في الملف
// class CentersTab extends StatefulWidget {
//   const CentersTab({super.key});

//   @override
//   State<CentersTab> createState() => _CentersTabState();
// }

// class _CentersTabState extends State<CentersTab> {
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     // لا نطلب البيانات هنا، سيتم طلبها من BlocProvider
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
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       context.read<CentersBloc>().add(FetchMoreCenters());
//     }
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       context.read<CentersBloc>().add(FetchCenters(searchQuery: query));
//     });
//   }

//   // ... (داخل _CentersTabState)

//   void _navigateToAddEditScreen({CenterModel? center}) async {
//     // ✅ نستخدم Navigator.of(context) الذي يشير الآن إلى الـ Navigator الصغير الخاص بالتاب
//     final result = await Navigator.of(context).push<bool>(
//       MaterialPageRoute(
//         builder:
//             (_) => BlocProvider.value(
//               value: context.read<CentersBloc>(),
//               child: AddEditCenterScreen(center: center),
//             ),
//       ),
//     );
//     if (result == true && mounted) {
//       context.read<CentersBloc>().add(const FetchCenters());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ 2. تم إرجاع Scaffold و FloatingActionButton إلى هنا
//     return VisibilityDetector(
//       key: const Key('centers_tab_visibility_detector'),
//       onVisibilityChanged: (visibilityInfo) {
//         // إذا ظهر أكثر من 50% من الويدجت على الشاشة
//         if (visibilityInfo.visibleFraction > 0.5) {
//           // تحقق من أن الحالة الحالية ليست "محملة" أو "جاري التحميل" لتجنب الطلبات المتكررة
//           final currentState = context.read<CentersBloc>().state;
//           if (currentState.status != CentersStatus.success &&
//               currentState.status != CentersStatus.loading) {
//             context.read<CentersBloc>().add(const FetchCenters());
//           }
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.light_gray,
//         body: Column(
//           children: [
//             SearchAndFilterBar(
//               onSearchChanged: _onSearchChanged,
//               hintText: 'ابحث عن مركز بالاسم او اسم المدير...',
//             ),
//             Expanded(
//               child: BlocBuilder<CentersBloc, CentersState>(
//                 builder: (context, state) {
//                   if (state.status == CentersStatus.loading &&
//                       state.centers.isEmpty) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (state.status == CentersStatus.failure &&
//                       state.centers.isEmpty) {
//                     return Center(
//                       child: Text('فشل تحميل البيانات: ${state.errorMessage}'),
//                     );
//                   }
//                   if (state.centers.isEmpty) {
//                     return const Center(child: Text('لا توجد مراكز لعرضها.'));
//                   }
//                   return RefreshIndicator(
//                     onRefresh:
//                         () async => context.read<CentersBloc>().add(
//                           const FetchCenters(),
//                         ),
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       itemCount:
//                           state.hasReachedMax
//                               ? state.centers.length
//                               : state.centers.length + 1,
//                       itemBuilder: (context, index) {
//                         if (index >= state.centers.length) {
//                           return const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }

// final center = state.centers[index];

//   tag: 'center_card_${center.id}', // <-- تذكر هذا الـ tag جيداً
//   child: Material( // ✅ نلفها بـ Material لمنع الأخطاء الرسومية
//     type: MaterialType.transparency,
//     child: ListItemTile(
//       icon: Icon(Icons.business, color: AppColors.steel_blue),
//       title: center.name,
//       subtitle:
//           'المدير: ${center.managerName ?? 'غير محدد'} - المنطقة: ${center.region ?? 'N/A'}',
//       onMoreTap: () => _showCenterOptions(context, center),
//       // ✅ نمرر دالة onTap مباشرة إلى ListItemTile
//       onTap: () => _navigateToAddEditScreen(center: center),
//     ),
//   ),
// );

//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//
//       ),
//     );
//   }

//   void _showCenterOptions(BuildContext context, CenterModel center) {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.edit_rounded),
//               title: const Text('تعديل بيانات المركز'),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 _navigateToAddEditScreen(center: center);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
//               title: Text(
//                 'حذف المركز',
//                 style: TextStyle(color: Colors.red.shade700),
//               ),
//               onTap: () {
//                 Navigator.pop(ctx);
//                 showDialog(
//                   context: context,
//                   builder:
//                       (dialogCtx) => AlertDialog(
//                         title: const Text('تأكيد الحذف'),
//                         content: Text(
//                           'هل أنت متأكد من رغبتك في حذف مركز "${center.name}"؟',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(dialogCtx),
//                             child: const Text('إلغاء'),
//                           ),
//                           TextButton(
//                             child: const Text(
//                               'حذف',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             onPressed: () {
//                               context.read<CentersBloc>().add(
//                                 DeleteCenter(center.id),
//                               );
//                               Navigator.pop(dialogCtx);
//                             },
//                           ),
//                         ],
//                       ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/super_admin/center_model.dart';
import 'package:flutter_admain_center/features/super_admin/bloc/centers_bloc/centers_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/add_edit_center_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CentersTab extends StatefulWidget {
  const CentersTab({super.key});

  @override
  State<CentersTab> createState() => _CentersTabState();
}

class _CentersTabState extends State<CentersTab> {
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
      context.read<CentersBloc>().add(FetchMoreCenters());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CentersBloc>().add(FetchCenters(searchQuery: query));
    });
  }

  void _navigateToAddEditScreen({CenterModel? center}) async {
    final result = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<CentersBloc>(),
              child: AddEditCenterScreen(center: center),
            ),
      ),
    );
    if (result == true && mounted) {
      context.read<CentersBloc>().add(const FetchCenters());
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('centers_tab_visibility_detector'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          final currentState = context.read<CentersBloc>().state;
          if (currentState.status != CentersStatus.success &&
              currentState.status != CentersStatus.loading) {
            context.read<CentersBloc>().add(const FetchCenters());
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.light_gray,
        body: Column(
          children: [
            SearchAndFilterBar(
              onSearchChanged: _onSearchChanged,
              hintText: 'ابحث عن مركز بالاسم او اسم المدير...',
            ),
            Expanded(
              child: BlocBuilder<CentersBloc, CentersState>(
                builder: (context, state) {
               
                  if (state.status == CentersStatus.loading &&
                      state.centers.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == CentersStatus.failure &&
                      state.centers.isEmpty) {
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
                              () async => context.read<CentersBloc>().add(
                                const FetchCenters(),
                              ),
                          icon: Icon(Icons.replay_outlined),
                          label: Text('إعادة المحاولة'),
                        ),
                      ],
                    );
                  }
                  if (state.centers.isEmpty) {
                    return const Center(child: Text('لا توجد مراكز لعرضها.'));
                  }
                  return RefreshIndicator(
                    onRefresh:
                        () async => context.read<CentersBloc>().add(
                          const FetchCenters(),
                        ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.hasReachedMax
                              ? state.centers.length
                              : state.centers.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.centers.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final center = state.centers[index];
                        return ListItemTile(
                          icon: Icon(
                            Icons.business,
                            color: AppColors.steel_blue,
                          ),
                          title: center.name,
                          subtitle:
                              'المدير: ${center.managerName ?? 'غير محدد'} - المنطقة: ${center.region ?? 'N/A'}',
                          onMoreTap: () => _showCenterOptions(context, center),
                          onTap: () => _navigateToAddEditScreen(center: center),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'fab_centers',
          onPressed: () => _navigateToAddEditScreen(),
          label: const Text('إضافة مركز'),
          icon: const Icon(Icons.add_business_rounded),
        ),
      ),
    );
  }

  void _showCenterOptions(BuildContext context, CenterModel center) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('تعديل بيانات المركز'),
              onTap: () {
                Navigator.pop(ctx);
                _navigateToAddEditScreen(center: center);
              },
            ),
         
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
              title: Text(
                'حذف المركز',
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
                          'هل أنت متأكد من رغبتك في حذف مركز "${center.name}"؟',
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
                              context.read<CentersBloc>().add(
                                DeleteCenter(center.id),
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

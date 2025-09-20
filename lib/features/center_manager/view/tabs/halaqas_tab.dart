import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/edit_halaqa_bloc/edit_halaqa_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqa_details_bloc/halaqa_details_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_halaqa_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/halaqa_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class HalaqasTab extends StatefulWidget {
  const HalaqasTab({super.key});

  @override
  State<HalaqasTab> createState() => _HalaqasTabState();
}

class _HalaqasTabState extends State<HalaqasTab> {
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
    if (_isBottom) {
      context.read<HalaqasBloc>().add(FetchMoreHalaqas());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HalaqasBloc>().add(FetchHalaqas(searchQuery: query));
    });
  }

  void _showHalaqaOptions(
    BuildContext context,
    int halaqaId,
    String halaqaName,
  ) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('عرض التفاصيل'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            // افترض أن لديك TeacherProfileBloc
                            create:
                                (context) => HalaqaDetailsBloc(
                                  repository:
                                      context.read<CenterManagerRepository>(),
                                )..add(FetchHalaqaDetails(halaqaId)),
                            child: const HalaqaDetailsScreen(),
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تعديل البيانات'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      // ==================== هنا هو الإصلاح الكامل ====================
                      builder:
                          (_) => BlocProvider(
                            // 1. إنشاء البلوك هنا، قبل بناء شاشة التعديل
                            create:
                                (context) => EditHalaqaBloc(
                                  repository:
                                      context.read<CenterManagerRepository>(),
                                ),
                            // 2. الآن يمكن لـ EditHalaqaScreen وأبنائها الوصول للبلوك بأمان
                            child: EditHalaqaScreen(halaqaId: halaqaId),
                          ),
                      // =============================================================
                    ),
                  );
                  if (result == true && mounted) {
                    context.read<HalaqasBloc>().add(const FetchHalaqas());
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
                title: Text(
                  'حذف الحلقة',
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
                            'هل أنت متأكد من رغبتك في حذف حلقة "$halaqaName"؟',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('إلغاء'),
                              onPressed: () => Navigator.pop(dialogCtx),
                            ),
                            TextButton(
                              child: const Text(
                                'حذف',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                context.read<HalaqasBloc>().add(
                                  DeleteHalaqa(halaqaId),
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
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HalaqasBloc>().add(const FetchHalaqas());
      },
      child: Column(
        children: [
          Card(
            // 1. تحديد الهوامش حول الكرت
            margin: const EdgeInsets.all(10.0),
            // 2. تحديد شكل الكرت (زوايا دائرية)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              // 3. يمكنك إضافة إطار للكرت نفسه إذا أردت
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            // 4. التحكم في الظل (elevation)
            elevation: 2.0,
            child: SearchAndFilterBar(
              onSearchChanged: _onSearchChanged,
              hintText: 'ابحث عن حلقة بالاسم او اسم الجامع او الاستاذ...',
            ),
          ),
          Expanded(
            child: BlocBuilder<HalaqasBloc, HalaqasState>(
              builder: (context, state) {
                switch (state.status) {
                  case HalaqasStatus.failure:
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            'فشل تحميل البيانات: ${state.errorMessage}',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => context.read<HalaqasBloc>().add(
                                const FetchHalaqas(),
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('تحديث'),
                        ),
                      ],
                    );

                  case HalaqasStatus.success:
                    if (state.halaqas.isEmpty) {
                      return const Center(child: Text('لا يوجد حلقات لعرضها.'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.hasReachedMax
                              ? state.halaqas.length
                              : state.halaqas.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.halaqas.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final halaqa = state.halaqas[index];
                        return ListItemTile(
                          title: halaqa.name,
                          subtitle:
                              'المسجد: ${halaqa.mosqueName ?? 'غير محدد'} - الأستاذ: ${halaqa.teacherName ?? 'غير محدد'}',
                          onMoreTap:
                              () => _showHalaqaOptions(
                                context,
                                halaqa.id,
                                halaqa.name,
                              ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider(
                                      create:
                                          (ctx) => HalaqaDetailsBloc(
                                            repository:
                                                context
                                                    .read<
                                                      CenterManagerRepository
                                                    >(),
                                          )..add(FetchHalaqaDetails(halaqa.id)),
                                      child: const HalaqaDetailsScreen(),
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );

                  case HalaqasStatus.loading:
                  case HalaqasStatus.initial:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

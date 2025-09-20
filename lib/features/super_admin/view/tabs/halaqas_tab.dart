import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/super_admin/halaqa_model.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// ✅ تأكد من أن مسار الاستيراد هذا صحيح
import 'package:flutter_admain_center/features/super_admin/bloc/halaqas_bloc/halaqas_bloc.dart';
import 'package:flutter_admain_center/features/super_admin/view/add_edit_halaqa_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ الخطوة 1: تحويل الويدجت الرئيسية إلى StatelessWidget
class HalaqasTab extends StatelessWidget {
  const HalaqasTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ الخطوة 2: توفير البلوك هنا وطلب البيانات مباشرة
    // بما أن HalaqasBloc يتم إنشاؤه فقط لدور المدير العام،
    // فمن الأفضل إنشاؤه هنا بدلاً من role_router_screen ليكون محصوراً في مكانه.
    return BlocProvider(
      create:
          (context) => HalaqasBloc(
            // نحن نقرأ الـ Repository الذي تم توفيره في main.dart
            repository: context.read<SuperAdminRepository>(),
          )..add(const FetchHalaqas()), // <-- طلب البيانات مباشرة عند الإنشاء
      child: const HalaqasView(),
    );
  }
}

// ✅ الخطوة 3: فصل الواجهة الفعلية إلى ويدجت خاصة بها
class HalaqasView extends StatefulWidget {
  const HalaqasView({super.key});

  @override
  State<HalaqasView> createState() => _HalaqasViewState();
}

class _HalaqasViewState extends State<HalaqasView> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HalaqasBloc>().add(FetchHalaqas(searchQuery: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light_gray,
      body: Column(
        children: [
          SearchAndFilterBar(
            onSearchChanged: _onSearchChanged,
            hintText: 'ابحث عن حلقة أو مسجد...',
          ),
          Expanded(
            // ✅✅ الكود الآن يستخدم الحالات الصحيحة التي أرسلتها ✅✅
            child: BlocBuilder<HalaqasBloc, HalaqasState>(
              builder: (context, state) {
                if (state is HalaqasLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HalaqasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Center(
                        child: Text('فشل تحميل الحلقات: ${state.message}'),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            () async => context.read<HalaqasBloc>().add(
                              const FetchHalaqas(),
                            ),
                        icon: Icon(Icons.replay_outlined),
                        label: Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }
                if (state is HalaqasLoaded) {
                  if (state.halaqas.isEmpty) {
                    return const Center(child: Text('لا توجد حلقات لعرضها.'));
                  }
                  return RefreshIndicator(
                    onRefresh:
                        () async => context.read<HalaqasBloc>().add(
                          const FetchHalaqas(),
                        ),
                    child: ListView.builder(
                      itemCount: state.halaqas.length,
                      itemBuilder: (context, index) {
                        final halaqa = state.halaqas[index];
                        return ListItemTile(
                          icon: const Icon(Icons.groups_2_rounded),
                          title: halaqa.name,
                          subtitle:
                              'المركز: ${halaqa.centerName} - المسجد: ${halaqa.mosqueName} - النوع: ${halaqa.typeName}',
                          onMoreTap: () => _showOptions(context, halaqa),
                        );
                      },
                    ),
                  );
                }
                // هذه هي الحالة الأولية (HalaqasInitial)
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_halaqas',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // ✅ تمرير البلوك الحالي إلى الشاشة الجديدة
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<HalaqasBloc>(),
                    child: const AddEditHalaqaScreen(),
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOptions(BuildContext context, HalaqaModel halaqa) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('تعديل الحلقة'),
                onTap: () {
                  
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<HalaqasBloc>(),
                            child: AddEditHalaqaScreen(halaqa: halaqa),
                          ),
                    ),
                  );
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
                            'هل أنت متأكد من رغبتك في حذف حلقة "${halaqa.name}"؟',
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
                                context.read<HalaqasBloc>().add(
                                  DeleteHalaqa(halaqa.id),
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
          ),
    );
  }
}

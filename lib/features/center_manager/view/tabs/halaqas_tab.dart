import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/widgets/list_item_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/halaqas_bloc/halaqas_bloc.dart';

class HalaqasTab extends StatefulWidget {
  const HalaqasTab({super.key});

  @override
  State<HalaqasTab> createState() => _HalaqasTabState();
}

class _HalaqasTabState extends State<HalaqasTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HalaqasBloc, HalaqasState>(
      builder: (context, state) {
        switch (state.status) {
          case HalaqasStatus.failure:
            return Center(child: Text('فشل تحميل البيانات: ${state.errorMessage}'));
          
          case HalaqasStatus.success:
            if (state.halaqas.isEmpty) {
              return const Center(child: Text('لا يوجد حلقات لعرضها.'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.halaqas.length : state.halaqas.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.halaqas.length) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                final halaqa = state.halaqas[index];
                return ListItemTile(
                  title: halaqa.name,
                  subtitle: 'المسجد: ${halaqa.masjidName} - الأستاذ: ${halaqa.teacherName}',
                  onMoreTap: () { showModalBottomSheet(
            context: context,
            builder: (ctx) => Wrap(
                children: [
                    ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('عرض التفاصيل'),
                        onTap: () { /* Navigate to HalaqaDetailsScreen */ },
                    ),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('تعديل البيانات'),
                        onTap: () { /* Navigate to EditHalaqaScreen */ },
                    ),
                    ListTile(
                        leading: Icon(Icons.delete_forever, color: Colors.red.shade700),
                        title: Text('حذف الحلقة', style: TextStyle(color: Colors.red.shade700)),
                        onTap: () {
                            Navigator.pop(ctx);
                            // إرسال حدث الحذف للبلوك
                            context.read<HalaqasBloc>().add(DeleteHalaqa(halaqa.id));
                        },
                    ),
                ],
            ),
        ); },
                );
              },
            );

          case HalaqasStatus.loading:
          case HalaqasStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

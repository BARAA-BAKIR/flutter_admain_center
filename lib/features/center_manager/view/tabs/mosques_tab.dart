// lib/features/center_manager/view/mosques_tab.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

import 'package:flutter_admain_center/core/widgets/search_and_filter_bar.dart';
import 'package:flutter_admain_center/data/models/center_maneger/mosque_model.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/mosques_bloc/mosques_bloc.dart';
import 'package:flutter_admain_center/features/center_manager/view/add_mosque_screen.dart';
import 'package:flutter_admain_center/features/center_manager/view/edit_mosque_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MosquesTab extends StatefulWidget {
  const MosquesTab({super.key});

  @override
  State<MosquesTab> createState() => _MosquesTabState();
}

class _MosquesTabState extends State<MosquesTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<MosquesBloc>().add(const FetchMosques());
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
      context.read<MosquesBloc>().add(FetchMoreMosques());
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
      context.read<MosquesBloc>().add(FetchMosques(searchQuery: query));
    });
  }
  // lib/features/center_manager/view/tabs/mosques_tab.dart

  void _showMosqueOptions(BuildContext context, Mosque mosque) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_note_rounded),
                title: const Text('تعديل البيانات'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final updatedMosque = await Navigator.of(
                    context,
                  ).push<Mosque>(
                    MaterialPageRoute(
                      builder: (_) => EditMosqueScreen(mosque: mosque),
                    ),
                  );

                  // 2. إذا عادت بيانات المسجد المحدث، أرسل الحدث الصحيح
                  if (updatedMosque != null && mounted) {
                    context.read<MosquesBloc>().add(
                      UpdateMosqueInList(updatedMosque),
                    );
                  }
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
                            'هل أنت متأكد من رغبتك في حذف مسجد "${mosque.name}"؟ سيتم حذف جميع الحلقات والطلاب المرتبطين به.',
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
                                context.read<MosquesBloc>().add(
                                  DeleteMosque(mosque.id),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_mosque_fab',
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddMosqueScreen()),
          );
          if (result == true && mounted) {
            context.read<MosquesBloc>().add(const FetchMosques());
          }
        },
        tooltip: 'إضافة مسجد جديد',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MosquesBloc>().add(const FetchMosques());
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
                hintText: 'ابحث عن مسجد بالاسم أو العنوان...',
              ),
            ),
            Expanded(
              child: BlocConsumer<MosquesBloc, MosquesState>(
                listener: (context, state) {
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.successMessage!),
                          backgroundColor: Colors.green,
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case MosquesStatus.failure:
                      return Center(
                        child: Text(
                          'فشل تحميل البيانات: ${state.errorMessage}',
                        ),
                      );
                    case MosquesStatus.success:
                      if (state.mosques.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mosque_outlined,
                                  size: 100,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'لا يوجد مساجد بعد',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ابدأ بإضافة مسجد جديد بالضغط على زر الإضافة (+)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
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
                          return Card(
                            elevation: 2.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: Icon(
                                  Icons.mosque_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              title: Text(
                                mosque.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'العنوان: ${mosque.address}\nعدد الحلقات: ${mosque.halaqaCount}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed:
                                    () => _showMosqueOptions(context, mosque),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      );
                    case MosquesStatus.loading:
                    case MosquesStatus.initial:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

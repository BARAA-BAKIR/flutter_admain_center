import 'package:flutter/material.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDialogView extends StatelessWidget {
  final Function(int? halaqaId, int? levelId) onApply;
  // إزالة const من المُنشئ
  FilterDialogView({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    int? tempHalaqaId;
    int? tempLevelId;

    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        if (state.status == FilterStatus.loading) {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
        if (state.status == FilterStatus.failure) {
          return SizedBox(height: 200, child: Center(child: Text(state.errorMessage ?? 'فشل تحميل الفلاتر')));
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('فلترة النتائج', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                hint: const Text('فلترة حسب الحلقة'),
                items: state.halaqas.map((h) => DropdownMenuItem(value: h['id'] as int, child: Text(h['name'].toString()))).toList(),
                onChanged: (value) => tempHalaqaId = value,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                hint: const Text('فلترة حسب المرحلة'),
                items: state.levels.map((l) => DropdownMenuItem(value: l['id'] as int, child: Text(l['name'].toString()))).toList(),
                onChanged: (value) => tempLevelId = value,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  onApply(tempHalaqaId, tempLevelId);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('تطبيق الفلاتر'),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';

class HalaqasTabScreen extends StatefulWidget {
  const HalaqasTabScreen({super.key});

  @override
  State<HalaqasTabScreen> createState() => _HalaqasTabScreenState();
}

class _HalaqasTabScreenState extends State<HalaqasTabScreen> {
  // مثال على البيانات التي ستأتي من الـ API
  final Map<String, List<Map<String, String>>> groupedHalaqas = {
    'مسجد التقوى': [
      {'name': 'حلقة الصحابة', 'teacher': 'أ. أحمد علي', 'students': '18/20'},
      {'name': 'حلقة الأنصار', 'teacher': 'أ. محمد خالد', 'students': '15/20'},
    ],
    'مسجد الإيمان': [
      {'name': 'حلقة الخلفاء الراشدين', 'teacher': 'أ. يوسف سعيد', 'students': '20/20'},
    ],
    'مسجد النور': [
      {'name': 'حلقة الأوائل', 'teacher': 'أ. عمر فاروق', 'students': '12/20'},
      {'name': 'حلقة المتقدمين', 'teacher': 'أ. علي حسن', 'students': '19/20'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // TODO: استبدال ListView بـ BlocBuilder لجلب الحلقات
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedHalaqas.length,
      itemBuilder: (context, index) {
        String masjidName = groupedHalaqas.keys.elementAt(index);
        List<Map<String, String>> halaqas = groupedHalaqas[masjidName]!;
        
        // استخدام ExpansionTile لإنشاء قائمة مجمعة قابلة للطي
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          child: ExpansionTile(
            title: Text(
              masjidName,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: const Icon(Icons.mosque_rounded, color: AppColors.teal_blue),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            initiallyExpanded: true, // لجعل المجموعات مفتوحة بشكل افتراضي
            children: halaqas.map((halaqa) {
              return _buildHalaqaTile(halaqa);
            }).toList(),
          ),
        );
      },
    );
  }

  // ويدجت لعرض عنصر الحلقة
  Widget _buildHalaqaTile(Map<String, String> halaqa) {
    return ListTile(
      title: Text(halaqa['name']!, style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
      subtitle: Text('المشرف: ${halaqa['teacher']}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group, color: Colors.grey),
          Text(halaqa['students']!, style: GoogleFonts.tajawal(fontSize: 12)),
        ],
      ),
      onTap: () { /* TODO: Navigate to halaqa details screen */ },
    );
  }
}

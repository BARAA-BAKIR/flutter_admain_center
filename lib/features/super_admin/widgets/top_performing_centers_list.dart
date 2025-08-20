// // features/super_admin/widgets/top_performing_centers_list.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TopPerformingCentersList extends StatelessWidget {
//   final List<Map<String, dynamic>> centers;

//   const TopPerformingCentersList({super.key, required this.centers});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('المراكز الأكثر نشاطاً (حسب عدد الطلاب)', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             if (centers.isEmpty)
//               const Center(child: Text('لا توجد بيانات لعرضها.'))
//             else
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: centers.length,
//                 itemBuilder: (context, index) {
//                   final center = centers[index];
//                   return ListTile(
//                     leading: CircleAvatar(child: Text('${index + 1}')),
//                     title: Text(center['name'] ?? 'N/A', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
//                     trailing: Text('${center['students_count'] ?? 0} طالب', style: GoogleFonts.tajawal()),
//                     onTap: () { /* TODO: Navigate to center details screen */ },
//                   );
//                 },
//                 separatorBuilder: (context, index) => const Divider(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopPerformingCentersList extends StatelessWidget {
  final List<Map<String, dynamic>> centers;

  const TopPerformingCentersList({super.key, required this.centers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ تغيير العنوان ليعكس المنطق الجديد
            Text('المراكز الأكثر نشاطاً (حسب نسبة الحضور)', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (centers.isEmpty)
              const Center(child: Text('لا توجد بيانات لعرضها.'))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: centers.length,
                itemBuilder: (context, index) {
                  final center = centers[index];
                  // ✅ عرض نسبة الحضور بدلاً من عدد الطلاب
                  final attendance = center['attendance_percentage']?.toStringAsFixed(1) ?? '0.0';
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(center['name'] ?? 'N/A', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                    trailing: Text('$attendance %', style: GoogleFonts.tajawal(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                    onTap: () { /* TODO: Navigate to center details screen */ },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
          ],
        ),
      ),
    );
  }
}

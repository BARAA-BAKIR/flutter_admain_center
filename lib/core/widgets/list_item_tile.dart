import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class ListItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap; 
  final VoidCallback onMoreTap;
  final Icon icon;
  const ListItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap ,
    required this.onMoreTap,
    this.icon = const Icon(Icons.person, color: AppColors.steel_blue),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      // ignore: deprecated_member_use
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.light_sky_blue,
          // استخدام الصورة الشبكية إذا كانت موجودة
          // child: imageUrl != null
          //     ? ClipOval(
          //         child: CachedNetworkImage(
          //           imageUrl: imageUrl!,
          //           placeholder: (context, url) => const CircularProgressIndicator(),
          //           errorWidget: (context, url, error) => const Icon(Icons.person, color: AppColors.steel_blue),
          //         ),
          //       )
          //     : Icon(Icons.person, color: AppColors.steel_blue),
          child: icon, // Placeholder
        ),
        title: Text(
          title,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.tajawal(color: Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: onMoreTap,
        ),
      ),
    );
  }
}

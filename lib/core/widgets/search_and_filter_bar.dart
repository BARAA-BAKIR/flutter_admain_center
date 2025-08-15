import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchAndFilterBar extends StatelessWidget {
 // final VoidCallback onFilterTap;
 final String hintText;
  final Function(String) onSearchChanged;

  const SearchAndFilterBar({
    super.key,
  //  required this.onFilterTap,
  required this.hintText,
    required this.onSearchChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // حقل البحث
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.tajawal(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // زر الفلترة
          // IconButton(
          //   icon: const Icon(Icons.filter_list_rounded),
          //  // onPressed: onFilterTap,
          //   style: IconButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12.0),
          //     ),
          //     padding: const EdgeInsets.all(12),
          //   ),
          // ),
        ],
      ),
    );
  }
}

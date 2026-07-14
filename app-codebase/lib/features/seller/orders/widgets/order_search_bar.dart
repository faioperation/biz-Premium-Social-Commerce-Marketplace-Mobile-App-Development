import 'package:flutter/material.dart';

// Reusable search bar — can be reused in other seller screens
class SellerSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SellerSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            color: isDark ? Colors.grey[500] : Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.grey[500] : Colors.grey[500],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}

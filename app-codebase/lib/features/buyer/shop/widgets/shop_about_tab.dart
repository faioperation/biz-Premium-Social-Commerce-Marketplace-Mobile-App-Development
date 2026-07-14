import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ShopAboutTab extends StatelessWidget {
  final String description;
  final bool isDark;

  const ShopAboutTab({
    super.key,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Text(
        description,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          fontSize: 15,
          height: 1.6,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

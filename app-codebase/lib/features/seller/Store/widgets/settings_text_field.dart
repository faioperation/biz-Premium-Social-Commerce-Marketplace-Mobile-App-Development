import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A reusable premium text form input field designed for Settings forms.
/// Integrates seamlessly with system dark and light modes.
class SettingsTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;
  final TextInputType keyboardType;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-specific color parameters
    final Color labelColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color inputTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color inputBgColor = isDark ? const Color(0xFF1E1E22) : const Color(0xFFF9FAFB);
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final Color hintColor = isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.6) : AppColors.lightTextSecondary.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: inputTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

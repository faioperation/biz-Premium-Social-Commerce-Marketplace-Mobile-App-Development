import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppStatusType { success, error, warning, info, standard }

class AppStatusChip extends StatelessWidget {
  final String label;
  final AppStatusType type;
  final bool dot;

  const AppStatusChip({
    super.key,
    required this.label,
    this.type = AppStatusType.standard,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color textColor;

    switch (type) {
      case AppStatusType.success:
        bgColor   = isDark ? AppColors.successDark : AppColors.successLight;
        textColor = AppColors.success;
        break;
      case AppStatusType.error:
        bgColor   = isDark ? AppColors.errorDark : AppColors.errorLight;
        textColor = AppColors.error;
        break;
      case AppStatusType.warning:
        bgColor   = isDark ? AppColors.warningDark : AppColors.warningLight;
        textColor = AppColors.warning;
        break;
      case AppStatusType.info:
        bgColor   = isDark ? AppColors.infoDark : AppColors.infoLight;
        textColor = AppColors.info;
        break;
      case AppStatusType.standard:
        bgColor   = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

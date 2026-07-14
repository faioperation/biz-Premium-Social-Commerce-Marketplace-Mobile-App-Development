import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.fullWidth = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget label = widget.isLoading
        ? SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _foregroundColor(isDark),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16),
                const SizedBox(width: 6),
              ],
              Text(widget.label, style: AppTextStyles.button),
            ],
          );

    if (widget.fullWidth) {
      label = Center(child: label);
    }

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => _controller.forward(),
        onTapUp:   isDisabled ? null : (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: _buildButton(context, label, isDisabled, isDark),
      ),
    );
  }

  Color _foregroundColor(bool isDark) {
    switch (widget.type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
      case AppButtonType.secondary:
        return Colors.white;
      case AppButtonType.outline:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      case AppButtonType.text:
        return AppColors.primary;
    }
  }

  Widget _buildButton(BuildContext context, Widget child, bool isDisabled, bool isDark) {
    final shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    final padding = EdgeInsets.symmetric(
      horizontal: widget.icon != null ? 14 : 16,
      vertical: 10,
    );

    switch (widget.type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: padding,
            minimumSize: widget.fullWidth ? const Size(double.infinity, 40) : null,
            shape: shape,
            textStyle: AppTextStyles.button,
          ),
          child: child,
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.hoverDark : AppColors.hoverLight,
            foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: padding,
            minimumSize: widget.fullWidth ? const Size(double.infinity, 40) : null,
            shape: shape,
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            textStyle: AppTextStyles.button,
          ),
          child: child,
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            padding: padding,
            minimumSize: widget.fullWidth ? const Size(double.infinity, 40) : null,
            shape: shape,
            textStyle: AppTextStyles.button,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.hovered)
                ? (isDark ? AppColors.hoverDark : AppColors.hoverLight)
                : null),
          ),
          child: child,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: padding,
            minimumSize: widget.fullWidth ? const Size(double.infinity, 40) : null,
            shape: shape,
            textStyle: AppTextStyles.button,
          ),
          child: child,
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: padding,
            minimumSize: widget.fullWidth ? const Size(double.infinity, 40) : null,
            shape: shape,
            textStyle: AppTextStyles.button,
          ),
          child: child,
        );
    }
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool elevated;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.elevated = false,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _controller;
  late Animation<double> _elevation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _elevation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.onTap != null ? 1.005 : 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    if (widget.onTap != null) {
      setState(() => _hovered = true);
      _controller.forward();
    }
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final cardColor   = isDark ? AppColors.cardDark   : AppColors.cardLight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Interpolate shadows based on animation value
        final List<BoxShadow> baseShadow = widget.elevated
            ? (isDark ? AppColors.shadowMd : AppColors.shadowLg)
            : (isDark ? [] : AppColors.shadowSm);

        final List<BoxShadow> hoverShadow = isDark ? AppColors.shadowMd : AppColors.shadowLg;

        // Blend shadow opacity based on hover animation
        final List<BoxShadow> currentShadow = _elevation.value < 0.01
            ? baseShadow
            : hoverShadow.map((s) => BoxShadow(
                color: s.color.withValues(alpha: s.color.a * _elevation.value),
                blurRadius: s.blurRadius,
                offset: s.offset,
                spreadRadius: s.spreadRadius,
              )).toList();

        return ScaleTransition(
          scale: _scale,
          child: MouseRegion(
            onEnter: _onEnter,
            onExit: _onExit,
            cursor: widget.onTap != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hovered && widget.onTap != null
                        ? (isDark
                            ? AppColors.borderDark.withValues(alpha: 1.6)
                            : AppColors.primary.withValues(alpha: 0.15))
                        : borderColor,
                  ),
                  boxShadow: currentShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Padding(
                    padding: widget.padding,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

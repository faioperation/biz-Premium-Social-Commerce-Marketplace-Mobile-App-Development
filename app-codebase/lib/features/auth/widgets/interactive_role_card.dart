import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class InteractiveRoleCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const InteractiveRoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<InteractiveRoleCard> createState() => _InteractiveRoleCardState();
}

class _InteractiveRoleCardState extends State<InteractiveRoleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double borderAlpha = 0.3 + (0.25 * _controller.value);
          final double bgAlpha = 0.05 + (0.03 * _controller.value);

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: AppSpacing.edgeInsetsAllLg,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.color.withValues(alpha: borderAlpha),
                  width: 2,
                ),
                borderRadius: AppSpacing.borderRadiusLg,
                color: widget.color.withValues(alpha: bgAlpha),
              ),
              child: Row(
                children: [
                  Container(
                    padding: AppSpacing.edgeInsetsAllMd,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1 + (0.05 * _controller.value)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 32,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: widget.color,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlowingFloatingLogo extends StatefulWidget {
  final String imagePath;
  final double size;
  final Duration animationDuration;

  const GlowingFloatingLogo({
    super.key,
    required this.imagePath,
    this.size = 120.0,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<GlowingFloatingLogo> createState() => _GlowingFloatingLogoState();
}

class _GlowingFloatingLogoState extends State<GlowingFloatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _floatAnimation;

  late final Animation<double> _glowScaleAnimation;
  late final Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, -6),
      end: const Offset(0, 6),
    ).animate(curvedAnimation);

    _glowScaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(curvedAnimation);

    _glowOpacityAnimation = Tween<double>(
      begin: 0.40,
      end: 0.75,
    ).animate(curvedAnimation);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double glowSize = widget.size * 1.8;

    return SizedBox(
      width: glowSize,
      height: glowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _glowOpacityAnimation.value,
                child: Transform.scale(
                  scale: _glowScaleAnimation.value,
                  child: Container(
                    width: glowSize,
                    height: glowSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withValues(
                            alpha: 0.60,
                          ),
                          AppColors.accentPink.withValues(alpha: 0.35),
                          AppColors.liveBadge.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                        stops: const [0.1, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: _floatAnimation.value,
                child: Image.asset(
                  widget.imagePath,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

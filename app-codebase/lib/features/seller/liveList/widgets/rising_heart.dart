import 'package:flutter/material.dart';

/// A single floating heart particle that animates upward and fades out.
/// Used in the playback screen's heart reaction overlay.
class RisingHeart extends StatefulWidget {
  const RisingHeart({super.key});

  @override
  State<RisingHeart> createState() => _RisingHeartState();
}

class _RisingHeartState extends State<RisingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _yAnim;
  late final Animation<double> _xAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  late final double _startX;
  late final Color _color;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final random = DateTime.now().millisecondsSinceEpoch;
    _startX = (random % 40).toDouble();

    final colors = [
      Colors.pink.shade300,
      Colors.red.shade400,
      Colors.pinkAccent.shade200,
      Colors.amber.shade400,
      Colors.purple.shade300,
    ];
    _color = colors[random % colors.length];

    _yAnim = Tween<double>(begin: 180, end: 20).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _xAnim = Tween<double>(
      begin: _startX,
      end: _startX + ((random % 2 == 0 ? 1 : -1) * 30),
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.2, end: 1.0), weight: 30),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.ease));

    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.ease));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Positioned(
          bottom: _yAnim.value,
          right: _xAnim.value + 16,
          child: Opacity(
            opacity: _opacityAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: Icon(
                Icons.favorite_rounded,
                color: _color,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }
}

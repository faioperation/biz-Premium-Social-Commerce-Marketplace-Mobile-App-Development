import 'package:flutter/material.dart';

class SellerRevenueChart extends StatelessWidget {
  final List<double> data; // 7 values for Mon-Sun
  final VoidCallback? onViewAll;

  const SellerRevenueChart({
    super.key,
    required this.data,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontSize: 10,
      color: isDark ? Colors.grey[500] : Colors.grey[600],
      fontFamily: 'Inter',
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart Layout
          Row(
            children: [
              // Y-Axis Labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10000', style: textStyle),
                  const SizedBox(height: 18),
                  Text('7500', style: textStyle),
                  const SizedBox(height: 18),
                  Text('5000', style: textStyle),
                  const SizedBox(height: 18),
                  Text('2500', style: textStyle),
                  const SizedBox(height: 18),
                  Text('0', style: textStyle),
                ],
              ),
              const SizedBox(width: 8),
              // Chart area + Grid
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _ChartLinePainter(
                          data: data,
                          maxVal: 10000,
                          isDark: isDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // X-Axis Labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mon', style: textStyle),
                        Text('Tue', style: textStyle),
                        Text('Wed', style: textStyle),
                        Text('Thu', style: textStyle),
                        Text('Fri', style: textStyle),
                        Text('Sat', style: textStyle),
                        Text('Sun', style: textStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final List<double> data;
  final double maxVal;
  final bool isDark;

  _ChartLinePainter({
    required this.data,
    required this.maxVal,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final stepX = width / (data.length - 1);

    // Draw Grid Lines (Y axis milestones)
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A3C) : const Color(0xFFF3F4F6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final y = height - (i * (height / 4));
      // Draw horizontal dashed-like lines
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Prepare coordinates of data points
    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      // Clamp data to fit maxVal
      final clampedVal = data[i].clamp(0.0, maxVal);
      final y = height - (clampedVal / maxVal * height);
      points.add(Offset(x, y));
    }

    // Path for line and area filling
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      // Cubic bezier control points for smooth curves
      final controlPoint1 = Offset(p0.dx + stepX / 2, p0.dy);
      final controlPoint2 = Offset(p1.dx - stepX / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Create a path for filling gradient under the line
    final fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    // Paint the filled gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF6366F1).withValues(alpha: 0.35),
          const Color(0xFF6366F1).withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Paint the stroke path (the curve line itself)
    final strokePaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ChartLinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.maxVal != maxVal ||
        oldDelegate.isDark != isDark;
  }
}

import 'package:flutter/material.dart';

class RevenueBarChart extends StatelessWidget {
  final List<double> data; // 7 values for Mon-Sun

  const RevenueBarChart({
    super.key,
    required this.data,
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
          Text(
            'Revenue Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Y-Axis Labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10000', style: textStyle),
                  const SizedBox(height: 20),
                  Text('7500', style: textStyle),
                  const SizedBox(height: 20),
                  Text('5000', style: textStyle),
                  const SizedBox(height: 20),
                  Text('2500', style: textStyle),
                  const SizedBox(height: 20),
                  Text('0', style: textStyle),
                ],
              ),
              const SizedBox(width: 12),
              // Bar chart area
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _BarChartPainter(
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

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final double maxVal;
  final bool isDark;

  _BarChartPainter({
    required this.data,
    required this.maxVal,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final numBars = data.length;

    // Grid milestones (Y-axis horizontal grid lines)
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF2A2A3C) : const Color(0xFFF3F4F6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final y = height - (i * (height / 4));
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Draw Bars
    // Calculate width of each bar and spacing
    const double barWidthRatio = 0.55; // 55% of spacing is the bar width
    final spacing = width / numBars;
    final barWidth = spacing * barWidthRatio;

    final barPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < numBars; i++) {
      final val = data[i].clamp(0.0, maxVal);
      final barHeight = (val / maxVal) * height;
      final x = (i * spacing) + (spacing - barWidth) / 2;
      final y = height - barHeight;

      // Draw rounded rectangle for bar
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      );

      canvas.drawRRect(rect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.maxVal != maxVal ||
        oldDelegate.isDark != isDark;
  }
}

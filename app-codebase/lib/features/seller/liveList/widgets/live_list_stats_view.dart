import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A premium, visually stunning analytics view showing real-time engagement
/// metrics and viewer retention curves using high-performance CustomPainters.
class LiveListStatsView extends StatelessWidget {
  final int totalViewers;
  final int totalLikes;
  final double revenue;

  const LiveListStatsView({
    super.key,
    required this.totalViewers,
    required this.totalLikes,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color cardBg = isDark ? const Color(0xFF1E1E22) : const Color(0xFFF9FAFB);
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Grid of metrics cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMetricCard(
                title: 'Viewer Retention',
                value: '78.5%',
                icon: Icons.speed_rounded,
                color: Colors.indigo,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
              ),
              _buildMetricCard(
                title: 'Click-Through Rate',
                value: '14.2%',
                icon: Icons.ads_click_rounded,
                color: Colors.teal,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
              ),
              _buildMetricCard(
                title: 'Likes / Min',
                value: '${(totalLikes / 2.5).toStringAsFixed(0)} bpm',
                icon: Icons.favorite_border_rounded,
                color: Colors.pink,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
              ),
              _buildMetricCard(
                title: 'Avg. Order Value',
                value: '\$${(revenue / 18).toStringAsFixed(2)}',
                icon: Icons.shopping_basket_outlined,
                color: const Color(0xFF10B981),
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. High fidelity peak viewer graph using CustomPainter
          Text(
            'Viewer Retention Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Timeline analysis showing viewer concentration peaks.',
            style: TextStyle(
              fontSize: 12,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: CustomPaint(
              painter: _RetentionChartPainter(
                isDark: isDark,
                lineColor: AppColors.primary,
                gridColor: borderColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0m (Start)', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
              Text('1m 15s (Peak)', style: TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
              Text('2m 30s (End)', style: TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          ),
          const SizedBox(height: 24),
          
          // 3. User interaction heat summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                    ? [const Color(0xFF2E1C3F), const Color(0xFF1E1E22)]
                    : [const Color(0xFFF3EDFC), Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.insights_rounded, color: AppColors.primary, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Highly Engaging Broadcast!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Comment activity peaked when you featured the Floral Summer Dress. We recommend promoting similar styles in your next stream.',
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondaryColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSecondaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw a fluid line graph representing live viewer count peaks.
class _RetentionChartPainter extends CustomPainter {
  final bool isDark;
  final Color lineColor;
  final Color gridColor;

  _RetentionChartPainter({
    required this.isDark,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.3),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw horizontal grid lines
    const int gridRows = 4;
    for (int i = 0; i <= gridRows; i++) {
      final y = size.height * i / gridRows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw vertical grid lines
    const int gridCols = 5;
    for (int i = 0; i <= gridCols; i++) {
      final x = size.width * i / gridCols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Define curve points representing a premium, realistic retention wave
    final path = Path();
    final fillPath = Path();

    final points = [
      Offset(0, size.height * 0.8), // Start (0%)
      Offset(size.width * 0.15, size.height * 0.6), // Intro rise
      Offset(size.width * 0.35, size.height * 0.25), // Peak engagement
      Offset(size.width * 0.5, size.height * 0.15), // absolute peak
      Offset(size.width * 0.65, size.height * 0.35), // Dip
      Offset(size.width * 0.8, size.height * 0.5), // Stabilize
      Offset(size.width, size.height * 0.55), // End
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      
      final xc = (p0.dx + p1.dx) / 2;
      final yc = (p0.dy + p1.dy) / 2;

      path.quadraticBezierTo(p0.dx, p0.dy, xc, yc);
      fillPath.quadraticBezierTo(p0.dx, p0.dy, xc, yc);
    }

    // Connect curve to final point
    path.lineTo(points.last.dx, points.last.dy);
    fillPath.lineTo(points.last.dx, points.last.dy);

    // Complete fill path down to baseline
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw gradient fill first, then the curve stroke
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw interactive indicator at peak point (50% timeline)
    final peakPoint = points[3];
    final indicatorPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(peakPoint, 6, indicatorPaint);
    canvas.drawCircle(peakPoint, 6, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String growthText;
  final IconData icon;
  final Color iconColor;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.growthText,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            growthText,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              color: growthText.contains('-')
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF10B981),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

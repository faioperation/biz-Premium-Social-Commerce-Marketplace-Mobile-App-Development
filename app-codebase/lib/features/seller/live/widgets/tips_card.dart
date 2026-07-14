import 'package:flutter/material.dart';

/// A premium tips advice banner styled dynamically for dark and light modes.
/// Guides sellers with best practices for starting high-converting streams.
class TipsCard extends StatelessWidget {
  const TipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Warm warning-style amber palettes for maximum readability
    final Color bgColor = isDark ? const Color(0xFF1F1D1A) : const Color(0xFFFEFDF0);
    final Color borderColor = isDark ? const Color(0xFF382E1E) : const Color(0xFFFBF4D0);
    final Color titleColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);
    final Color textColor = isDark ? const Color(0xFFD1D1D6) : const Color(0xFF78350F);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled lightbulb / exclamation info icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3428) : const Color(0xFFFFFBEB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: titleColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          
          // Bullet points list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for a successful stream:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 8),
                _buildBulletPoint('Ensure good lighting and clear audio', textColor),
                const SizedBox(height: 4),
                _buildBulletPoint('Prepare product demos in advance', textColor),
                const SizedBox(height: 4),
                _buildBulletPoint('Engage with viewers and answer questions', textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0, right: 8.0),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

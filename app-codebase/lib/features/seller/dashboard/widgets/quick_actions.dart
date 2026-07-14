import 'package:flutter/material.dart';

class SellerQuickActions extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onGoLive;
  final VoidCallback onViewOrders;

  const SellerQuickActions({
    super.key,
    required this.onAddProduct,
    required this.onGoLive,
    required this.onViewOrders,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionItem(
                context,
                icon: Icons.add,
                label: 'Add Product',
                iconColor: const Color(0xFF6366F1),
                onTap: onAddProduct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionItem(
                context,
                icon: Icons.videocam_outlined,
                label: 'Go Live',
                iconColor: const Color(0xFFEC4899),
                onTap: onGoLive,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionItem(
                context,
                icon: Icons.inventory_2_outlined,
                label: 'View Orders',
                iconColor: const Color(0xFF10B981),
                onTap: onViewOrders,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

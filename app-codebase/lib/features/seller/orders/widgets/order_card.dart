import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../../../../core/constants/app_constants.dart';

// Reusable order card — renders one order row exactly like the screenshot
class SellerOrderCard extends StatelessWidget {
  final SellerOrderModel order;
  final String timeAgo;
  final VoidCallback? onTap;

  const SellerOrderCard({
    super.key,
    required this.order,
    required this.timeAgo,
    this.onTap,
  });

  // Status badge color config
  _BadgeConfig get _badgeConfig {
    switch (order.status) {
      case OrderStatus.newOrder:
        return _BadgeConfig(
          label: 'new',
          bg: const Color(0xFFEDE9FE),
          text: const Color(0xFF6366F1),
        );
      case OrderStatus.processing:
        return _BadgeConfig(
          label: 'processing',
          bg: const Color(0xFFFFF7ED),
          text: const Color(0xFFF97316),
        );
      case OrderStatus.shipped:
        return _BadgeConfig(
          label: 'shipped',
          bg: const Color(0xFFEFF6FF),
          text: const Color(0xFF3B82F6),
        );
      case OrderStatus.completed:
        return _BadgeConfig(
          label: 'completed',
          bg: const Color(0xFFECFDF5),
          text: const Color(0xFF10B981),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badge = _badgeConfig;
    final initials = order.customerName.isNotEmpty
        ? order.customerName[0].toUpperCase()
        : '?';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Order number + time + badge ──────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Order ${order.orderNumber}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badge.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: badge.text,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Row 2: Customer avatar + name + location ─────────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  backgroundImage: order.customerAvatar.isNotEmpty
                      ? NetworkImage(order.customerAvatar)
                      : null,
                  child: order.customerAvatar.isEmpty
                      ? Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                            fontFamily: 'Inter',
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      order.customerLocation,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Inter',
                        color:
                            isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Divider ──────────────────────────────────────────
            Divider(
              height: 1,
              color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFF3F4F6),
            ),

            const SizedBox(height: 12),

            // ── Row 3: Items count + Total ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  '${AppConstants.currencySymbol}${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeConfig {
  final String label;
  final Color bg;
  final Color text;
  const _BadgeConfig({
    required this.label,
    required this.bg,
    required this.text,
  });
}

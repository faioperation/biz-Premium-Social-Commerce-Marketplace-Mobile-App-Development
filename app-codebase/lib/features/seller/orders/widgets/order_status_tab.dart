import 'package:flutter/material.dart';
import '../models/order_model.dart';

// Reusable tab pill widget — used in OrdersScreen tab bar
class OrderStatusTab extends StatelessWidget {
  final OrderStatus status;
  final OrderStatus selectedStatus;
  final int count;
  final VoidCallback onTap;

  const OrderStatusTab({
    super.key,
    required this.status,
    required this.selectedStatus,
    required this.count,
    required this.onTap,
  });

  bool get isSelected => status == selectedStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          status.label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? const Color(0xFF6366F1)
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/order_model.dart';

// ── Reusable info section card ─────────────────────────────
class OrderDetailSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const OrderDetailSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Reusable row for label + value pairs ───────────────────
class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const OrderDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Inter',
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Inter',
              color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment status badge ────────────────────────────────────
class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, text;
    switch (status) {
      case PaymentStatus.paid:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF10B981);
        break;
      case PaymentStatus.pending:
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFFF97316);
        break;
      case PaymentStatus.failed:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFEF4444);
        break;
      case PaymentStatus.refunded:
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF3B82F6);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: text,
        ),
      ),
    );
  }
}

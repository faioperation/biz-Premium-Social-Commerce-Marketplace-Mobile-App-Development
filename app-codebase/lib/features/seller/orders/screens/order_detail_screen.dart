import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/order_model.dart';
import '../widgets/order_detail_widgets.dart';

class SellerOrderDetailScreen extends StatelessWidget {
  final SellerOrderModel order;

  const SellerOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerOrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black87,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Order Info Header ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order.orderNumber}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.formatDate(order.createdAt),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 24),

              // ── Customer & Delivery Info ─────────────────────────
              OrderDetailSectionCard(
                title: 'CUSTOMER & DELIVERY',
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              const Color(0xFF6366F1).withValues(alpha: 0.15),
                          backgroundImage: order.customerAvatar.isNotEmpty
                              ? NetworkImage(order.customerAvatar)
                              : null,
                          child: order.customerAvatar.isEmpty
                              ? Text(
                                  order.customerName.isNotEmpty
                                      ? order.customerName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6366F1),
                                    fontFamily: 'Inter',
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.deliveryAddress.fullName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.deliveryAddress.phone,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                        color: isDark
                            ? const Color(0xFF2A2A3C)
                            : const Color(0xFFF3F4F6)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            order.deliveryAddress.fullAddress,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (order.note != null && order.note!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A3C)
                              : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: isDark
                                  ? Colors.orange[300]
                                  : Colors.orange[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.note!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  color: isDark
                                      ? Colors.orange[200]
                                      : Colors.orange[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Payment Details ──────────────────────────────────
              OrderDetailSectionCard(
                title: 'PAYMENT INFO',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        PaymentStatusBadge(status: order.paymentStatus),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderDetailRow(
                      label: 'Payment Method',
                      value: order.paymentMethod,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Order Items ──────────────────────────────────────
              OrderDetailSectionCard(
                title: 'ORDER ITEMS (${order.itemCount})',
                child: Column(
                  children: order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A3C)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                              image: item.imageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(item.imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: item.imageUrl.isEmpty
                                ? Icon(
                                    Icons.image_outlined,
                                    color: isDark
                                        ? Colors.grey[600]
                                        : Colors.grey[400],
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${AppConstants.currencySymbol}${item.subtotal.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Order Summary ────────────────────────────────────
              OrderDetailSectionCard(
                title: 'ORDER SUMMARY',
                child: Column(
                  children: [
                    OrderDetailRow(
                      label: 'Subtotal',
                      value: '${AppConstants.currencySymbol}${order.subtotal.toStringAsFixed(0)}',
                    ),
                    OrderDetailRow(
                      label: 'Delivery Charge',
                      value: '${AppConstants.currencySymbol}${order.deliveryCharge.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 12),
                    Divider(
                        color: isDark
                            ? const Color(0xFF2A2A3C)
                            : const Color(0xFFF3F4F6)),
                    const SizedBox(height: 12),
                    OrderDetailRow(
                      label: 'Total Amount',
                      value: '${AppConstants.currencySymbol}${order.grandTotal.toStringAsFixed(0)}',
                      bold: true,
                      valueColor: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Action Button ────────────────────────────────────
              if (order.status.nextStatus != null)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _showActionDialog(
                          context, controller, order, order.status.nextStatus!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      order.status.actionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, SellerOrdersController controller,
      SellerOrderModel order, OrderStatus nextStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order Status'),
        content: Text(
            'Are you sure you want to mark order ${order.orderNumber} as ${nextStatus.label}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateOrderStatus(order.id, nextStatus);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order status updated to ${nextStatus.label}'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, text;
    switch (status) {
      case OrderStatus.newOrder:
        bg = const Color(0xFFEDE9FE);
        text = const Color(0xFF6366F1);
        break;
      case OrderStatus.processing:
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFFF97316);
        break;
      case OrderStatus.shipped:
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF3B82F6);
        break;
      case OrderStatus.completed:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF10B981);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: text,
        ),
      ),
    );
  }
}

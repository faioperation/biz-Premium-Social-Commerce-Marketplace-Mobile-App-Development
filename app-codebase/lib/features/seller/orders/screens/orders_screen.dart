import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/orders_controller.dart';
import '../models/order_model.dart';
import '../widgets/order_card.dart';
import '../widgets/order_search_bar.dart';
import '../widgets/order_status_tab.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerOrdersController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            _OrdersHeader(isDark: isDark),

            // ── Search Bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SellerSearchBar(
                hintText: 'Search orders...',
                onChanged: (val) => controller.searchQuery.value = val,
              ),
            ),

            const SizedBox(height: 8),

            // ── Status Tabs ──────────────────────────────────────
            _OrdersTabs(controller: controller, isDark: isDark),

            // ── Orders List ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;

                if (orders.isEmpty) {
                  return _EmptyOrdersView(
                    isDark: isDark,
                    tab: controller.selectedTab.value,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return SellerOrderCard(
                      order: order,
                      timeAgo: controller.timeAgo(order.createdAt),
                      onTap: () {
                        context.push(AppRoutes.sellerOrderDetail, extra: order);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header Widget ──────────────────────────────────────────────
class _OrdersHeader extends StatelessWidget {
  final bool isDark;
  const _OrdersHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        'Orders',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// ── Status Tabs Row ────────────────────────────────────────────
class _OrdersTabs extends StatelessWidget {
  final SellerOrdersController controller;
  final bool isDark;

  const _OrdersTabs({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: OrderStatus.values.map((status) {
              final count = controller.ordersList
                  .where((o) => o.status == status)
                  .length;
              return OrderStatusTab(
                status: status,
                selectedStatus: controller.selectedTab.value,
                count: count,
                onTap: () => controller.selectTab(status),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────
class _EmptyOrdersView extends StatelessWidget {
  final bool isDark;
  final OrderStatus tab;

  const _EmptyOrdersView({required this.isDark, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 72,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No ${tab.label} orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders with "${tab.label}" status will appear here.',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Inter',
              color: isDark ? Colors.grey[600] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

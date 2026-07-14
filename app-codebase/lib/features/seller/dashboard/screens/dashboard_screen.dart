import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/seller_dashboard_controller.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/recent_orders_list.dart';
import '../../../../core/constants/app_constants.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerDashboardController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            );
          }

          final data = controller.dashboardData.value;
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No dashboard data found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadDashboardData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshDashboard(),
            color: const Color(0xFF6366F1),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(AppRoutes.sellerSettings);
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stat Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.25,
                    children: [
                      SellerStatCard(
                        title: 'Total Revenue',
                        value: '${AppConstants.currencySymbol}${data.totalRevenue.toStringAsFixed(0).replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            )}',
                        icon: Icons.attach_money,
                        gradientColors: const [
                          Color(0xFF6366F1),
                          Color(0xFF4F46E5),
                        ],
                      ),
                      SellerStatCard(
                        title: 'Orders',
                        value: '${data.ordersCount}',
                        icon: Icons.shopping_cart_outlined,
                        gradientColors: const [
                          Color(0xFFEC4899),
                          Color(0xFFF43F5E),
                        ],
                      ),
                      SellerStatCard(
                        title: 'Followers',
                        value: data.followersCount.toStringAsFixed(0).replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            ),
                        icon: Icons.people_outline,
                        gradientColors: const [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ],
                      ),
                      SellerStatCard(
                        title: 'Total Sales', // Replaced "Store Views" as requested
                        value: data.totalSales.toStringAsFixed(0).replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            ),
                        icon: Icons.trending_up, // Icon representing sales growth
                        gradientColors: const [
                          Color(0xFFF59E0B),
                          Color(0xFFD97706),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Quick Actions
                  SellerQuickActions(
                    onAddProduct: () {
                      context.push(AppRoutes.sellerAddProduct);
                    },
                    onGoLive: () {
                      context.push(AppRoutes.sellerSetupLivestream);
                    },
                    onViewOrders: () {
                      context.go(AppRoutes.sellerOrders);
                    },
                  ),
                  const SizedBox(height: 28),

                  // Revenue Trend Chart
                  SellerRevenueChart(
                    data: data.weeklyRevenueTrend,
                    onViewAll: () {
                      context.push(AppRoutes.sellerRevenueAnalytics);
                    },
                  ),
                  const SizedBox(height: 28),

                  // Recent Orders List
                  SellerRecentOrdersList(orders: data.recentOrders),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

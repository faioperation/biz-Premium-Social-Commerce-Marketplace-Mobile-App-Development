import 'package:get/get.dart';
import '../models/seller_dashboard_model.dart';

class SellerDashboardController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<SellerDashboardModel> dashboardData = Rxn<SellerDashboardModel>();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load dashboard data from API (currently simulated using mock data matching the design)
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate network request delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data populated with the values from the requested UI design
      dashboardData.value = SellerDashboardModel(
        totalRevenue: 45200.0,
        ordersCount: 127,
        followersCount: 2458,
        totalSales: 8932, // Replaced "Store Views" as requested
        weeklyRevenueTrend: [
          4000.0, // Mon
          5200.0, // Tue
          3800.0, // Wed
          6500.0, // Thu
          8000.0, // Fri
          9500.0, // Sat
          7800.0, // Sun
        ],
        recentOrders: [
          DashboardOrderModel(
            orderId: '1001',
            customerName: 'John Smith',
            itemsCount: 2,
            amount: 450.0,
            status: 'new',
          ),
          DashboardOrderModel(
            orderId: '1002',
            customerName: 'John Smith',
            itemsCount: 1,
            amount: 299.0,
            status: 'processing',
          ),
          DashboardOrderModel(
            orderId: '1003',
            customerName: 'John Smith',
            itemsCount: 3,
            amount: 847.0,
            status: 'shipped',
          ),
        ],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Hook to integrate real API later
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}

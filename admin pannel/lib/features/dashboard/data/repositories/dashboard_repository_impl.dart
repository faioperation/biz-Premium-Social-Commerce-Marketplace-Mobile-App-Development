import '../../../../core/network/network_service.dart';
import '../../domain/entities/activity_feed_item.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_stats_model.dart';
import '../models/activity_feed_model.dart';
import '../../../../core/services/currency_formatter.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  // ignore: unused_field — will be used when backend API is connected
  final NetworkService _networkService;

  DashboardRepositoryImpl(this._networkService);

  @override
  Future<DashboardStats> getStats() async {
    // Mock data for development
    await Future.delayed(const Duration(milliseconds: 500));
    return const DashboardStatsModel(
      totalUsers: 15420,
      totalSellers: 842,
      activeLivestreams: 45,
      runningAuctions: 128,
      revenue: 124500.50,
      orders: 3450,
    );
  }

  @override
  Future<List<ActivityFeedItem>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      ActivityFeedModel(id: '1', title: 'New Seller Registered', description: 'TechStore joined the platform.', timestamp: DateTime.now().subtract(const Duration(minutes: 5)), type: 'seller'),
      ActivityFeedModel(id: '2', title: 'New User Joined', description: 'John Doe created an account.', timestamp: DateTime.now().subtract(const Duration(minutes: 15)), type: 'user'),
      ActivityFeedModel(id: '3', title: 'Large Order Placed', description: 'Order #4829 for ${CurrencyFormatter.format(1200, decimalDigits: 0)}.', timestamp: DateTime.now().subtract(const Duration(hours: 1)), type: 'order'),
      ActivityFeedModel(id: '4', title: 'Product Added', description: 'TechStore added "Wireless Earbuds".', timestamp: DateTime.now().subtract(const Duration(hours: 2)), type: 'product'),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getOrdersOverviewData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {'month': 'Jan', 'orders': 120},
      {'month': 'Feb', 'orders': 150},
      {'month': 'Mar', 'orders': 210},
      {'month': 'Apr', 'orders': 180},
      {'month': 'May', 'orders': 250},
      {'month': 'Jun', 'orders': 320},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserGrowthData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {'month': 'Jan', 'users': 1200},
      {'month': 'Feb', 'users': 1500},
      {'month': 'Mar', 'users': 2100},
      {'month': 'Apr', 'users': 1800},
      {'month': 'May', 'users': 2500},
      {'month': 'Jun', 'users': 3200},
    ];
  }
}

import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalUsers,
    required super.totalSellers,
    required super.activeLivestreams,
    required super.runningAuctions,
    required super.revenue,
    required super.orders,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalSellers: json['totalSellers'] ?? 0,
      activeLivestreams: json['activeLivestreams'] ?? 0,
      runningAuctions: json['runningAuctions'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }
}

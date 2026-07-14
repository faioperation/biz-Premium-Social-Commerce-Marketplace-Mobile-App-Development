class DashboardStats {
  final int totalUsers;
  final int totalSellers;
  final int activeLivestreams;
  final int runningAuctions;
  final double revenue;
  final int orders;

  const DashboardStats({
    required this.totalUsers,
    required this.totalSellers,
    required this.activeLivestreams,
    required this.runningAuctions,
    required this.revenue,
    required this.orders,
  });
}

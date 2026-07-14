class DashboardOrderModel {
  final String orderId;
  final String customerName;
  final int itemsCount;
  final double amount;
  final String status; // 'new', 'processing', 'shipped'

  DashboardOrderModel({
    required this.orderId,
    required this.customerName,
    required this.itemsCount,
    required this.amount,
    required this.status,
  });

  factory DashboardOrderModel.fromJson(Map<String, dynamic> json) {
    return DashboardOrderModel(
      orderId: json['orderId'] ?? '',
      customerName: json['customerName'] ?? '',
      itemsCount: json['itemsCount'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'new',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'itemsCount': itemsCount,
      'amount': amount,
      'status': status,
    };
  }
}

class SellerDashboardModel {
  final double totalRevenue;
  final int ordersCount;
  final int followersCount;
  final int totalSales;
  final List<double> weeklyRevenueTrend; // Mon - Sun
  final List<DashboardOrderModel> recentOrders;

  SellerDashboardModel({
    required this.totalRevenue,
    required this.ordersCount,
    required this.followersCount,
    required this.totalSales,
    required this.weeklyRevenueTrend,
    required this.recentOrders,
  });

  factory SellerDashboardModel.fromJson(Map<String, dynamic> json) {
    return SellerDashboardModel(
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      ordersCount: json['ordersCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
      weeklyRevenueTrend: List<double>.from(
        (json['weeklyRevenueTrend'] ?? []).map((x) => x.toDouble()),
      ),
      recentOrders: List<DashboardOrderModel>.from(
        (json['recentOrders'] ?? [])
            .map((x) => DashboardOrderModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'ordersCount': ordersCount,
      'followersCount': followersCount,
      'totalSales': totalSales,
      'weeklyRevenueTrend': weeklyRevenueTrend,
      'recentOrders': recentOrders.map((x) => x.toJson()).toList(),
    };
  }
}

class TopSellingProductModel {
  final String name;
  final int soldCount;
  final double revenue;
  final String image;

  TopSellingProductModel({
    required this.name,
    required this.soldCount,
    required this.revenue,
    required this.image,
  });

  factory TopSellingProductModel.fromJson(Map<String, dynamic> json) {
    return TopSellingProductModel(
      name: json['name'] ?? '',
      soldCount: json['soldCount'] ?? 0,
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'soldCount': soldCount,
      'revenue': revenue,
      'image': image,
    };
  }
}

class RevenueAnalyticsModel {
  final double avgOrderValue;
  final double avgOrderValueGrowth; // e.g. 12 means +12%
  final int totalOrders;
  final double totalOrdersGrowth; // e.g. 8 means +8%
  final List<double> weeklyRevenue; // Mon to Sun
  final List<TopSellingProductModel> topProducts;

  RevenueAnalyticsModel({
    required this.avgOrderValue,
    required this.avgOrderValueGrowth,
    required this.totalOrders,
    required this.totalOrdersGrowth,
    required this.weeklyRevenue,
    required this.topProducts,
  });

  factory RevenueAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return RevenueAnalyticsModel(
      avgOrderValue: (json['avgOrderValue'] ?? 0.0).toDouble(),
      avgOrderValueGrowth: (json['avgOrderValueGrowth'] ?? 0.0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      totalOrdersGrowth: (json['totalOrdersGrowth'] ?? 0.0).toDouble(),
      weeklyRevenue: List<double>.from(
        (json['weeklyRevenue'] ?? []).map((x) => x.toDouble()),
      ),
      topProducts: List<TopSellingProductModel>.from(
        (json['topProducts'] ?? [])
            .map((x) => TopSellingProductModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avgOrderValue': avgOrderValue,
      'avgOrderValueGrowth': avgOrderValueGrowth,
      'totalOrders': totalOrders,
      'totalOrdersGrowth': totalOrdersGrowth,
      'weeklyRevenue': weeklyRevenue,
      'topProducts': topProducts.map((x) => x.toJson()).toList(),
    };
  }
}

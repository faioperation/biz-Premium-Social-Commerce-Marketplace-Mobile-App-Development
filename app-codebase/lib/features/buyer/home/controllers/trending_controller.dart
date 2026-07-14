import 'package:get/get.dart';
import '../models/trending_model.dart';
import 'dart:async';

class TrendingController extends GetxController {
  final RxList<TrendingProductModel> trendingProducts =
      <TrendingProductModel>[].obs;
  final RxString countdownTime = '02:45:32'.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    _startTimer();
  }

  void loadMockData() {
    trendingProducts.assignAll([
      TrendingProductModel(
        id: '1',
        name: 'Smart Watch Ultra',
        currentPrice: 299.0,
        originalPrice: 399.0,
        rating: 4.8,
        soldCount: '2.3K',
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
        discountPercentage: 25,
        isHot: true,
      ),
      TrendingProductModel(
        id: '2',
        name: 'Wireless Headphones',
        currentPrice: 99.0,
        originalPrice: 149.0,
        rating: 4.9,
        soldCount: '5.1K',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
        discountPercentage: 33,
        isHot: true,
      ),
      TrendingProductModel(
        id: '3',
        name: 'Designer Sunglasses',
        currentPrice: 79.0,
        originalPrice: 129.0,
        rating: 4.7,
        soldCount: '1.2K',
        imageUrl:
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&q=80',
        discountPercentage: 38,
      ),
      TrendingProductModel(
        id: '4',
        name: 'Laptop Pro 15"',
        currentPrice: 1299.0,
        originalPrice: 1599.0,
        rating: 4.9,
        soldCount: '850',
        imageUrl:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&q=80',
        discountPercentage: 18,
        isHot: true,
      ),
    ]);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}

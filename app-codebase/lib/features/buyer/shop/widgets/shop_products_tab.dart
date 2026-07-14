import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../discover/widgets/discover_product_card.dart';
import '../controllers/shop_controller.dart';

class ShopProductsTab extends StatelessWidget {
  final ShopController controller;

  const ShopProductsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.shopProducts.isEmpty) {
        return const Center(child: Text('No products available.'));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: controller.shopProducts.length,
        itemBuilder: (context, index) {
          final product = controller.shopProducts[index];
          return DiscoverProductCard(
            product: product,
            onTap: () {
              context.push(AppRoutes.discoverProductDetails, extra: product);
            },
          );
        },
      );
    });
  }
}

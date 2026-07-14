import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trending_controller.dart';
import '../widgets/trending_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class FlashSaleScreen extends StatelessWidget {
  const FlashSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrendingController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: const BackButton(),
        title: Row(
          children: [
            const Icon(Icons.flash_on, color: Color(0xFFF59E0B)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Flash Sale',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsAllLg,
        child: Column(
          children: [
            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.trendingProducts.length,
                itemBuilder: (context, index) {
                  return TrendingProductCard(
                    product: controller.trendingProducts[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

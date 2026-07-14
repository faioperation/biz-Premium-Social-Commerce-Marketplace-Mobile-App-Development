import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/trending_controller.dart';
import '../widgets/trending_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

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
            const Icon(Icons.trending_up, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trending Now',
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
            // Container(
            //   width: double.infinity,
            //   padding: AppSpacing.edgeInsetsAllLg,
            //   decoration: BoxDecoration(
            //     gradient: const LinearGradient(
            //       colors: [Color(0xFF6C4DFF), Color(0xFFFF4FD8)],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     borderRadius: AppSpacing.borderRadiusLg,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const FittedBox(
            //         fit: BoxFit.scaleDown,
            //         child: Row(
            //           children: [
            //             Icon(Icons.flash_on, color: Colors.white),
            //             SizedBox(width: 8),
            //             Text(
            //               'Flash Sale',
            //               style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       const Text(
            //         'Ending in 2h 45m',
            //         style: TextStyle(color: Colors.white70, fontSize: 14),
            //       ),
            //       const SizedBox(height: 16),
            //       Obx(() {
            //         final parts = controller.countdownTime.split(':');
            //         return Row(
            //           children: [
            //             _buildTimerBlock(parts[0]),
            //             const Padding(
            //               padding: EdgeInsets.symmetric(horizontal: 4),
            //               child: Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            //             ),
            //             _buildTimerBlock(parts[1]),
            //             const Padding(
            //               padding: EdgeInsets.symmetric(horizontal: 4),
            //               child: Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            //             ),
            //             _buildTimerBlock(parts[2]),
            //           ],
            //         );
            //       }),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),

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

  Widget _buildTimerBlock(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

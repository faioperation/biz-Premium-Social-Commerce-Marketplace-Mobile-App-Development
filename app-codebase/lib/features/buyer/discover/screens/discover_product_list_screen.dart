import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/discover_controller.dart';
import '../models/category_model.dart';
import '../widgets/discover_product_card.dart';
import '../../../../core/theme/app_spacing.dart';

class DiscoverProductListScreen extends StatelessWidget {
  final CategoryModel? category;

  const DiscoverProductListScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscoverController>();

    final activeCategory = category ?? controller.categories.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categoryProducts = controller.getProductsByCategory(
      activeCategory.id,
    );

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              activeCategory.iconEmoji,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 8),
            Text(
              activeCategory.name,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 8,
              ),
              child: Text(
                'Subcategories',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            Expanded(
              child: categoryProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products available in this category.',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.76,
                          ),
                      itemCount: categoryProducts.length,
                      itemBuilder: (context, index) {
                        final product = categoryProducts[index];
                        return DiscoverProductCard(
                          product: product,
                          onTap: () {
                            context.push(
                              '/buyer/discover/details',
                              extra: product,
                            );
                          },
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

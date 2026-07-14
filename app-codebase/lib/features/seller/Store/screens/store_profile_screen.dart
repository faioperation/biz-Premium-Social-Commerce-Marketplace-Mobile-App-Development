import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/store_controller.dart';
import '../widgets/featured_product_card.dart';
import '../widgets/store_profile_avatar.dart';

class StoreProfileScreen extends StatelessWidget {
  const StoreProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoreController());
    final productsController = Get.put(SellerProductsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Store Profile',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              context.push(AppRoutes.sellerAddProduct);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        final store = controller.store.value;
        if (store == null) {
          return const Center(
            child: Text('Store Profile not found.'),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Banner & Avatar Header Stack
              SizedBox(
                height: 170,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Vibrant Purple-to-Pink Gradient Banner or user's custom cover photo
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        image: store.bannerImagePath != null
                            ? DecorationImage(
                                image: FileImage(File(store.bannerImagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                        gradient: store.bannerImagePath == null
                            ? const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.accentPink,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                    ),
                    // Floating Avatar Box overlapping the banner
                    Positioned(
                      top: 70,
                      left: 24,
                      child: StoreProfileAvatarWidget(
                        initials: store.avatar,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Profile Details & Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    
                    // Store Name
                    Text(
                      store.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Store Category Label
                    Text(
                      store.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkDescription : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Left-aligned horizontal stats row matching design mockup
                    Row(
                      children: [
                        _buildStatItem('2,458', 'Followers', isDark),
                        const SizedBox(width: 24),
                        _buildStatItem('4.8', 'Rating', isDark, isRating: true),
                        const SizedBox(width: 24),
                        Obx(() => _buildStatItem(
                              productsController.productsList.length.toString(),
                              'Products',
                              isDark,
                            )),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action buttons (Share Store & Edit)
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () => controller.shareStore(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Share Store',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => controller.editStore(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
              // Divider to separate featured products section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: isDark
                      ? AppColors.darkBorder
                      : Colors.grey.withValues(alpha: 0.15),
                  thickness: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              // 3. Featured Products section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 2-column Grid of Reusable FeaturedProductCards
                    Obx(() {
                      final products = productsController.productsList;
                      if (products.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No products found. Add products using the + icon above.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.80,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return FeaturedProductCard(
                            product: product,
                            onTap: () {
                              context.push(AppRoutes.sellerAddProduct, extra: product);
                            },
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Helper widget builder for statistical values
  Widget _buildStatItem(String value, String label, bool isDark, {bool isRating = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isRating) ...[
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkDescription : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

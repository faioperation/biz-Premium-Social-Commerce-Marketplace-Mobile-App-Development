import 'package:flutter/material.dart';
import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/discover_controller.dart';
import '../models/discover_product_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/app_share_service.dart';
import '../../checkout/screens/checkout_screen.dart';
import '../../checkout/models/order_item_model.dart';
import '../../profile/controllers/cart_controller.dart';
import '../../profile/controllers/wishlist_controller.dart';
import '../../profile/models/cart_item_model.dart';
import '../../profile/models/wishlist_item_model.dart';
import '../../../../routes/app_routes.dart';

class DiscoverProductDetailsScreen extends StatefulWidget {
  final DiscoverProductModel? product;

  const DiscoverProductDetailsScreen({super.key, this.product});

  @override
  State<DiscoverProductDetailsScreen> createState() =>
      _DiscoverProductDetailsScreenState();
}

class _DiscoverProductDetailsScreenState
    extends State<DiscoverProductDetailsScreen> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DiscoverController>()
        ? Get.find<DiscoverController>()
        : Get.put(DiscoverController());
    final activeProduct = widget.product ?? controller.products.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'product-img-${activeProduct.id}',
                  child: Image.network(
                    activeProduct.imageUrl,
                    height: 380,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 380,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF13101E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      Text(
                        activeProduct.name,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${activeProduct.rating}',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${activeProduct.reviewCount} reviews) • ${activeProduct.soldCount ~/ 1000}K sold',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Text(
                            '${AppConstants.currencySymbol}${activeProduct.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${AppConstants.currencySymbol}${activeProduct.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${activeProduct.discountPercentage}% OFF',
                              style: const TextStyle(
                                color: Color(0xFFEA580C),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: () {
                          context.push(
                            AppRoutes.shopProfile,
                            extra: {
                              'sellerName': activeProduct.sellerName,
                              'profileImageUrl':
                                  activeProduct.sellerProfileImage,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.03)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  activeProduct.sellerProfileImage,
                                ),
                                onBackgroundImageError: (e, s) =>
                                    const Icon(Icons.person),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeProduct.sellerName,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.orangeAccent,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${activeProduct.sellerRating} rating',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isFollowing = !_isFollowing;
                                  });
                                  Get.snackbar(
                                    _isFollowing
                                        ? 'Following Shop'
                                        : 'Unfollowed Shop',
                                    _isFollowing
                                        ? 'You are now following ${activeProduct.sellerName}!'
                                        : 'You unfollowed.',
                                    backgroundColor: const Color(0xFF6C4DFF),
                                    colorText: Colors.white,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFollowing
                                      ? Colors.grey[400]
                                      : const Color(0xFF6C4DFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                ),
                                child: Text(
                                  _isFollowing ? 'Following' : 'Follow',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHighlightItem(
                            Icons.local_shipping_outlined,
                            'Free Shipping',
                            isDark,
                          ),
                          _buildHighlightItem(
                            Icons.shield_outlined,
                            'Warranty',
                            isDark,
                          ),
                          _buildHighlightItem(
                            Icons.replay_circle_filled_rounded,
                            '30-Day Return',
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Description',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activeProduct.description,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.black87,
                          size: 18,
                        ),
                        onPressed: () => AppShareService.shareProduct(
                          productId: activeProduct.id,
                          productName: activeProduct.name,
                          price: activeProduct.price,
                          sellerName: activeProduct.sellerName,
                          context: context,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final wishlistCtrl = Get.put(WishlistController());
                      final bool isLiked = wishlistCtrl.isItemInWishlist(
                        activeProduct.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          if (isLiked) {
                            wishlistCtrl.removeItem(activeProduct.id);
                          } else {
                            wishlistCtrl.addItem(
                              WishlistItemModel(
                                productId: activeProduct.id,
                                name: activeProduct.name,
                                imageUrl: activeProduct.imageUrl,
                                price: activeProduct.price,
                                originalPrice: activeProduct.originalPrice,
                                isInStock: activeProduct.availableQuantity > 0,
                              ),
                            );
                            Get.snackbar(
                              'Added to Wishlist',
                              '${activeProduct.name} added to your wishlist.',
                              backgroundColor: Colors.pinkAccent,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                            context.push(AppRoutes.profileWishlist);
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: isLiked ? Colors.pink : Colors.black87,
                            size: 18,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF13101E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey[200]!,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF6C4DFF),
                            width: 1.5,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final cartCtrl = Get.put(CartController());
                            cartCtrl.addItem(
                              CartItemModel(
                                productId: activeProduct.id,
                                name: activeProduct.name,
                                sellerName: activeProduct.sellerName,
                                imageUrl: activeProduct.imageUrl,
                                price: activeProduct.price,
                                quantity: 1,
                              ),
                            );
                            Get.snackbar(
                              'Added to Cart',
                              '${activeProduct.name} successfully added to your shopping cart!',
                              backgroundColor: Colors.green.withValues(
                                alpha: 0.9,
                              ),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                            context.push(AppRoutes.profileCart);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Color(0xFF6C4DFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C4DFF), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF6C4DFF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  buyNowItem: OrderItemModel(
                                    productId: activeProduct.id,
                                    name: activeProduct.name,
                                    imageUrl: activeProduct.imageUrl,
                                    price: activeProduct.price,
                                    quantity: 1,
                                  ),
                                ),
                                settings: const RouteSettings(
                                  name: '/checkout',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF6C4DFF), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

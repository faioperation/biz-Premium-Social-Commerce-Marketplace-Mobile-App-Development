import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../routes/app_routes.dart';
import '../../profile/controllers/cart_controller.dart';
import '../../profile/models/cart_item_model.dart';
import '../controllers/live_sell_controller.dart';
import '../models/live_product_model.dart';
import 'live_product_detail_sheet.dart';

class LiveShoppingBasketSheet extends StatelessWidget {
  final LiveSellController controller;
  final String sellerName;
  final String sellerProfileImage;

  const LiveShoppingBasketSheet({
    super.key,
    required this.controller,
    required this.sellerName,
    required this.sellerProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${sellerName.toLowerCase().replaceAll(' ', '')}'s showcase",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right_rounded, color: Colors.black54, size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Text(
                      //   '174.2K followers  |  123.4K sold',
                      //   style: TextStyle(
                      //     color: Colors.grey.shade500,
                      //     fontSize: 11,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Top-right action icons
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87, size: 20),
                          onPressed: () {
                            Navigator.pop(context);
                            context.push(AppRoutes.profileCart);
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        Obx(() {
                          final count = cartController.totalItemCount;
                          if (count == 0) return const SizedBox.shrink();
                          return Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF42F63),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F5)),

          // Product List
          Expanded(
            child: Obx(() {
              if (controller.liveProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'No products in this showcase',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.liveProducts.length,
                itemBuilder: (context, index) {
                  final LiveProductModel product = controller.liveProducts[index];
                  return GestureDetector(
                    onTap: () => _showProductDetail(context, product),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade100,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail Image with Index Badge
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 86,
                                  height: 86,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 86,
                                    height: 86,
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                  ),
                                ),
                              ),
                              // Product Number Badge
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    '${product.number}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Product Info details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Delivery and Returns Badges
                                // Row(
                                //   children: [
                                //     if (product.deliveryOption != null)
                                //       Container(
                                //         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                //         decoration: BoxDecoration(
                                //           color: const Color(0xFFE2F9F3),
                                //           borderRadius: BorderRadius.circular(4),
                                //         ),
                                //         child: const Row(
                                //           children: [
                                //             Icon(Icons.local_shipping_outlined, color: Colors.teal, size: 10),
                                //             SizedBox(width: 2),
                                //             Text(
                                //               'Free 3-day delivery',
                                //               style: TextStyle(
                                //                 color: Colors.teal,
                                //                 fontSize: 8,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //   ],
                                // ),
                                const SizedBox(height: 6),

                                // Price & Buy Actions row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // Quick Cart Add button
                                        GestureDetector(
                                          onTap: () {
                                            cartController.addItem(
                                              CartItemModel(
                                                productId: product.id,
                                                name: product.title,
                                                sellerName: sellerName,
                                                imageUrl: product.imageUrl,
                                                price: product.price,
                                                quantity: 1,
                                              ),
                                            );
                                            Get.snackbar(
                                              'Added to cart',
                                              '${product.title} added to basket!',
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black87,
                                              colorText: Colors.white,
                                              duration: const Duration(seconds: 1),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300, width: 1.0),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            // child: const Icon(
                                            //   Icons.add_shopping_cart_rounded,
                                            //   color: Colors.black87,
                                            //   size: 16,
                                            // ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // Buy Button
                                        ElevatedButton(
                                          onPressed: () => _showProductDetail(context, product),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFF42F63),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: const Text(
                                            'Buy',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, LiveProductModel product) {
    // Dismiss the showcase sheet before opening details sheet (matching app UX)
    Navigator.pop(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black45,
      builder: (context) {
        return LiveProductDetailSheet(
          product: product,
          sellerName: sellerName,
          sellerProfileImage: sellerProfileImage,
        );
      },
    );
  }
}

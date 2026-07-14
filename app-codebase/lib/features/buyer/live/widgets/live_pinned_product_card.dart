import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/live_product_model.dart';

class LivePinnedProductCard extends StatelessWidget {
  final LiveProductModel product;
  final VoidCallback onBuyPressed;
  final VoidCallback onClosePressed;

  const LivePinnedProductCard({
    super.key,
    required this.product,
    required this.onBuyPressed,
    required this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Close button at top right
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: onClosePressed,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Thumbnail with Product Number Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                    // Product Index Badge (e.g. 3)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),

                // Middle Info: Title, Flash sale description, price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (product.flashSaleText != null)
                        // Text(
                        //   product.flashSaleText!,
                        //   style: const TextStyle(
                        //     color: Color(0xFFF42F63),
                        //     fontSize: 9,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),

                // Right Buy Button
                ElevatedButton(
                  onPressed: onBuyPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF42F63),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Buy',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

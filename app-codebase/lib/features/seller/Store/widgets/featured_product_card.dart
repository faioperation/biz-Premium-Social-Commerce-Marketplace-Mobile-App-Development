import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../products/models/product_model.dart';

/// A reusable, highly stylized product card designed for the Store's grid.
/// Features a centered product image container, descriptive titles,
/// and bold local currency pricing formatted in Bengali Taka (৳).
class FeaturedProductCard extends StatelessWidget {
  final SellerProductModel product;
  final VoidCallback? onTap;

  const FeaturedProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped on "${product.name}"'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(milliseconds: 1000),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : Colors.grey.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Centered Image Container
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF3F4F6), // Cool light grey background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: product.image.startsWith('http')
                      ? Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.shopping_bag_outlined, size: 36);
                          },
                        )
                      : (product.image.isNotEmpty && !product.image.startsWith('http') && File(product.image).existsSync())
                          ? Image.file(
                              File(product.image),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.shopping_bag_outlined, size: 36);
                              },
                            )
                          : Text(
                              product.image.isNotEmpty ? product.image : '📦',
                              style: const TextStyle(fontSize: 48),
                            ),
                ),
              ),
            ),
            
            // 2. Product Details
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTitle : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

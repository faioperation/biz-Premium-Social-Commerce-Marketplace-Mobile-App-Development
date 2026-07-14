import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../../../../core/constants/app_constants.dart';

class SellerProductCard extends StatelessWidget {
  final SellerProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SellerProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 72,
                  height: 72,
                  color: isDark ? Colors.grey[850] : const Color(0xFFF3F4F6),
                  child: product.image.startsWith('http')
                      ? Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shopping_bag_outlined,
                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                              size: 24,
                            );
                          },
                        )
                      : Image.file(
                          File(product.image),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shopping_bag_outlined,
                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                              size: 24,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Three dots menu
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Icon(
                        //     Icons.more_vert,
                        //     color: isDark ? Colors.grey[400] : Colors.grey[600],
                        //     size: 20,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        Row(
                          children: [
                            if (product.isOutOfStock)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Out of stock',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF4444),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              )
                            else
                              Text(
                                '${product.stock} in stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            const SizedBox(width: 8),
                            // Icon(
                            //   Icons.qr_code_2,
                            //   color: const Color(0xFF6366F1).withValues(alpha: 0.8),
                            //   size: 18,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2), // Pink background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444), // Red trash icon
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

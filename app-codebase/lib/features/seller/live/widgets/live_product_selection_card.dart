import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../Store/models/store_model.dart';
import '../../../../core/theme/app_colors.dart';

/// A card widget with a checkbox, design to let sellers select products
/// to feature in their upcoming livestream.
class LiveProductSelectionCard extends StatelessWidget {
  final StoreProductModel product;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const LiveProductSelectionCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color cardColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color subtextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final Color emojiBgColor = isDark ? const Color(0xFF13131A) : const Color(0xFFF3F4F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : borderColor,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Custom styled Checkbox (matches mockup exactly)
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: isDark ? const Color(0xFF4E4E58) : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
              ),
              const SizedBox(width: 12),
              
              // Product Emoji Avatar box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: emojiBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  product.image,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.currencySymbol}${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : subtextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

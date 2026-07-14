import 'package:flutter/material.dart';
import '../../live/models/live_session_data.dart';
import '../../../../core/theme/app_colors.dart';

/// A bottom sheet/drawer widget showcasing products promoted during a past live stream.
class PlaybackProductSheet extends StatelessWidget {
  final List<LiveStreamProduct> products;
  final LiveType liveType;

  const PlaybackProductSheet({
    super.key,
    required this.products,
    required this.liveType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color cardBg = isDark ? const Color(0xFF1E1E22) : const Color(0xFFF9FAFB);
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white30 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products (${products.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: textSecondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'No products were featured in this stream.',
                  style: TextStyle(color: textSecondaryColor),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  
                  // Mock conversion details specific to the stream type
                  final clicks = 120 + (index * 42);
                  final conversions = 15 + (index * 8);
                  final auctionBids = 8 + (index * 5);
                  final highestBid = product.price + 50.0 + (index * 30.0);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Emoji/Image Bubble
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            product.image,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Product details and conversion stats
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Original Price: \$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Conversion stats badges
                              Row(
                                children: [
                                  _buildStatBadge(
                                    label: 'Clicks: $clicks',
                                    color: Colors.blue.withValues(alpha: 0.15),
                                    textColor: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  if (liveType == LiveType.sell)
                                    _buildStatBadge(
                                      label: 'Sales: $conversions units',
                                      color: Colors.green.withValues(alpha: 0.15),
                                      textColor: Colors.green,
                                    )
                                  else
                                    _buildStatBadge(
                                      label: 'Bids: $auctionBids bids',
                                      color: Colors.amber.withValues(alpha: 0.15),
                                      textColor: Colors.amber.shade800,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Final results
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (liveType == LiveType.sell) ...[
                              const Text(
                                'Revenue',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                '\$${(product.price * conversions).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ] else ...[
                              const Text(
                                'Winning Bid',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                '\$${highestBid.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

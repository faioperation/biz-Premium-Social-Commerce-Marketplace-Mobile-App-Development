import 'package:flutter/material.dart';
import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AuctionStatsCard extends StatelessWidget {
  final String previewImageUrl;
  final double currentBid;
  final String highestBidder;
  final int totalBids;
  final int secondsRemaining;
  final VoidCallback onPlaceBidPressed;

  const AuctionStatsCard({
    super.key,
    required this.previewImageUrl,
    required this.currentBid,
    required this.highestBidder,
    required this.totalBids,
    required this.secondsRemaining,
    required this.onPlaceBidPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isAuctionEnded = secondsRemaining <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A29).withValues(alpha: 0.95),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.accentPink.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPink.withValues(alpha: 0.25),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orangeAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'LIVE AUCTION',
                    style: TextStyle(
                      color: Colors.orangeAccent[100],
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      color: Colors.redAccent,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      !isAuctionEnded
                          ? '00:${secondsRemaining.toString().padLeft(2, '0')}'
                          : 'ENDED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  previewImageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, stack) => Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.phone_iphone,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'iPhone 15 Pro Max 256GB',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Current Bid: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${AppConstants.currencySymbol}${currentBid.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Highest Bidder', highestBidder),
              _buildStatColumn('Total Bids', '$totalBids'),
              _buildStatColumn(
                'Starting Price',
                '${AppConstants.currencySymbol}350',
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE11D48), Color(0xFFDB2777)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDB2777).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isAuctionEnded ? null : onPlaceBidPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.trending_up, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isAuctionEnded ? 'Auction Ended' : 'Place Bid',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

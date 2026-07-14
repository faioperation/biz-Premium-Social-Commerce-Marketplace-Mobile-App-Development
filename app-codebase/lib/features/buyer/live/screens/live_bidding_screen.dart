import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../../core/services/app_share_service.dart';
import '../../../../routes/app_routes.dart';
import '../../profile/controllers/cart_controller.dart';
import '../../profile/models/cart_item_model.dart';
import '../../checkout/models/order_item_model.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_bidding_controller.dart';
import '../widgets/live_bid_bubble.dart';
import '../widgets/auction_stats_card.dart';
import '../widgets/congratulations_dialog.dart';
import '../widgets/auction_ended_banner.dart';
import '../widgets/place_bid_bottom_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/live_video_simulator.dart';
import '../widgets/live_duration_timer.dart';

class LiveBiddingScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveBiddingScreen({super.key, required this.stream});

  void _showCongratulationsDialog(
    BuildContext context,
    LiveBiddingController controller,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratulationsDialog(
          previewImageUrl: stream.previewImageUrl,
          winningBid: controller.currentBid.value,
          onProceedToPayment: () {
            Navigator.of(context).pop();
            Get.snackbar(
              'Payment Required',
              'Please complete payment immediately to secure your item',
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
            );
            
            // Create the item models
            final winningBid = controller.currentBid.value;
            final productName = 'iPhone 15 Pro Max 256GB'; // Static mock based on CongratulationsDialog
            
            final cartItem = CartItemModel(
              productId: stream.id,
              name: productName,
              sellerName: stream.sellerName,
              imageUrl: stream.previewImageUrl,
              price: winningBid,
              quantity: 1,
            );
            
            final orderItem = OrderItemModel(
              productId: stream.id,
              name: productName,
              imageUrl: stream.previewImageUrl,
              price: winningBid,
              quantity: 1,
            );
            
            // Add to cart so it stays if they abandon checkout
            if (!Get.isRegistered<CartController>()) {
              Get.put(CartController());
            }
            Get.find<CartController>().addItem(cartItem);
            
            // Navigate to checkout passing the bid amount as buyNowItem
            context.push(AppRoutes.checkout, extra: orderItem);
          },
        );
      },
    );
  }

  void _openBidBottomSheet(
    BuildContext context,
    LiveBiddingController controller,
    LiveVideoSimulatorController simulatorController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PlaceBidBottomSheet(
          currentBid: controller.currentBid.value,
          onBidConfirmed: (amount) {
            controller.placeBid(amount);
            simulatorController.triggerReaction('🔥');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveBiddingController());
    final simulatorController = LiveVideoSimulatorController();

    controller.onAuctionWonCallback = () =>
        _showCongratulationsDialog(context, controller);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: LiveVideoSimulator(
              imageUrl: stream.previewImageUrl,
              controller: simulatorController,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: AppSpacing.edgeInsetsAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  stream.sellerProfileImage,
                                ),
                                onBackgroundImageError: (e, s) =>
                                    const Icon(Icons.person),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            stream.sellerName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Colors.blueAccent,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.liveBadge.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: AppColors.liveBadge.withOpacity(0.4),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const _PulsingDot(),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  'LIVE',
                                                  style: TextStyle(
                                                    color: AppColors.liveBadge,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Container(width: 1, height: 6, color: AppColors.liveBadge.withOpacity(0.4)),
                                                const SizedBox(width: 4),
                                                const LiveDurationTimer(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            size: 10,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            stream.viewerCount,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '•',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 8,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 2),
                                          const Text(
                                            '4.9',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() => GestureDetector(
                                onTap: () => controller.toggleFollow(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.isFollowing.value
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: controller.isFollowing.value
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    controller.isFollowing.value ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          tooltip: 'Reset Demo Auction',
                          onPressed: controller.resetAuction,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            AppShareService.shareLiveAuction(
                              streamId: stream.id,
                              title: stream.title,
                              sellerName: stream.sellerName,
                              context: context,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                            stops: [0.0, 0.15],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Obx(
                          () => ListView.builder(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.activities.length,
                            itemBuilder: (context, index) {
                              final act = controller.activities[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: LiveBidBubble(
                                  username: act.username,
                                  text: act.text,
                                  isBid: act.isBid,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => AuctionStatsCard(
                      previewImageUrl: stream.previewImageUrl,
                      currentBid: controller.currentBid.value,
                      highestBidder: controller.highestBidder.value,
                      totalBids: controller.totalBids.value,
                      secondsRemaining: controller.secondsRemaining.value,
                      onPlaceBidPressed: () =>
                          _openBidBottomSheet(context, controller, simulatorController),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.accentPink.withValues(alpha: 0.5),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPink.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  enabled: true, // Always enabled
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  onSubmitted: (_) {
                                    final text = controller.commentController.text.trim();
                                    controller.addComment();
                                    if (text.isNotEmpty) {
                                      simulatorController.triggerReaction('💬');
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final text = controller.commentController.text.trim();
                                  controller.addComment();
                                  if (text.isNotEmpty) {
                                    simulatorController.triggerReaction('💬');
                                  }
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentPink,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3DF42F63),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          controller.toggleLike();
                          simulatorController.triggerReaction('❤️');
                        },
                        child: Obx(
                          () => CircleAvatar(
                            radius: 24,
                            backgroundColor: controller.isLiked.value
                                ? Colors.pink.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.5),
                            child: Icon(
                              controller.isLiked.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Obx(() {
            if (controller.showEndBanner.value) {
              return Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: AuctionEndedBanner(
                  highestBidder: controller.highestBidder.value,
                  finalBid: controller.currentBid.value,
                  onClosePressed: () {
                    controller.showEndBanner.value = false;
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF42F63),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF42F63).withOpacity(0.2 + 0.8 * _controller.value),
                blurRadius: 3 + 3 * _controller.value,
                spreadRadius: 1 + 1 * _controller.value,
              )
            ],
          ),
        );
      },
    );
  }
}

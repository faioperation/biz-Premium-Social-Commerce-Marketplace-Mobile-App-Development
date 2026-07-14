import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../../core/services/app_share_service.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_sell_controller.dart';
import '../widgets/live_comment_bubble.dart';
import '../widgets/live_pinned_product_card.dart';
import '../widgets/live_shopping_basket_sheet.dart';
import '../widgets/live_product_detail_sheet.dart';
import '../models/live_product_model.dart';
import '../widgets/live_video_simulator.dart';
import '../widgets/live_duration_timer.dart';

class LiveSellScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveSellScreen({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveSellController());
    final showEmojiBar = false.obs;
    final simulatorController = LiveVideoSimulatorController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Video Feed (Simulated Animated Video)
          Positioned.fill(
            child: LiveVideoSimulator(
              imageUrl: stream.previewImageUrl,
              controller: simulatorController,
            ),
          ),

          // 3. Main Live Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP BAR ROW ---
                  Row(
                    children: [
                      // LEFT: Profile Info Pill
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(stream.sellerProfileImage),
                                onBackgroundImageError: (e, s) =>
                                    const Icon(Icons.person, size: 14),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      stream.sellerName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.favorite, color: Colors.white70, size: 8),
                                        const SizedBox(width: 2),
                                        Text(
                                          '10.4K',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.8),
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // CENTER: LIVE + Timer badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF42F63).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF42F63).withValues(alpha: 0.4), width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PulsingDot(),
                            SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Color(0xFFF42F63),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            LiveDurationTimer(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // RIGHT: Viewer Count + Close Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              stream.viewerCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close Button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Spacer(),

                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                          stops: [0.0, 0.25],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Obx(
                        () => ListView.builder(
                          controller: controller.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final item = controller.comments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: LiveCommentBubble(
                                username: item.username,
                                comment: item.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // 2. Seller Pinned Product Card (Screenshot 1: bottom floating card)
                  Obx(() {
                    final product = controller.pinnedProduct.value;
                    if (product == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: LivePinnedProductCard(
                        product: product,
                        onBuyPressed: () => _showProductDetail(context, product),
                        onClosePressed: () => controller.pinProduct(null),
                      ),
                    );
                  }),

                  // 3. Emoji Picker Quick Bar (Toggled on/off)
                  Obx(() {
                    if (!showEmojiBar.value) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: ['😀', '😍', '🔥', '👏', '❤️'].map((emoji) {
                          return GestureDetector(
                            onTap: () {
                              controller.sendEmoji(emoji);
                              showEmojiBar.value = false;
                              simulatorController.triggerReaction(emoji);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(emoji, style: const TextStyle(fontSize: 18)),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),


                  // 4. Comment Input & Action Row

                  // ===============================
// FACEBOOK / TIKTOK STYLE
// COMMENT INPUT BAR
// ===============================

                  SizedBox(
                    height: 56,

                    child: ListView(
                      scrollDirection: Axis.horizontal,

                      children: [

                        const SizedBox(width: 4),

                        /// =========================
                        /// COMMENT INPUT BOX
                        /// =========================

                        Container(
                          width: MediaQuery.of(context).size.width * 0.68,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),

                            borderRadius: BorderRadius.circular(30),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),

                          child: Row(
                            children: [

                              /// =========================
                              /// SHOPPING BAG BUTTON
                              /// =========================

                              GestureDetector(
                                onTap: () =>
                                    _showLiveShoppingBasket(context, controller),

                                child: Container(
                                  height: 36,
                                  width: 36,

                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),

                                  child: Stack(
                                    alignment: Alignment.center,

                                    children: [

                                      const Icon(
                                        Icons.shopping_bag_rounded,
                                        color: Colors.orange,
                                        size: 18,
                                      ),

                                      Positioned(
                                        right: 0,
                                        top: 0,

                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                            vertical: 1,
                                          ),

                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF42F63),
                                            borderRadius: BorderRadius.circular(10),
                                          ),

                                          child: const Text(
                                            '99+',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// =========================
                              /// TEXT FIELD
                              /// =========================

                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,

                                  minLines: 1,
                                  maxLines: 4,

                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    height: 1.5,
                                  ),

                                  cursorColor: Colors.white,

                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 15,
                                    ),

                                    border: InputBorder.none,

                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              /// =========================
                              /// SEND BUTTON
                              /// =========================

                              GestureDetector(
                                onTap: () {
                                  final text = controller.commentController.text.trim();
                                  controller.addComment();
                                  if (text.isNotEmpty) {
                                    simulatorController.triggerReaction('💬');
                                  }
                                },

                                child: Container(
                                  height: 38,
                                  width: 38,

                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF42F63),
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// =========================
                        /// EMOJI BUTTON
                        /// =========================

                        _buildBottomActionIcon(
                          icon: Icons.sentiment_satisfied_alt_rounded,
                          onTap: () => showEmojiBar.toggle(),
                        ),

                        const SizedBox(width: 8),

                        /// =========================
                        /// CO HOST BUTTON
                        /// =========================

                        _buildBottomActionIcon(
                          icon: Icons.people_outline_rounded,

                          onTap: () {
                            Get.snackbar(
                              'Co-Host Request',
                              'Sending request to connect with the host...',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black87,
                              colorText: Colors.white,
                            );
                          },
                        ),

                        const SizedBox(width: 8),

                        /// =========================
                        /// ROSE BUTTON
                        /// =========================

                        _buildBottomActionIcon(
                          icon: Icons.local_florist_rounded,

                          customWidget: const Text(
                            '🌹',
                            style: TextStyle(fontSize: 15),
                          ),

                          onTap: () {
                            controller.sendRose();
                            simulatorController.triggerReaction('🌹');
                          },
                        ),

                        const SizedBox(width: 8),

                        /// =========================
                        /// GIFT BUTTON
                        /// =========================

                        _buildBottomActionIcon(
                          icon: Icons.card_giftcard_rounded,

                          customWidget: const Text(
                            '🎁',
                            style: TextStyle(fontSize: 15),
                          ),

                          onTap: () {
                            controller.sendGift();
                            simulatorController.triggerReaction('🎁');
                          },
                        ),

                        const SizedBox(width: 8),

                        /// =========================
                        /// SHARE BUTTON
                        /// =========================

                        GestureDetector(
                          onTap: () {
                            AppShareService.shareLiveStream(
                              streamId: stream.id,
                              title: stream.title,
                              sellerName: stream.sellerName,
                              context: context,
                            );
                          },

                          child: Container(
                            height: 40,
                            width: 40,

                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),

                            child: Stack(
                              alignment: Alignment.center,

                              children: [

                                const Icon(
                                  Icons.reply_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),

                                Positioned(
                                  bottom: 2,

                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                      vertical: 1,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),

                                    child: const Text(
                                      '102',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionIcon({
    required IconData icon,
    Widget? customWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: customWidget ?? Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  void _showLiveShoppingBasket(BuildContext context, LiveSellController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return LiveShoppingBasketSheet(
          controller: controller,
          sellerName: stream.sellerName,
          sellerProfileImage: stream.sellerProfileImage,
        );
      },
    );
  }

  void _showProductDetail(BuildContext context, LiveProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black45,
      builder: (context) {
        return LiveProductDetailSheet(
          product: product,
          sellerName: stream.sellerName,
          sellerProfileImage: stream.sellerProfileImage,
        );
      },
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
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF42F63),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF42F63).withOpacity(0.2 + 0.8 * _controller.value),
                blurRadius: 4 + 4 * _controller.value,
                spreadRadius: 1 + 2 * _controller.value,
              )
            ],
          ),
        );
      },
    );
  }
}

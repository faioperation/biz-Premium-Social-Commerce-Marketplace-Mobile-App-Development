import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/past_live_stream_model.dart';
import '../controllers/seller_past_live_playback_controller.dart';
import '../widgets/playback_comment_card.dart';
import '../widgets/playback_product_sheet.dart';
import '../widgets/rising_heart.dart';
import '../widgets/playback_activity_log.dart';
import '../widgets/playback_interactive_input.dart';

/// The high-fidelity playback details view of a seller's recorded live stream.
/// This screen acts purely as a layout coordinator — all heavy UI logic lives
/// inside the dedicated widget files under liveList/widgets/.
class SellerPastLivePlaybackScreen extends StatefulWidget {
  final PastLiveStreamModel pastLive;

  const SellerPastLivePlaybackScreen({
    super.key,
    required this.pastLive,
  });

  @override
  State<SellerPastLivePlaybackScreen> createState() =>
      _SellerPastLivePlaybackScreenState();
}

class _SellerPastLivePlaybackScreenState
    extends State<SellerPastLivePlaybackScreen> {
  late final SellerPastLivePlaybackController _controller;
  final ScrollController _chatScrollController = ScrollController();
  final RxString _activeTab = 'Activity'.obs; // 'Activity' or 'Products'

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      SellerPastLivePlaybackController(widget.pastLive),
      tag: widget.pastLive.id,
    );

    // Auto-scroll live chat overlay when comments appear
    _controller.activeComments.listen((_) {
      if (_chatScrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    Get.delete<SellerPastLivePlaybackController>(tag: widget.pastLive.id);
    _chatScrollController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatTime(int totalSecs) {
    final m = totalSecs ~/ 60;
    final s = totalSecs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _handleCommentTap(int timelineSeconds) {
    _controller.seekTo(timelineSeconds.toDouble());
    if (!_controller.isPlaying.value) _controller.startPlayback();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Jumped to ${_formatTime(timelineSeconds)}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 700),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final player = _buildPlayerViewport(isDark, textSecondaryColor);
    final panel = _buildDetailPanel(
        isDark, cardColor, borderColor, textColor, textSecondaryColor);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.pastLive.title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: isLandscape
          ? Row(children: [
              Expanded(flex: 6, child: player),
              Container(width: 1, color: borderColor),
              Expanded(flex: 5, child: panel),
            ])
          : Column(children: [
              Expanded(flex: 9, child: player),
              Container(height: 1, color: borderColor),
              Expanded(flex: 10, child: panel),
            ]),
    );
  }

  // ── Player viewport ───────────────────────────────────────────────────────

  Widget _buildPlayerViewport(bool isDark, Color textSecondaryColor) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // A. Animated HSL gradient video simulation
          Obx(() {
            final hueShift = (_controller.playbackSeconds.value * 8) % 360;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromAHSL(1.0, hueShift.toDouble(), 0.45, 0.25)
                        .toColor(),
                    const Color(0xFF14141A),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Icon(
                          _controller.isPlaying.value
                              ? Icons.videocam_rounded
                              : Icons.play_circle_fill_rounded,
                          size: 56,
                          color: Colors.white24,
                        )),
                    const SizedBox(height: 8),
                    const Text(
                      'Recorded Livestream',
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }),

          // B. Vignette overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // C. Live chat overlay (scrolling real-time comments)
          Positioned(
            left: 12,
            bottom: 48,
            width: 250,
            height: 180,
            child: Obx(() {
              final comments = _controller.activeComments;
              if (comments.isEmpty) return const SizedBox();
              return ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                  stops: [0.0, 0.25],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.only(top: 24),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return PlaybackCommentCard(
                      key: ValueKey(c.id),
                      comment: c,
                      onLike: () => _controller.toggleLikeComment(c.id),
                      onReply: () =>
                          _controller.replyingToComment.value = c,
                      onLikeReply: (rId) =>
                          _controller.toggleLikeComment(rId, parentId: c.id),
                    );
                  },
                ),
              );
            }),
          ),

          // D. Featured product banner
          Obx(() {
            if (_controller.activeProductId.value == null ||
                widget.pastLive.products.isEmpty) {
              return const SizedBox();
            }
            final product = widget.pastLive.products.firstWhere(
                (p) => p.id == _controller.activeProductId.value);
            return Positioned(
              left: 12,
              top: 12,
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => PlaybackProductSheet(
                    products: widget.pastLive.products,
                    liveType: widget.pastLive.liveType,
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white30, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(product.image,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(children: [
                            Icon(Icons.sell_rounded,
                                color: Color(0xFF10B981), size: 10),
                            SizedBox(width: 4),
                            Text('FEATURED',
                                style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900)),
                          ]),
                          Text(product.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // E. Floating hearts canvas
          Positioned(
            right: 12,
            bottom: 48,
            width: 80,
            height: 200,
            child: Obx(() => Stack(
                  children: _controller.floatingHearts
                      .map((id) => RisingHeart(key: ValueKey(id)))
                      .toList(),
                )),
          ),

          // F. Heart trigger button
          Positioned(
            right: 12,
            bottom: 48,
            child: FloatingActionButton.small(
              onPressed: _controller.triggerHeart,
              backgroundColor: Colors.pink.withValues(alpha: 0.8),
              elevation: 0,
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
          ),

          // G. Playback controls bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Obx(() => GestureDetector(
                        onTap: _controller.togglePlayPause,
                        child: Icon(
                          _controller.isPlaying.value
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() {
                      final current =
                          _controller.playbackSeconds.value.toDouble();
                      final max =
                          widget.pastLive.duration.inSeconds.toDouble();
                      return SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: AppColors.primary,
                        ),
                        child: Slider(
                          value: current.clamp(0.0, max),
                          min: 0.0,
                          max: max,
                          onChanged: _controller.seekTo,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                        '${_formatTime(_controller.playbackSeconds.value)} '
                        '/ ${_formatTime(widget.pastLive.duration.inSeconds)}',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Detail panel (tabs + input) ───────────────────────────────────────────

  Widget _buildDetailPanel(
    bool isDark,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color textSecondaryColor,
  ) {
    return Container(
      color: isDark ? const Color(0xFF141416) : Colors.white,
      child: Column(
        children: [
          // Tab selector
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                _TabButton(
                    label: 'Activity',
                    icon: Icons.forum_rounded,
                    activeTab: _activeTab),
                _TabButton(
                    label: 'Products',
                    icon: Icons.shopping_bag_rounded,
                    activeTab: _activeTab),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: Obx(() {
              if (_activeTab.value == 'Activity') {
                return PlaybackActivityLog(
                  pastLive: widget.pastLive,
                  onCommentTap: _handleCommentTap,
                  isDark: isDark,
                  textColor: textColor,
                  textSecondaryColor: textSecondaryColor,
                  borderColor: borderColor,
                );
              }
              return PlaybackProductSheet(
                products: widget.pastLive.products,
                liveType: widget.pastLive.liveType,
              );
            }),
          ),

          // Persistent comment input footer
          Obx(() {
            final replyTarget = _controller.replyingToComment.value;
            return PlaybackInteractiveInput(
              replyingToUserName: replyTarget?.userName,
              replyingToMessage: replyTarget?.message,
              onCancelReply: () =>
                  _controller.replyingToComment.value = null,
              onSend: _controller.sendPlaybackComment,
              isDark: isDark,
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
              textSecondaryColor: textSecondaryColor,
            );
          }),
        ],
      ),
    );
  }
}

// ── Private tab button ────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final RxString activeTab;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final selected = activeTab.value == label;
        return InkWell(
          onTap: () => activeTab.value = label,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 16,
                    color: selected ? AppColors.primary : Colors.grey),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

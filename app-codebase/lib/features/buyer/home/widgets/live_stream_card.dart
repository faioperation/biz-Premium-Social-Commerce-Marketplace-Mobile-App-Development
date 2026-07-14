import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/live_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveStreamCard extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveStreamCard({super.key, required this.stream});

  @override
  State<LiveStreamCard> createState() => _LiveStreamCardState();
}

class _LiveStreamCardState extends State<LiveStreamCard> with TickerProviderStateMixin {
  // Ken Burns zoom/pan
  late AnimationController _kenBurnsController;
  late Animation<double> _scaleAnim;
  late Animation<Alignment> _alignAnim;

  // Radar Pulse (Concentric waves around play button)
  late AnimationController _radarController;

  // Equalizer
  late AnimationController _eqController;
  final List<double> _eqHeights = [0.3, 0.7, 0.4, 0.8, 0.5];

  // Comment Ticker
  Timer? _tickerTimer;
  int _commentIndex = 0;
  final List<String> _mockComments = [
    "Sarah Jane: Is this on sale? 😍",
    "Emma W.: Wow, looking gorgeous!",
    "David K.: Placed a bid! 🔥",
    "Sophia L. joined the stream",
    "Liam C. sent a Rose 🌹",
    "Ryan G.: What is the price?",
    "Bella Smith: Absolutely love this outfit!"
  ];

  @override
  void initState() {
    super.initState();

    // 1. Ken Burns Effect: Zoom from 1.0 to 1.10
    _kenBurnsController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    _alignAnim = Tween<Alignment>(
      begin: Alignment.center,
      end: Alignment.bottomCenter,
    ).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    // 2. Concentric Radar pulse animation
    _radarController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // 3. Audio Equalizer animation
    _eqController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    // 4. Comment Ticker Timer
    _tickerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _commentIndex = (_commentIndex + 1) % _mockComments.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _kenBurnsController.dispose();
    _radarController.dispose();
    _eqController.dispose();
    _tickerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (widget.stream.isAuction) {
          context.push('/buyer/live/bidding', extra: widget.stream);
        } else {
          context.push('/buyer/live/sell', extra: widget.stream);
        }
      },
      borderRadius: AppSpacing.borderRadiusLg,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1A33) : Colors.white,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image Stack (Autoplaying Livestream Simulator)
            Stack(
              alignment: Alignment.center,
              children: [
                // 1. Ken Burns Animated Background Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: AnimatedBuilder(
                      animation: _kenBurnsController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnim.value,
                          alignment: _alignAnim.value,
                          child: Image.network(
                            widget.stream.previewImageUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 220,
                              color: isDark ? Colors.grey[900] : AppColors.lightBorder,
                              child: const Icon(
                                Icons.broken_image,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 2. Dark Overlay Gradient for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Central Pulsing Radar Play Button
                AnimatedBuilder(
                  animation: _radarController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ripple ring
                        Transform.scale(
                          scale: 1.0 + _radarController.value * 0.8,
                          child: Opacity(
                            opacity: 1.0 - _radarController.value,
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF42F63).withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                        // Inner ripple ring
                        Transform.scale(
                          scale: 1.0 + ((_radarController.value + 0.5) % 1.0) * 0.8,
                          child: Opacity(
                            opacity: 1.0 - ((_radarController.value + 0.5) % 1.0),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF42F63).withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        // Static Core Play Badge
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFFF42F63),
                            size: 32,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // 4. Pulsing LIVE Badge (Top-Left)
                Positioned(
                  top: 16,
                  left: 16,
                  child: _CardPulsingLiveBadge(),
                ),

                // 5. Overlays (Viewers & Products counts) (Top-Right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      _buildOverlayBadge(
                        Icons.remove_red_eye_outlined,
                        widget.stream.viewerCount,
                      ),
                      const SizedBox(width: 8),
                      _buildOverlayBadge(
                        Icons.shopping_bag_outlined,
                        widget.stream.productCount.toString(),
                      ),
                    ],
                  ),
                ),

                // 6. Audio Wave Equalizer Overlay (Bottom-Right)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _eqController,
                          builder: (context, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(_eqHeights.length, (index) {
                                final baseVal = _eqHeights[index];
                                final wave = math.sin(_eqController.value * math.pi * 2 + index);
                                final height = (baseVal * 6 + wave * 3).clamp(2.0, 10.0);
                                return Container(
                                  width: 1.5,
                                  height: height,
                                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                                  color: Colors.white,
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // 7. Simulated Live Comments Ticker Overlay (Bottom-Left)
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 80,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(_commentIndex),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white70, size: 10),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _mockComments[_commentIndex],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Seller Info & Stream Title Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(widget.stream.sellerProfileImage),
                    onBackgroundImageError: (e, s) => const Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stream.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.stream.sellerName,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
                            fontSize: 14,
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
      ),
    );
  }

  Widget _buildOverlayBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPulsingLiveBadge extends StatefulWidget {
  @override
  State<_CardPulsingLiveBadge> createState() => _CardPulsingLiveBadgeState();
}

class _CardPulsingLiveBadgeState extends State<_CardPulsingLiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulsingController;

  @override
  void initState() {
    super.initState();
    _pulsingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulsingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulsingController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF42F63).withOpacity(0.85 + 0.15 * _pulsingController.value),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF42F63).withOpacity(0.3 * _pulsingController.value),
                blurRadius: 6 * _pulsingController.value,
                spreadRadius: 1 * _pulsingController.value,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

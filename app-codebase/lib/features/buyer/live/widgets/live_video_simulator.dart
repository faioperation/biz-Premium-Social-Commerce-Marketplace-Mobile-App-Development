import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Controller to allow parent widgets to trigger floating reactions on demand
class LiveVideoSimulatorController {
  void Function(String emoji)? _onTriggerReaction;

  void triggerReaction(String emoji) {
    _onTriggerReaction?.call(emoji);
  }
}

class LiveVideoSimulator extends StatefulWidget {
  final String imageUrl; // fallback if video fails
  final LiveVideoSimulatorController? controller;
  final Widget? overlayChild;

  const LiveVideoSimulator({
    super.key,
    required this.imageUrl,
    this.controller,
    this.overlayChild,
  });

  @override
  State<LiveVideoSimulator> createState() => _LiveVideoSimulatorState();
}

class _LiveVideoSimulatorState extends State<LiveVideoSimulator>
    with TickerProviderStateMixin {
  // Video Player
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _videoFailed = false;

  // Ken Burns fallback animation (used while video loads or on error)
  late AnimationController _kenBurnsController;
  late Animation<double> _scaleAnimation;
  late Animation<Alignment> _alignmentAnimation;

  // Equalizer Animation
  late AnimationController _equalizerController;
  final List<double> _equalizerHeights = [0.2, 0.5, 0.8, 0.4, 0.6, 0.3];
  final math.Random _random = math.Random();

  // Floating Reactions
  final List<_FloatingEmojiData> _floatingEmojis = [];
  Timer? _emojiAutoSpawnTimer;
  int _emojiIdCounter = 0;

  // Rotate through multiple fashion live stream video URLs for variety
  static const List<String> _videoUrls = [
    'https://assets.mixkit.co/videos/preview/mixkit-woman-showing-clothing-items-in-a-video-blog-41714-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-woman-dancing-in-fashion-clothes-39417-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-fashion-woman-walking-in-the-city-39416-large.mp4',
  ];

  @override
  void initState() {
    super.initState();

    // 1. Ken Burns fallback animation
    _kenBurnsController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    // 2. Equalizer animation
    _equalizerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat();

    // 3. Setup controller listener for manual reaction triggers
    if (widget.controller != null) {
      widget.controller!._onTriggerReaction = _addEmoji;
    }

    // 4. Auto spawn background viewer reactions
    _emojiAutoSpawnTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      final emojis = ['❤️', '🔥', '😍', '👍', '👏', '💖', '🙌', '✨', '🌹'];
      final randomEmoji = emojis[_random.nextInt(emojis.length)];
      _addEmoji(randomEmoji);
    });

    // 5. Initialize video player
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    // Pick a random video from the pool for variety across streams
    final videoUrl = _videoUrls[_random.nextInt(_videoUrls.length)];

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _videoController = controller;

      await controller.initialize();

      if (!mounted) return;

      await controller.setLooping(true);
      await controller.setVolume(0); // muted — audio overlay (equalizer) simulates audio
      await controller.play();

      setState(() {
        _videoInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _videoFailed = true;
        });
      }
    }
  }

  void _addEmoji(String emoji) {
    if (!mounted) return;
    setState(() {
      _floatingEmojis.add(
        _FloatingEmojiData(
          id: _emojiIdCounter++,
          emoji: emoji,
          startX: 0.65 + _random.nextDouble() * 0.25,
          swaySpeed: 1.5 + _random.nextDouble() * 2.0,
          swayWidth: 15.0 + _random.nextDouble() * 25.0,
          riseSpeed: 1.8 + _random.nextDouble() * 1.5,
          scale: 0.8 + _random.nextDouble() * 0.6,
        ),
      );
    });

    final int idToRemove = _emojiIdCounter - 1;
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _floatingEmojis.removeWhere((item) => item.id == idToRemove);
        });
      }
    });
  }

  @override
  void dispose() {
    _kenBurnsController.dispose();
    _equalizerController.dispose();
    _emojiAutoSpawnTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildVideoBackground() {
    if (_videoInitialized && _videoController != null) {
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }

    // Fallback: Ken Burns image while video loads or on error
    return Positioned.fill(
      child: ClipRRect(
        child: AnimatedBuilder(
          animation: _kenBurnsController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              alignment: _alignmentAnimation.value,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[900],
                  child: const Icon(
                    Icons.videocam_off,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Video Background (or Ken Burns fallback)
        _buildVideoBackground(),

        // 2. Dark gradient vignette over video for text readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
        ),

        // 3. Camera Focus Box overlay (subtle AF tracker UI)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.25,
          bottom: MediaQuery.of(context).size.height * 0.45,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  _buildCornerMarker(Alignment.topLeft),
                  _buildCornerMarker(Alignment.topRight),
                  _buildCornerMarker(Alignment.bottomLeft),
                  _buildCornerMarker(Alignment.bottomRight),
                ],
              ),
            ),
          ),
        ),

        // 4. Audio Equalizer Waveform overlay (left side — simulates mic)
        Positioned(
          left: 16,
          top: 75,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mic_rounded,
                    color: Color(0xFFF42F63),
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  AnimatedBuilder(
                    animation: _equalizerController,
                    builder: (context, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_equalizerHeights.length, (index) {
                          final baseVal = _equalizerHeights[index];
                          final wave = math.sin(_equalizerController.value * math.pi * 2 + index);
                          final animatedHeight = (baseVal * 6 + wave * 3).clamp(2.0, 12.0);

                          return Container(
                            width: 2,
                            height: animatedHeight,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF42F63),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5. Loading indicator while video initializes
        if (!_videoInitialized && !_videoFailed)
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Color(0xFFF42F63),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Connecting...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 6. Floating Emoji Reactions
        Positioned.fill(
          child: IgnorePointer(
            child: _FloatingReactionsLayer(
              emojis: _floatingEmojis,
            ),
          ),
        ),

        // 7. Optional overlay child (buttons, comments, etc.)
        if (widget.overlayChild != null) widget.overlayChild!,
      ],
    );
  }

  Widget _buildCornerMarker(Alignment alignment) {
    const double length = 8.0;
    const double thickness = 1.5;
    final color = Colors.white.withValues(alpha: 0.3);

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: length,
        height: length,
        child: Stack(
          children: [
            if (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: thickness, color: color),
              ),
            if (alignment == Alignment.topRight || alignment == Alignment.bottomRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(width: thickness, color: color),
              ),
            if (alignment == Alignment.topLeft || alignment == Alignment.topRight)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(height: thickness, color: color),
              ),
            if (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: thickness, color: color),
              ),
          ],
        ),
      ),
    );
  }
}

class _FloatingEmojiData {
  final int id;
  final String emoji;
  final double startX;
  final double swaySpeed;
  final double swayWidth;
  final double riseSpeed;
  final double scale;
  final double startTime;

  _FloatingEmojiData({
    required this.id,
    required this.emoji,
    required this.startX,
    required this.swaySpeed,
    required this.swayWidth,
    required this.riseSpeed,
    required this.scale,
  }) : startTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
}

class _FloatingReactionsLayer extends StatefulWidget {
  final List<_FloatingEmojiData> emojis;

  const _FloatingReactionsLayer({required this.emojis});

  @override
  State<_FloatingReactionsLayer> createState() => _FloatingReactionsLayerState();
}

class _FloatingReactionsLayerState extends State<_FloatingReactionsLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tickerController,
      builder: (context, child) {
        final double now = DateTime.now().millisecondsSinceEpoch / 1000.0;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: widget.emojis.map((emojiData) {
            final double elapsed = now - emojiData.startTime;
            final double progress = (elapsed / 4.0).clamp(0.0, 1.0);

            final double startY = screenHeight * 0.85;
            final double targetY = screenHeight * 0.2;
            final double currentY = startY - (startY - targetY) * progress * emojiData.riseSpeed * 0.6;

            final double sway = math.sin(elapsed * emojiData.swaySpeed * math.pi) * emojiData.swayWidth;
            final double currentX = (emojiData.startX * screenWidth) + sway;

            double opacity = 1.0;
            if (progress > 0.6) {
              opacity = ((1.0 - progress) / 0.4).clamp(0.0, 1.0);
            }

            double scale = emojiData.scale;
            if (progress < 0.1) {
              scale = emojiData.scale * (progress / 0.1);
            } else if (progress > 0.8) {
              scale = emojiData.scale * ((1.0 - progress) / 0.2);
            }

            return Positioned(
              left: currentX,
              top: currentY,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Text(
                    emojiData.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

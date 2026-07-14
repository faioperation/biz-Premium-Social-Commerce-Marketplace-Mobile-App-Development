import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/home_models.dart';
import '../controllers/home_controller.dart';
import '../controllers/story_interaction_controller.dart';
import '../../../../core/theme/app_colors.dart';

class MyDayViewScreen extends StatefulWidget {
  final StoryModel story;
  final HomeController homeController;

  const MyDayViewScreen({
    super.key,
    required this.story,
    required this.homeController,
  });

  @override
  State<MyDayViewScreen> createState() => _MyDayViewScreenState();
}

class _MyDayViewScreenState extends State<MyDayViewScreen>
    with TickerProviderStateMixin {
  late StoryModel _activeStory;
  late PageController _pageController;
  late AnimationController _progressAnimController;
  int _currentSlideIndex = 0;
  bool _isPaused = false;
  final TextEditingController _replyController = TextEditingController();
  final StoryInteractionController _interactionController = Get.put(StoryInteractionController());
  final FocusNode _replyFocusNode = FocusNode();

  // For the flying emojis animation
  final List<FloatingEmoji> _floatingEmojis = [];
  final double _bottomOffset = 100.0;

  @override
  void initState() {
    super.initState();
    _activeStory = widget.story;
    _pageController = PageController();
    
    // Set up progress bar animation controller
    _progressAnimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _activeStory.slides[_currentSlideIndex].duration),
    );

    _progressAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNextSlide();
      }
    });

    _replyFocusNode.addListener(() {
      if (_replyFocusNode.hasFocus) {
        _progressAnimController.stop();
      } else {
        if (!_isPaused) {
          _progressAnimController.forward();
        }
      }
    });

    // Start progress
    _startProgress();
    
    // Hide status bar for immersive full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimController.dispose();
    _replyController.dispose();
    _replyFocusNode.dispose();
    
    // Dispose all active flying emoji controllers to prevent ticker leaks
    for (var emoji in _floatingEmojis) {
      try {
        emoji.animController.dispose();
      } catch (_) {}
    }
    _floatingEmojis.clear();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startProgress() {
    _progressAnimController.stop();
    _progressAnimController.reset();
    _progressAnimController.duration = Duration(
      seconds: _activeStory.slides[_currentSlideIndex].duration,
    );
    _progressAnimController.forward();
  }

  void _goToNextSlide() {
    if (_replyFocusNode.hasFocus) {
      _replyFocusNode.unfocus();
    }
    if (_currentSlideIndex < _activeStory.slides.length - 1) {
      setState(() {
        _currentSlideIndex++;
      });
      _pageController.animateToPage(
        _currentSlideIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
    } else {
      // Last slide completed, check if there is a next user's story!
      widget.homeController.markStoryAsSeen(_activeStory.id);
      final stories = widget.homeController.stories;
      
      // If activeStory is the user's custom Day, handle cross navigation to first standard story
      if (_activeStory.id == 'my_day') {
        if (stories.isNotEmpty) {
          final nextStory = stories.first;
          setState(() {
            _activeStory = nextStory;
            _currentSlideIndex = 0;
          });
          _pageController.jumpToPage(0);
          _startProgress();
        } else {
          _exitStory();
        }
        return;
      }

      final currentIndex = stories.indexWhere((s) => s.id == _activeStory.id);
      if (currentIndex != -1 && currentIndex < stories.length - 1) {
        final nextStory = stories[currentIndex + 1];
        setState(() {
          _activeStory = nextStory;
          _currentSlideIndex = 0;
        });
        _pageController.jumpToPage(0);
        _startProgress();
      } else {
        _exitStory();
      }
    }
  }

  void _goToPrevSlide() {
    if (_replyFocusNode.hasFocus) {
      _replyFocusNode.unfocus();
    }
    if (_currentSlideIndex > 0) {
      setState(() {
        _currentSlideIndex--;
      });
      _pageController.animateToPage(
        _currentSlideIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
    } else {
      // First slide completed, check if there is a previous user's story!
      final stories = widget.homeController.stories;
      
      // If currently on first standard story, let's skip back to user's 'My Day' if active!
      if (_activeStory.id != 'my_day') {
        final currentIndex = stories.indexWhere((s) => s.id == _activeStory.id);
        if (currentIndex == 0 && widget.homeController.myStory.value != null) {
          final myDayStory = widget.homeController.myStory.value!;
          setState(() {
            _activeStory = myDayStory;
            _currentSlideIndex = myDayStory.slides.length - 1;
          });
          _pageController.jumpToPage(_currentSlideIndex);
          _startProgress();
          return;
        } else if (currentIndex > 0) {
          final prevStory = stories[currentIndex - 1];
          setState(() {
            _activeStory = prevStory;
            _currentSlideIndex = prevStory.slides.length - 1;
          });
          _pageController.jumpToPage(_currentSlideIndex);
          _startProgress();
          return;
        }
      }
      
      _startProgress();
    }
  }

  void _pauseStory() {
    if (!_isPaused) {
      setState(() {
        _isPaused = true;
      });
      _progressAnimController.stop();
    }
  }

  void _resumeStory() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
      });
      _progressAnimController.forward();
    }
  }

  void _exitStory() {
    widget.homeController.markStoryAsSeen(_activeStory.id);
    Navigator.of(context).pop();
  }

  void _sendTextReply(String text) {
    if (text.trim().isEmpty) return;
    _interactionController.sendStoryReply(
      story: _activeStory,
      text: text,
      isReaction: false,
    );
    Get.snackbar(
      'Reply Sent',
      'Your response was sent to ${_activeStory.sellerName}!',
      backgroundColor: const Color(0xFF6C4DFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    _replyController.clear();
  }

  void _sendEmojiReply(String emoji) {
    _spawnEmoji(emoji);
    _interactionController.sendStoryReply(
      story: _activeStory,
      text: emoji,
      isReaction: true,
    );
    Get.snackbar(
      'Reaction Sent',
      'You reacted $emoji to ${_activeStory.sellerName}\'s story!',
      backgroundColor: const Color(0xFF6C4DFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Spawns a floating emoji animation
  void _spawnEmoji(String emoji) {
    if (!mounted) return;

    final randomX = (MediaQuery.of(context).size.width / 2) + 
        (DateTime.now().millisecondsSinceEpoch % 120 - 60);
    
    final newEmoji = FloatingEmoji(
      emoji: emoji,
      startX: randomX,
      animController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      ),
    );

    setState(() {
      _floatingEmojis.add(newEmoji);
    });

    newEmoji.animController.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _floatingEmojis.remove(newEmoji);
      });
      try {
        newEmoji.animController.dispose();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final slides = _activeStory.slides;
    final currentSlide = slides[_currentSlideIndex];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_replyFocusNode.hasFocus) {
            _replyFocusNode.unfocus();
          }
        },
        child: Stack(
          children: [
          // 1. Full-screen background + long-press pause handler
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: _pauseStory,
              onLongPressEnd: (_) => _resumeStory(),
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 10) {
                  _exitStory();
                }
              },
              child: Stack(
                children: [
                  // Media Viewer (Page View)
                  PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      return _buildMediaContent(slide);
                    },
                  ),

                  // Ambient Dark Gradients (Top & Bottom for readability)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 160,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 220,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Tap Zones for Navigating Slides (always visible, left 30% / right 70%)
          // Left Tap Zone (Prev Slide)
          Positioned(
            top: 80,
            bottom: 140,
            left: 0,
            width: size.width * 0.3,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _goToPrevSlide,
            ),
          ),
          // Right Tap Zone (Next Slide)
          Positioned(
            top: 80,
            bottom: 140,
            left: size.width * 0.3,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _goToNextSlide,
            ),
          ),

          // 3. Floating Emojis Animation Canvas
          ..._floatingEmojis.map((floating) {
            return AnimatedBuilder(
              animation: floating.animController,
              builder: (context, child) {
                final value = floating.animController.value;
                // Path of emoji rising up in a wave pattern
                final double currentY = size.height - _bottomOffset - (value * 400);
                final double waveOffset = 30 * (1 - value) * (1 - value) * (1 - value) * 
                    (value < 0.5 ? -1 : 1) * (value * 3.14 * 2).abs().remainder(1);
                
                return Positioned(
                  left: floating.startX + waveOffset,
                  top: currentY,
                  child: Opacity(
                    opacity: 1 - value,
                    child: Transform.scale(
                      scale: 1.0 + (value * 0.5),
                      child: Text(
                        floating.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // 4. UI Elements Layer (Header, Progress Indicators, Footer replies)
          SafeArea(
            child: Column(
              children: [
                // Top Progress Indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: List.generate(
                      slides.length,
                      (index) => Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double widthFactor = 0.0;
                              if (index < _currentSlideIndex) {
                                widthFactor = 1.0;
                              } else if (index == _currentSlideIndex) {
                                return AnimatedBuilder(
                                  animation: _progressAnimController,
                                  builder: (context, child) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 3,
                                        width: constraints.maxWidth * 
                                            _progressAnimController.value,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 3,
                                  width: constraints.maxWidth * widthFactor,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Header Profile Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(_activeStory.profileImage),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _activeStory.sellerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              if (_activeStory.isLive) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.liveBadge,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentSlide.type == StoryMediaType.video 
                                ? 'Short Video • 2h ago' 
                                : 'Photo • 2h ago',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: _exitStory,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom Content Overlays (Caption, Reactions, Reply Bar)
                if (!_isPaused) ...[
                  // Slide Caption (if present)
                  if (currentSlide.caption != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            currentSlide.caption!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (_activeStory.id == 'my_day') ...[
                    // Premium Glassmorphic Viewers Count Badge
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _pauseStory();
                            _showViewerListSheet(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${_activeStory.viewsCount} views',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Quick reaction buttons (Glassmorphic Tray)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildEmojiReaction('❤️'),
                                _buildEmojiReaction('🔥'),
                                _buildEmojiReaction('😂'),
                                _buildEmojiReaction('👏'),
                                _buildEmojiReaction('😮'),
                                _buildEmojiReaction('😢'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Message Reply input bar
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: TextField(
                                controller: _replyController,
                                focusNode: _replyFocusNode,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                onSubmitted: (val) {
                                  _replyFocusNode.unfocus();
                                  _sendTextReply(val);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Send message to ${_activeStory.sellerName}...',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              if (_replyController.text.trim().isNotEmpty) {
                                _sendTextReply(_replyController.text);
                                _replyFocusNode.unfocus();
                              } else {
                                // If empty, trigger a heart burst!
                                _sendEmojiReply('❤️');
                              }
                            },
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6C4DFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
     ),
    );
  }

  // Quick reaction emoji builder
  Widget _buildEmojiReaction(String emoji) {
    return GestureDetector(
      onTap: () => _sendEmojiReply(emoji),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  // Renders the image or the premium simulated video content
  Widget _buildMediaContent(StoryMediaModel slide) {
    if (slide.type == StoryMediaType.video) {
      // 1. HIGH-FIDELITY SIMULATED CINEMATIC VIDEO PLAYER
      return Stack(
        fit: StackFit.expand,
        children: [
          // Slow cinematic zooming parallax background
          AnimatedBuilder(
            animation: _progressAnimController,
            builder: (context, child) {
              final scale = 1.0 + (_progressAnimController.value * 0.15);
              return Transform.scale(
                scale: scale,
                child: Image.network(
                  slide.mediaUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          
          // Immersive dark neon video overlays
          Container(
            color: Colors.black.withValues(alpha: 0.15),
          ),
          
          // Looping Pulsating Video Overlay (Audio Wave, Spinning Vinyl)
          Positioned(
            right: 16,
            bottom: 240,
            child: Column(
              children: [
                // Live Sound Pulsing Icon
                _buildVideoControlCircle(
                  icon: Icons.music_note_rounded,
                  color: const Color(0xFF6C4DFF),
                  pulse: true,
                ),
                const SizedBox(height: 14),
                // Play/Pause Floating status
                _buildVideoControlCircle(
                  icon: _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: Colors.white24,
                  pulse: false,
                ),
              ],
            ),
          ),
          
          // Video Tag Identifier
          Positioned(
            top: 100,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.video_library_rounded, color: Colors.white, size: 12),
                  SizedBox(width: 6),
                  Text(
                    'SHORT REEL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // 2. STANDARD PREMIUM PHOTO CONTENT
      return Image.network(
        slide.mediaUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.black87,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C4DFF)),
              ),
            ),
          );
        },
      );
    }
  }

  // Floating controls overlay helper for Video Simulation
  Widget _buildVideoControlCircle({
    required IconData icon,
    required Color color,
    required bool pulse,
  }) {
    return AnimatedBuilder(
      animation: _progressAnimController,
      builder: (context, child) {
        final double scale = pulse
            ? 1.0 + (0.15 * (1.0 - (_progressAnimController.value * 4).remainder(1.0).abs()))
            : 1.0;
        
        return Transform.scale(
          scale: scale,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        );
      },
    );
  }

  void _showViewerListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Story Views',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4DFF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_activeStory.viewsCount} viewers',
                      style: const TextStyle(
                        color: Color(0xFF6C4DFF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_activeStory.viewsList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Text(
                      'No views yet. Check back later!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _activeStory.viewsList.length,
                    itemBuilder: (context, index) {
                      final viewer = _activeStory.viewsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(viewer['avatar'] ?? ''),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewer['name'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    viewer['time'] ?? 'Just now',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.grey,
                              size: 20,
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
      },
    ).whenComplete(() {
      _resumeStory();
    });
  }
}

// Data holder class for flying emojis
class FloatingEmoji {
  final String emoji;
  final double startX;
  final AnimationController animController;

  FloatingEmoji({
    required this.emoji,
    required this.startX,
    required this.animController,
  });
}

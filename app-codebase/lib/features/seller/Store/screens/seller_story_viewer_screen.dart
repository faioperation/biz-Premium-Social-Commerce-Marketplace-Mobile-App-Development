import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/seller_story_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class SellerStoryViewerScreen extends StatefulWidget {
  const SellerStoryViewerScreen({super.key});

  @override
  State<SellerStoryViewerScreen> createState() => _SellerStoryViewerScreenState();
}

class _SellerStoryViewerScreenState extends State<SellerStoryViewerScreen> with SingleTickerProviderStateMixin {
  final _storyController = Get.find<SellerStoryController>();
  
  late PageController _pageController;
  late AnimationController _animationController;
  
  int _currentIndex = 0;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStoryTimer();
    });
  }
  
  void _startStoryTimer() {
    _animationController.stop();
    _animationController.reset();
    
    final story = _storyController.myStory.value;
    if (story == null || story.slides.isEmpty) return;
    
    final duration = Duration(seconds: story.slides[_currentIndex].duration);
    _animationController.duration = duration;
    
    _animationController.forward();
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextSlide();
      }
    });
  }
  
  void _nextSlide() {
    final story = _storyController.myStory.value;
    if (story == null) return;
    
    if (_currentIndex < story.slides.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    } else {
      Navigator.pop(context); // Close viewer when done
    }
  }
  
  void _prevSlide() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    } else {
      // Replay first slide if tapped left on first slide
      _startStoryTimer();
    }
  }

  void _pauseTimer() {
    _animationController.stop();
  }

  void _resumeTimer() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _deleteSlide() {
    _pauseTimer();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this slide?'),
        content: const Text('Are you sure you want to delete this part of your day?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeTimer();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              final isLastSlide = _storyController.myStory.value!.slides.length == 1;
              _storyController.deleteStory(_currentIndex);
              
              if (isLastSlide) {
                Navigator.pop(context);
              } else {
                if (_currentIndex > 0) {
                  _currentIndex--;
                }
                _pageController.jumpToPage(_currentIndex);
                _startStoryTimer();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) _resumeTimer();
    });
  }

  void _showViewersSheet() {
    _pauseTimer();
    
    final story = _storyController.myStory.value;
    if (story == null) return;
    
    final slide = story.slides[_currentIndex];
    final viewers = slide.viewers;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.remove_red_eye, color: Colors.black87),
                        const SizedBox(width: 8),
                        Text(
                          '${viewers.length} Viewers',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  Expanded(
                    child: viewers.isEmpty
                        ? const Center(child: Text('No viewers yet'))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: viewers.length,
                            itemBuilder: (context, index) {
                              final viewer = viewers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(viewer['avatar']!),
                                ),
                                title: Text(
                                  viewer['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: index % 3 == 0
                                    ? const Icon(Icons.favorite, color: AppColors.accentPink, size: 20)
                                    : null, // Just a mock react for some users
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      if (mounted) _resumeTimer();
    });
  }

  String _getTimeAgo(DateTime? time) {
    if (time == null) return 'Just now';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final story = _storyController.myStory.value;
        if (story == null || story.slides.isEmpty) {
          return const Center(child: Text('No active day', style: TextStyle(color: Colors.white)));
        }

        return SafeArea(
          child: Stack(
            children: [
              // 1. PageView for slides
              GestureDetector(
                onTapDown: (details) {
                  _pauseTimer();
                  final screenWidth = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < screenWidth / 3) {
                    _prevSlide();
                  } else {
                    _nextSlide();
                  }
                },
                onLongPressDown: (_) => _pauseTimer(),
                onLongPressEnd: (_) => _resumeTimer(),
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -10) { // swipe up
                    _showViewersSheet();
                  } else if (details.primaryDelta! > 10) { // swipe down
                    Navigator.pop(context);
                  }
                },
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // handle taps instead
                  itemCount: story.slides.length,
                  itemBuilder: (context, index) {
                    final media = story.slides[index];
                    final isNetwork = media.mediaUrl.startsWith('http');
                    
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        isNetwork
                            ? Image.network(media.mediaUrl, fit: BoxFit.cover)
                            : Image.file(File(media.mediaUrl), fit: BoxFit.cover),
                            
                        // Gradient overlays
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                              stops: const [0.0, 0.2],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                              stops: const [0.0, 0.25],
                            ),
                          ),
                        ),
                        
                        // Caption
                        if (media.caption != null && media.caption!.isNotEmpty)
                          Positioned(
                            bottom: 100,
                            left: 24,
                            right: 24,
                            child: Text(
                              media.caption!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // 2. Progress Bars
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: List.generate(story.slides.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            double value = 0.0;
                            if (index < _currentIndex) {
                              value = 1.0;
                            } else if (index == _currentIndex) {
                              value = _animationController.value;
                            }
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 3,
                              borderRadius: BorderRadius.circular(1.5),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // 3. Top Profile Bar
              Positioned(
                top: 24,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Text(story.profileImage, style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      story.sellerName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeAgo(story.slides[_currentIndex].timestamp),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                      onPressed: () {
                        _pauseTimer();
                        context.push(AppRoutes.sellerCreateStory).then((_) {
                          if (mounted) {
                            final s = _storyController.myStory.value;
                            if (s != null && _currentIndex < s.slides.length - 1) {
                              // If a new slide was added, jump to it
                              setState(() {
                                _currentIndex = s.slides.length - 1;
                              });
                              _pageController.jumpToPage(_currentIndex);
                            }
                            _startStoryTimer();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _deleteSlide,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // 4. Viewers Bottom Button
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showViewersSheet,
                  child: Column(
                    children: [
                      const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 24),
                      Text(
                        '${story.slides[_currentIndex].viewers.length} Viewers',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: AppColors.accentPink, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'View who reacted and viewed',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

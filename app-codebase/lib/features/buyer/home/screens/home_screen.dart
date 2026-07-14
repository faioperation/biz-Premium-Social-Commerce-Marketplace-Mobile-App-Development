import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';
import '../widgets/home_widgets.dart';
import '../../../../core/services/app_share_service.dart';
import '../widgets/feed_card.dart';
import '../widgets/home_comments_sheet.dart';
import '../../../../core/theme/app_spacing.dart';
import 'my_day_view_screen.dart';
import '../controllers/live_list_controller.dart';
import '../widgets/live_stream_card.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final notificationController = Get.put(NotificationController());
    final liveListController = Get.put(LiveListController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Vango Live',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          Obx(() {
            final unreadCount = notificationController.unreadCount;
            return IconButton(
              icon: unreadCount > 0
                  ? Badge(
                      label: Text('$unreadCount'),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              onPressed: () => context.push(AppRoutes.notifications),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.loadMockData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.edgeInsetsAllLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 110,
                  child: Obx(
                    () {
                      final hasMyStory = controller.myStory.value != null;
                      final totalCount = controller.stories.length + 1;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: totalCount,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Render User's own Add Day / My Day
                            if (!hasMyStory) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () => _showCreateDaySheet(context, controller),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.withValues(alpha: 0.3),
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            children: [
                                              const CircleAvatar(
                                                radius: 33,
                                                backgroundImage: NetworkImage(
                                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(3),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF6C4DFF),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const SizedBox(
                                        width: 80,
                                        child: Text(
                                          'Add Day',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final myStoryData = controller.myStory.value!;
                              return Obx(() => StoryCard(
                                imageUrl: myStoryData.profileImage,
                                name: 'My Day',
                                isLive: false,
                                isSeen: myStoryData.isSeen.value,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => MyDayViewScreen(
                                        story: myStoryData,
                                        homeController: controller,
                                      ),
                                    ),
                                  );
                                },
                              ));
                            }
                          }

                          // Render standard stories
                          final story = controller.stories[index - 1];
                          return Obx(() => StoryCard(
                            imageUrl: story.profileImage,
                            name: story.sellerName,
                            isLive: story.isLive,
                            isSeen: story.isSeen.value,
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => MyDayViewScreen(
                                    story: story,
                                    homeController: controller,
                                  ),
                                ),
                              );
                            },
                          ));
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    HomeCategoryButton(
                      label: 'Flash Sale',
                      icon: Icons.flash_on,
                      gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                      onTap: () => context.push(AppRoutes.flashSale),
                    ),
                    const SizedBox(width: 12),
                    HomeCategoryButton(
                      label: 'Trending',
                      icon: Icons.trending_up,
                      gradient: const [Color(0xFF6C4DFF), Color(0xFF4F46E5)],
                      onTap: () => context.push(AppRoutes.trending),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    HomeCategoryButton(
                      label: 'Live Now',
                      icon: Icons.play_circle_outline,
                      gradient: const [Color(0xFFFF4D67), Color(0xFFE11D48)],
                      onTap: () =>
                          StatefulNavigationShell.of(context).goBranch(2),
                    ),
                    const SizedBox(width: 12),
                    HomeCategoryButton(
                      label: 'Following',
                      icon: Icons.people_outline,
                      gradient: const [Color(0xFFFF4FD8), Color(0xFFDB2777)],
                      onTap: () => context.push(AppRoutes.following),
                    ),
                  ],
                ),

                Obx(() {
                  if (liveListController.isLoading.value) {
                    return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
                  }
                  if (liveListController.liveStreams.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Active Live Streams'),
                      SizedBox(
                        height: 330,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: liveListController.liveStreams.length,
                          itemBuilder: (context, index) {
                            final stream = liveListController.liveStreams[index];
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              margin: const EdgeInsets.only(right: 16),
                              child: LiveStreamCard(stream: stream),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }),

                const SectionTitle(title: 'For You'),

                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.feedItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.feedItems[index];
                      return FeedCard(
                        item: item,
                        onLike: () => controller.toggleLike(item.id),
                        onComment: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            barrierColor: Colors.black45,
                            builder: (context) => HomeCommentsSheet(
                              itemId: item.id,
                              controller: controller,
                            ),
                          );
                        },
                        onShare: () => AppShareService.shareFeedPost(
                          postId: item.id,
                          caption: item.title,
                          sellerName: item.sellerName,
                          context: context,
                        ),
                        onAddToCart: () => controller.addToCart(item.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateDaySheet(BuildContext context, HomeController controller) {
    final captionController = TextEditingController();
    final RxString selectedImage = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600'.obs;

    final List<Map<String, String>> templates = [
      {
        'title': 'Cool Denim',
        'url': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600',
      },
      {
        'title': 'Neon Vibe',
        'url': 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=600',
      },
      {
        'title': 'Sunny Sunset',
        'url': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=600',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
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
                const Text(
                  'Create your Day',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a template and write your thoughts!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Select Outfit / Style Layout:',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: templates.length,
                    itemBuilder: (context, idx) {
                      final item = templates[idx];
                      return Obx(() {
                        final isSelected = selectedImage.value == item['url'];
                        return GestureDetector(
                          onTap: () {
                            selectedImage.value = item['url']!;
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF6C4DFF) : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    item['url']!,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.15),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    right: 6,
                                    child: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add a Caption:',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: captionController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Share what you are wearing today...',
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addMyStorySlide(
                        selectedImage.value,
                        captionController.text.trim(),
                      );
                      Navigator.pop(context);
                      Get.snackbar(
                        'Success',
                        'Successfully posted to your Day! 🎉',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF6C4DFF),
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'Post to My Day',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

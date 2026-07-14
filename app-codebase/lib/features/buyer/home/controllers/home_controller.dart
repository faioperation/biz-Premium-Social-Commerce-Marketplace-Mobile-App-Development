import 'package:get/get.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  final RxList<StoryModel> stories = <StoryModel>[].obs;
  final RxList<FeedItemModel> feedItems = <FeedItemModel>[].obs;
  final RxMap<String, RxList<CommentModel>> commentsMap = <String, RxList<CommentModel>>{}.obs;
  final RxBool isLoading = false.obs;
  final Rxn<StoryModel> myStory = Rxn<StoryModel>();

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;

    stories.assignAll([
      StoryModel(
        id: '1',
        sellerName: 'TechStore',
        profileImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
        isLive: true,
        slides: [
          StoryMediaModel(
            id: '1_1',
            mediaUrl: 'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?q=80&w=600',
            type: StoryMediaType.image,
            caption: 'Check out our latest Smart Watch Ultra! ⌚🔥',
          ),
          StoryMediaModel(
            id: '1_2',
            mediaUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?q=80&w=600',
            type: StoryMediaType.video,
            caption: 'Pure acoustic bliss. Active Noise Cancellation in action! 🎧✨',
          ),
        ],
      ),
      StoryModel(
        id: '2',
        sellerName: 'FashionHub',
        profileImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
        isLive: true,
        slides: [
          StoryMediaModel(
            id: '2_1',
            mediaUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600',
            type: StoryMediaType.video,
            caption: 'Summer Vibes are here! 👗☀️ 20% off today only!',
          ),
          StoryMediaModel(
            id: '2_2',
            mediaUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=600',
            type: StoryMediaType.image,
            caption: 'Denim never goes out of style. Grab yours now! 🧥',
          ),
        ],
      ),
      StoryModel(
        id: '3',
        sellerName: 'HomeDecor',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
        isLive: false,
        slides: [
          StoryMediaModel(
            id: '3_1',
            mediaUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?q=80&w=600',
            type: StoryMediaType.image,
            caption: 'Transform your space with our premium decor collection 🛋️🌿',
          ),
        ],
      ),
      StoryModel(
        id: '4',
        sellerName: 'BeautyBox',
        profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
        isLive: true,
        slides: [
          StoryMediaModel(
            id: '4_1',
            mediaUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600',
            type: StoryMediaType.video,
            caption: 'Get the perfect glow with our new liquid highlighter! ✨💄',
          ),
        ],
      ),
      StoryModel(
        id: '5',
        sellerName: 'GadgetZ',
        profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
        isLive: false,
        slides: [
          StoryMediaModel(
            id: '5_1',
            mediaUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?q=80&w=600',
            type: StoryMediaType.image,
            caption: 'Satisfying clicks. Dynamic RGB lighting customization! ⌨️🌈',
          ),
        ],
      ),
    ]);

    final mockComments = {
      '1': <CommentModel>[
        CommentModel(
          id: 'c1',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=alex',
          commentText: 'This wireless headphone is absolutely amazing! 🔥',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CommentModel(
          id: 'c2',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=sarah',
          commentText: 'Does it support active noise cancelling?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        CommentModel(
          id: 'c3',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=david',
          commentText: 'Wow, looks sleek and premium.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ].obs,
      '2': <CommentModel>[
        CommentModel(
          id: 'c4',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=emma',
          commentText: 'Can\'t wait for the live sale! 😍',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        CommentModel(
          id: 'c5',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=ryan',
          commentText: 'Is there a discount code available?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ].obs,
      '3': <CommentModel>[
        CommentModel(
          id: 'c6',
          userName: 'John Smith',
          userProfileUrl: 'https://i.pravatar.cc/150?u=sophia',
          commentText: 'Matches my living room perfectly. Gorgeous design!',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ].obs,
    };
    commentsMap.assignAll(mockComments);

    feedItems.assignAll([
      FeedItemModel(
        id: '1',
        sellerName: 'TechStore',
        title: 'Wireless Headphones Ultra',
        price: 99.00,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
        type: FeedType.post,
        likes: 12500,
        comments: mockComments['1']!.length,
      ),
      FeedItemModel(
        id: '2',
        sellerName: 'FashionHub',
        title: 'Summer Collection Live Sale',
        price: 45.00,
        imageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        type: FeedType.live,
        likes: 8900,
        comments: mockComments['2']!.length,
      ),
      FeedItemModel(
        id: '3',
        sellerName: 'HomeDecor',
        title: 'Modern Minimalist Lamp',
        price: 120.00,
        imageUrl:
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        type: FeedType.post,
        likes: 3400,
        comments: mockComments['3']!.length,
      ),
    ]);

    isLoading.value = false;
  }

  RxList<CommentModel> getCommentsForItem(String itemId) {
    if (!commentsMap.containsKey(itemId)) {
      commentsMap[itemId] = <CommentModel>[].obs;
    }
    return commentsMap[itemId]!;
  }

  void addComment(String itemId, String text) {
    final currentComments = getCommentsForItem(itemId);
    currentComments.add(CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      userProfileUrl: 'https://i.pravatar.cc/150?u=you',
      commentText: text,
      timestamp: DateTime.now(),
    ));

    final index = feedItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = feedItems[index];
      feedItems[index] = FeedItemModel(
        id: item.id,
        sellerName: item.sellerName,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        type: item.type,
        likes: item.likes,
        comments: item.comments + 1,
        isLiked: item.isLiked,
      );
    }
  }

  void toggleLike(String id) {
    final index = feedItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = feedItems[index];
      feedItems[index] = FeedItemModel(
        id: item.id,
        sellerName: item.sellerName,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        type: item.type,
        likes: item.isLiked ? item.likes - 1 : item.likes + 1,
        comments: item.comments,
        isLiked: !item.isLiked,
      );
    }
  }

  void addToCart(String id) {
    Get.snackbar(
      'Success',
      'Added to cart!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void markStoryAsSeen(String storyId) {
    if (storyId == 'my_day') {
      myStory.value?.isSeen.value = true;
      return;
    }
    final story = stories.firstWhereOrNull((s) => s.id == storyId);
    if (story != null) {
      story.isSeen.value = true;
    }
  }

  void addMyStorySlide(String imageUrl, String caption) {
    final newSlide = StoryMediaModel(
      id: 'my_day_${DateTime.now().millisecondsSinceEpoch}',
      mediaUrl: imageUrl,
      type: StoryMediaType.image,
      caption: caption,
    );

    final currentStory = myStory.value;
    if (currentStory == null) {
      myStory.value = StoryModel(
        id: 'my_day',
        sellerName: 'My Day',
        profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
        slides: [newSlide],
        viewsCount: 14,
        viewsList: [
          {
            'name': 'Emma Watson',
            'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150',
            'time': 'Just now',
          },
          {
            'name': 'Sophia Lee',
            'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150',
            'time': '2m ago',
          },
          {
            'name': 'Liam Carter',
            'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150',
            'time': '5m ago',
          },
          {
            'name': 'Olivia Martinez',
            'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150',
            'time': '12m ago',
          },
          {
            'name': 'Noah Walker',
            'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150',
            'time': '20m ago',
          },
        ],
      );
    } else {
      final updatedSlides = List<StoryMediaModel>.from(currentStory.slides)..add(newSlide);
      myStory.value = StoryModel(
        id: 'my_day',
        sellerName: 'My Day',
        profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
        slides: updatedSlides,
        viewsCount: currentStory.viewsCount + 3,
        viewsList: currentStory.viewsList,
      );
    }
  }
}

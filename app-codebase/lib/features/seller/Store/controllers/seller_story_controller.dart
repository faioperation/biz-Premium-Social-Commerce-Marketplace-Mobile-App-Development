import 'package:get/get.dart';
import '../../../buyer/home/models/home_models.dart';
import 'store_controller.dart';

class SellerStoryController extends GetxController {
  // Currently active story (if any)
  final Rxn<StoryModel> myStory = Rxn<StoryModel>();

  // Mock numbers for viewing/reacts (simulating a database)
  final RxInt viewsCount = 0.obs;
  final RxInt reactsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialStoryState();
  }

  void _loadInitialStoryState() {
    // Check if there is a saved story in local storage or API.
    // For now, we start empty.
    myStory.value = null;
  }

  void postStory(String imagePath, String? caption) {
    // In a real app, you would upload the image to a server here.
    final storeCtrl = Get.find<StoreController>();
    final store = storeCtrl.store.value;

    if (store == null) return;

    // Generate some mock viewers for this slide
    final List<Map<String, String>> mockViewers = [
      {'name': 'Alice Smith', 'avatar': 'https://i.pravatar.cc/150?u=alice'},
      {'name': 'Bob Johnson', 'avatar': 'https://i.pravatar.cc/150?u=bob'},
      {'name': 'Charlie Davis', 'avatar': 'https://i.pravatar.cc/150?u=charlie'},
      {'name': 'Diana Prince', 'avatar': 'https://i.pravatar.cc/150?u=diana'},
      {'name': 'Eve Adams', 'avatar': 'https://i.pravatar.cc/150?u=eve'},
    ];

    final media = StoryMediaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mediaUrl: imagePath, // Using local path directly
      type: StoryMediaType.image,
      caption: caption,
      timestamp: DateTime.now(),
      viewers: mockViewers,
    );

    if (myStory.value != null) {
      // Append to existing story
      final currentStory = myStory.value!;
      final updatedSlides = List<StoryMediaModel>.from(currentStory.slides)..add(media);
      
      myStory.value = StoryModel(
        id: currentStory.id,
        sellerName: currentStory.sellerName,
        profileImage: currentStory.profileImage,
        slides: updatedSlides,
        viewsCount: currentStory.viewsCount,
      );
    } else {
      // Create new story
      final newStory = StoryModel(
        id: 'store_${store.id}_day',
        sellerName: store.name,
        profileImage: store.avatar,
        slides: [media],
        viewsCount: 0,
      );
      myStory.value = newStory;
    }
  }

  void deleteStory(int slideIndex) {
    if (myStory.value == null) return;
    final currentStory = myStory.value!;
    
    if (currentStory.slides.length <= 1) {
      // Delete the entire story if it's the only slide
      myStory.value = null;
    } else {
      // Remove just this slide
      final updatedSlides = List<StoryMediaModel>.from(currentStory.slides)..removeAt(slideIndex);
      myStory.value = StoryModel(
        id: currentStory.id,
        sellerName: currentStory.sellerName,
        profileImage: currentStory.profileImage,
        slides: updatedSlides,
        viewsCount: currentStory.viewsCount,
      );
    }
  }

  void simulateViewsAndReacts() {
    // Legacy mock function if needed, but we now use individual slide mockViewers
  }
}

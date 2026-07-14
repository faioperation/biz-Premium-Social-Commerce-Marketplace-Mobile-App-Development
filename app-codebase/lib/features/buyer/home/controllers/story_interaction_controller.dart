import 'package:get/get.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../models/home_models.dart';

class StoryInteractionController extends GetxController {
  // Method to send a story reply (text comment or reaction) to the seller's inbox
  Future<void> sendStoryReply({
    required StoryModel story,
    required String text,
    bool isReaction = false,
  }) async {
    // 1. Map story details to chat details
    // Chat ID is derived from seller name (lowercased, spaces removed) to match existing mock inbox chat IDs
    final chatId = story.sellerName.toLowerCase().replaceAll(' ', '');
    
    // 2. Access the InboxController (lazily register it if not already present)
    final inboxController = Get.isRegistered<InboxController>()
        ? Get.find<InboxController>()
        : Get.put(InboxController(), permanent: true);
        
    // 3. Ensure the chat session exists in the user's inbox
    inboxController.openOrCreateChat(
      chatId: chatId,
      name: story.sellerName,
      profileImage: story.profileImage,
    );
    
    // 4. Format message text (optionally prefixing or formatting as a story reply)
    final String formattedMessage;
    if (isReaction) {
      formattedMessage = 'Reacted $text to your story';
    } else {
      formattedMessage = 'Replied to your story: "$text"';
    }
    
    // 5. Send message through the inbox controller (updates local state/chat history)
    inboxController.sendMessage(chatId, formattedMessage);
    
    // -------------------------------------------------------------
    // TODO: FUTURE API INTEGRATION
    // Under the hood, this is where the API call will be integrated:
    // try {
    //   await _apiService.sendStoryReply(
    //     storyId: story.id,
    //     sellerId: chatId,
    //     message: formattedMessage,
    //   );
    // } catch (e) {
    //   print("Failed to send story reply to server: $e");
    // }
    // -------------------------------------------------------------
  }
}

import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class InboxController extends GetxController {
  final chatList = <ChatModel>[].obs;
  final searchQuery = ''.obs;

  List<ChatModel> get filteredChats {
    if (searchQuery.value.trim().isEmpty) {
      return chatList;
    }
    return chatList
        .where((chat) =>
            chat.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  final Map<String, RxList<MessageModel>> _messagesMap = {};

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    chatList.assignAll([
      ChatModel(
        id: 'techstore',
        name: 'TechStore',
        profileImage:
            'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=200',
        lastMessage: 'Your order has been shipped! 🚀',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 2,
      ),
      ChatModel(
        id: 'fashionhub',
        name: 'FashionHub',
        profileImage:
            'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=200',
        lastMessage: 'Thanks for your purchase! 🛍️',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
      ChatModel(
        id: 'audiophile',
        name: 'AudioPhile',
        profileImage:
            'https://images.unsplash.com/photo-1545127398-14699f92334b?q=80&w=200',
        lastMessage: 'Let me know if you need anything else.',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
      ),
    ]);

    _messagesMap['techstore'] = <MessageModel>[
      MessageModel(
        id: 'm1',
        chatId: 'techstore',
        text: 'Hi, I ordered a headphone. Is it shipped?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 10),
        ),
        isMe: true,
      ),
      MessageModel(
        id: 'm2',
        chatId: 'techstore',
        text: 'Yes! Your order has been shipped! 🚀',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
    ].obs;

    _messagesMap['fashionhub'] = <MessageModel>[
      MessageModel(
        id: 'm3',
        chatId: 'fashionhub',
        text: 'I love the jacket!',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3, minutes: 10),
        ),
        isMe: true,
      ),
      MessageModel(
        id: 'm4',
        chatId: 'fashionhub',
        text: 'Thanks for your purchase! 🛍️',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: false,
      ),
    ].obs;
  }

  Future<void> fetchChats() async {
    // chatList.assignAll(response.map(ChatModel.fromJson));
  }

  RxList<MessageModel> getMessages(String chatId) {
    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);
    return _messagesMap[chatId]!;
  }

  void openOrCreateChat({
    required String chatId,
    required String name,
    required String profileImage,
  }) {
    final existing = chatList.indexWhere((c) => c.id == chatId);
    if (existing == -1) {
      chatList.insert(
        0,
        ChatModel(
          id: chatId,
          name: name,
          profileImage: profileImage,
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        ),
      );
    } else {
      final chat = chatList.removeAt(existing);
      chatList.insert(0, chat);
    }
    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);

    markAsRead(chatId);
  }

  void sendMessage(String chatId, String text) {
    if (text.trim().isEmpty) return;

    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);
    _messagesMap[chatId]!.add(msg);

    final idx = chatList.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chatList[idx].lastMessage = text.trim();
      chatList[idx].lastMessageTime = DateTime.now();
      final chat = chatList.removeAt(idx);
      chatList.insert(0, chat);
    }
  }

  void markAsRead(String chatId) {
    final idx = chatList.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chatList[idx].unreadCount = 0;
      chatList.refresh();
    }
  }

  void sendMediaMessage(String chatId, String path, String type, {String? text}) {
    final defaultText = type == 'image' ? 'Sent an image' : 'Sent a video';
    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: (text != null && text.trim().isNotEmpty) ? text.trim() : defaultText,
      timestamp: DateTime.now(),
      isMe: true,
      type: type,
      mediaPath: path,
    );

    _messagesMap.putIfAbsent(chatId, () => <MessageModel>[].obs);
    _messagesMap[chatId]!.add(msg);

    final idx = chatList.indexWhere((c) => c.id == chatId);
    if (idx != -1) {
      chatList[idx].lastMessage = msg.text;
      chatList[idx].lastMessageTime = DateTime.now();
      final chat = chatList.removeAt(idx);
      chatList.insert(0, chat);
    }
  }

  void editMessage(String chatId, String messageId, String newText) {
    if (newText.trim().isEmpty) return;
    final list = _messagesMap[chatId];
    if (list != null) {
      final idx = list.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        final m = list[idx];
        list[idx] = m.copyWith(text: newText.trim(), isEdited: true);
        list.refresh();

        // Update last message if this was the last message in chat history
        final lastIdx = chatList.indexWhere((c) => c.id == chatId);
        if (lastIdx != -1 && idx == list.length - 1) {
          chatList[lastIdx].lastMessage = newText.trim();
          chatList.refresh();
        }
      }
    }
  }

  void deleteMessage(String chatId, String messageId) {
    final list = _messagesMap[chatId];
    if (list != null) {
      final idx = list.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        list.removeAt(idx);
        list.refresh();

        // Update last message in the chat list
        final lastIdx = chatList.indexWhere((c) => c.id == chatId);
        if (lastIdx != -1) {
          if (list.isEmpty) {
            chatList[lastIdx].lastMessage = 'Conversation cleared';
          } else {
            final lastMsg = list.last;
            chatList[lastIdx].lastMessage = lastMsg.text;
          }
          chatList.refresh();
        }
      }
    }
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays == 0 && now.day == time.day) {
      final h = time.hour > 12
          ? time.hour - 12
          : (time.hour == 0 ? 12 : time.hour);
      final m = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $period';
    } else if (diff.inDays <= 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

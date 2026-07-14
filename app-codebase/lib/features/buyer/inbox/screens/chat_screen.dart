import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inbox_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String shopName;
  final String profileImage;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.shopName,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<InboxController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ctrl.getMessages(chatId);
    final scrollCtrl = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.markAsRead(chatId);
    });

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(profileImage),
              onBackgroundImageError: (_, __) {},
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Active now',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profileImage),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        shopName,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Say hello! 👋',
                        style: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollCtrl.hasClients) {
                  scrollCtrl.animateTo(
                    scrollCtrl.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final showDateSep =
                      index == 0 ||
                      messages[index - 1].timestamp.day != msg.timestamp.day;
                  return Column(
                    children: [
                      if (showDateSep) _DateSeparator(time: msg.timestamp),
                      MessageBubble(message: msg),
                    ],
                  );
                },
              );
            }),
          ),

          ChatInputBar(
            onSend: (text, mediaPath, mediaType) {
              if (mediaPath != null && mediaType != null) {
                ctrl.sendMediaMessage(chatId, mediaPath, mediaType, text: text);
              } else {
                ctrl.sendMessage(chatId, text);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime time;
  const _DateSeparator({required this.time});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    String label;
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      label = 'Today';
    } else if (time.day == now.subtract(const Duration(days: 1)).day) {
      label = 'Yesterday';
    } else {
      label = '${time.day}/${time.month}/${time.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[500],
                fontSize: 11,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Expanded(
            child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}

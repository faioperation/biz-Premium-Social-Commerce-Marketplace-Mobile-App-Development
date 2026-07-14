import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/inbox_controller.dart';
import '../widgets/chat_list_tile.dart';
import '../widgets/messenger/chat_search_bar.dart';

class InboxListScreen extends StatelessWidget {
  const InboxListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(InboxController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const ChatSearchBar(),
          Expanded(
            child: Obx(() {
              if (ctrl.chatList.isEmpty) {
                return _buildEmpty(isDark);
              }
              if (ctrl.filteredChats.isEmpty) {
                return _buildNoSearchResults(isDark);
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: ctrl.filteredChats.length,
                separatorBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(left: 76),
                  child: Divider(
                    height: 1,
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                  ),
                ),
                itemBuilder: (context, index) {
                  final chat = ctrl.filteredChats[index];
                  return ChatListTile(
                    chat: chat,
                    onTap: () => context.push(
                      AppRoutes.chatScreen,
                      extra: {
                        'chatId': chat.id,
                        'shopName': chat.name,
                        'profileImage': chat.profileImage,
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for a different shop name',
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
              fontSize: 13,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 72,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Visit a shop and tap "Message" to start chatting',
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
              fontSize: 13,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

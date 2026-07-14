import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/inbox_controller.dart';
import '../models/chat_model.dart';

class ChatListTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatListTile({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<InboxController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat.profileImage),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey[300],
                ),

                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.black : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Obx(() {
                    final current = ctrl.chatList.firstWhereOrNull(
                      (c) => c.id == chat.id,
                    );
                    final msg = current?.lastMessage ?? '';
                    return Text(
                      msg.isEmpty ? 'Start a conversation...' : msg,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: (current?.unreadCount ?? 0) > 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Obx(() {
              final current = ctrl.chatList.firstWhereOrNull(
                (c) => c.id == chat.id,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ctrl.formatTime(
                      current?.lastMessageTime ?? chat.lastMessageTime,
                    ),
                    style: TextStyle(
                      color: (current?.unreadCount ?? 0) > 0
                          ? AppColors.primary
                          : Colors.grey[500],
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  if ((current?.unreadCount ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${current!.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 18),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

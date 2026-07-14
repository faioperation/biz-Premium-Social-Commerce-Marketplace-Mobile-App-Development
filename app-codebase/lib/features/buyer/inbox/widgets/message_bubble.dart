import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/inbox_controller.dart';
import '../models/message_model.dart';
import 'messenger/message_action_sheet.dart';
import 'messenger/media_viewer_screen.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<InboxController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMe = message.isMe;

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => MessageActionSheet(
            message: message,
            onEdit: (msgId, newText) {
              ctrl.editMessage(message.chatId, msgId, newText);
            },
            onDelete: (msgId) {
              ctrl.deleteMessage(message.chatId, msgId);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF2A2535) : Colors.grey[200]),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message.type != 'text')
                      _buildMediaContent(context, isDark),
                    if (message.type == 'text' ||
                        (message.text != 'Sent an image' &&
                            message.text != 'Sent a video' &&
                            message.text.isNotEmpty))
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isEdited) ...[
                          Text(
                            'Edited',
                            style: TextStyle(
                              color: isMe ? Colors.white70 : Colors.grey[500],
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              color: isMe ? Colors.white70 : Colors.grey[500],
                              fontSize: 10,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                        Text(
                          _formatBubbleTime(message.timestamp),
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.grey[500],
                            fontSize: 10,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context, bool isDark) {
    final path = message.mediaPath;
    if (path == null || path.isEmpty) return const SizedBox.shrink();

    final isUrl = path.startsWith('http') || path.startsWith('https');
    final mediaWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: message.type == 'image'
          ? (isUrl
              ? Image.network(
                  path,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                  errorBuilder: (_, __, ___) => _buildErrorMedia(),
                )
              : Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                  errorBuilder: (_, __, ___) => _buildErrorMedia(),
                ))
          : Container(
              width: 200,
              height: 150,
              color: Colors.black87,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Icon(
                      Icons.movie_creation_outlined,
                      color: Colors.white.withOpacity(0.5),
                      size: 48,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaViewerScreen(
              path: path,
              type: message.type,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: mediaWidget,
      ),
    );
  }

  Widget _buildErrorMedia() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  String _formatBubbleTime(DateTime time) {
    final h = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

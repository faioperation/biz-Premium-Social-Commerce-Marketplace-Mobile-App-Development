import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_broadcast_controller.dart';

class LiveChatInput extends StatelessWidget {
  final LiveBroadcastController controller;

  const LiveChatInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      color: Colors.black.withValues(alpha: 0.7),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.replyingToComment.value != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 4),
              child: Row(
                children: [
                  const Icon(Icons.reply_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Replying to ${controller.replyingToComment.value!.userName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.cancelReply,
                    child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E24).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: controller.chatInputController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Reply to viewers...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => controller.sendMessage(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8C73FF), // Purple send button matching mockup
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_broadcast_controller.dart';
import 'live_comment_card.dart';

class LiveChatList extends StatelessWidget {
  final LiveBroadcastController controller;

  const LiveChatList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final comments = controller.comments;
      return ListView.separated(
        reverse: true, // Show newest messages at the bottom
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: comments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // Because of reverse: true, index 0 is the newest, which is at the end of the list
          final comment = comments[comments.length - 1 - index];
          
          return LiveCommentCard(
            comment: comment,
            onReplyTap: controller.setReplyTo,
            onLikeTap: controller.toggleLike,
            isHighlighted: controller.replyingToComment.value?.id == comment.id,
          );
        },
      );
    });
  }
}

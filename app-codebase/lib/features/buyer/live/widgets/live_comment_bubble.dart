import 'package:flutter/material.dart';

class LiveCommentBubble extends StatelessWidget {
  final String username;
  final String comment;

  const LiveCommentBubble({
    super.key,
    required this.username,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final isJoin = comment == 'joined';
    final isGift = comment.startsWith('Sent a');

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
            children: [
              if (isJoin) ...[
                TextSpan(
                  text: username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' joined',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ] else if (isGift) ...[
                TextSpan(
                  text: username,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' $comment',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                TextSpan(
                  text: '$username ',
                  style: TextStyle(
                    color: username == 'You' ? Colors.orangeAccent : Colors.grey.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: comment,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

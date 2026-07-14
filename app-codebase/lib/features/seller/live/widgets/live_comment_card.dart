import 'package:flutter/material.dart';
import '../models/live_comment_model.dart';

/// A premium, reusable comment card widget for the live broadcast screen.
/// Implements a Facebook/Instagram-like nested replying and liking system.
class LiveCommentCard extends StatelessWidget {
  final LiveCommentModel comment;
  final Function(LiveCommentModel) onReplyTap;
  final Function(String, {String? parentId}) onLikeTap;
  final bool isHighlighted;

  const LiveCommentCard({
    super.key,
    required this.comment,
    required this.onReplyTap,
    required this.onLikeTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSeller = comment.userName.contains('(You)');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Parent Comment Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: isHighlighted 
                ? Colors.white.withValues(alpha: 0.15) 
                : Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Name Header
                    Text(
                      comment.userName,
                      style: TextStyle(
                        color: isSeller ? const Color(0xFF8C73FF) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        shadows: const [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    
                    // Message Content
                    Text(
                      comment.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        height: 1.25,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // Action Buttons (Like / Reply)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => onLikeTap(comment.id),
                          child: Text(
                            comment.isLiked ? 'Liked' : 'Like',
                            style: TextStyle(
                              color: comment.isLiked ? const Color(0xFFFF4FD8) : Colors.white70,
                              fontSize: 11,
                              fontWeight: comment.isLiked ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (comment.likeCount > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '•  ${comment.likeCount}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => onReplyTap(comment),
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Small interactive heart icon on right
              GestureDetector(
                onTap: () => onLikeTap(comment.id),
                child: Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: comment.isLiked ? const Color(0xFFFF4FD8) : Colors.white54,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
        
        // 2. Indented Sub-replies Section
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comment.replies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final reply = comment.replies[index];
                final isReplySeller = reply.userName.contains('(You)');
                
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reply Author
                            Text(
                              reply.userName,
                              style: TextStyle(
                                color: isReplySeller ? const Color(0xFF8C73FF) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            
                            // Reply Content
                            Text(
                              reply.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            
                            // Reply Action Row
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => onLikeTap(reply.id, parentId: comment.id),
                                  child: Text(
                                    reply.isLiked ? 'Liked' : 'Like',
                                    style: TextStyle(
                                      color: reply.isLiked ? const Color(0xFFFF4FD8) : Colors.white70,
                                      fontSize: 10.5,
                                      fontWeight: reply.isLiked ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (reply.likeCount > 0) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '•  ${reply.likeCount}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 18),
                                GestureDetector(
                                  onTap: () => onReplyTap(comment), // Reply targets parent comment thread
                                  child: const Text(
                                    'Reply',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Heart icon for reply
                      GestureDetector(
                        onTap: () => onLikeTap(reply.id, parentId: comment.id),
                        child: Icon(
                          reply.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: reply.isLiked ? const Color(0xFFFF4FD8) : Colors.white54,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

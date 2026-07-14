import 'package:flutter/material.dart';
import '../../live/models/live_comment_model.dart';
import '../../../../core/theme/app_colors.dart';

/// A premium, highly reusable comment card supporting nested threading, likes,
/// and reply actions. Completely decoupled using clean, parameter-driven callbacks.
class PlaybackCommentCard extends StatefulWidget {
  final LiveCommentModel comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final Function(String replyId)? onLikeReply;
  
  // Custom styling properties
  final bool isSubComment;

  const PlaybackCommentCard({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
    this.onLikeReply,
    this.isSubComment = false,
  });

  @override
  State<PlaybackCommentCard> createState() => _PlaybackCommentCardState();
}

class _PlaybackCommentCardState extends State<PlaybackCommentCard> {
  bool _isRepliesExpanded = true;

  /// Helper to get user initials for profile avatar fallback.
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color commentBoxBg = isDark 
        ? Colors.white.withValues(alpha: 0.06) 
        : Colors.black.withValues(alpha: 0.04);
    
    final bool hasReplies = widget.comment.replies.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Core Comment Layout
        Padding(
          padding: EdgeInsets.only(
            left: widget.isSubComment ? 42.0 : 8.0,
            right: 8.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar Bubble
              CircleAvatar(
                radius: widget.isSubComment ? 12 : 16,
                backgroundColor: isDark ? const Color(0xFF3E1F5C) : const Color(0xFFECE6F5),
                child: Text(
                  _getInitials(widget.comment.userName),
                  style: TextStyle(
                    fontSize: widget.isSubComment ? 9 : 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Comment Bubble Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: commentBoxBg,
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(14),
                          bottomLeft: const Radius.circular(14),
                          bottomRight: const Radius.circular(14),
                          topLeft: Radius.circular(widget.isSubComment ? 14 : 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.comment.userName,
                            style: TextStyle(
                              fontSize: widget.isSubComment ? 11 : 12,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.comment.message,
                            style: TextStyle(
                              fontSize: widget.isSubComment ? 12 : 13,
                              color: textColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Actions Footer (Like, Reply, Likes Count)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, top: 4.0, bottom: 2.0),
                      child: Row(
                        children: [
                          // Like Button
                          GestureDetector(
                            onTap: widget.onLike,
                            child: Text(
                              widget.comment.isLiked ? 'Liked' : 'Like',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: widget.comment.isLiked ? FontWeight.bold : FontWeight.normal,
                                color: widget.comment.isLiked 
                                    ? Colors.pink 
                                    : textSecondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Reply Button (Only for parent comments)
                          if (!widget.isSubComment) ...[
                            GestureDetector(
                              onTap: widget.onReply,
                              child: Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          
                          // Likes Counter Icon & Label
                          if (widget.comment.likeCount > 0) ...[
                            Icon(
                              Icons.favorite_rounded,
                              size: 11,
                              color: Colors.pink.shade400,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.comment.likeCount}',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 2. Thread replies expand/collapse control
        if (hasReplies && !widget.isSubComment) ...[
          Padding(
            padding: const EdgeInsets.only(left: 56.0, bottom: 4.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isRepliesExpanded = !_isRepliesExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 1,
                      color: textSecondaryColor.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isRepliesExpanded
                          ? 'Hide replies'
                          : 'View ${widget.comment.replies.length} replies',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isRepliesExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],

        // 3. Render Nested Replies recursively
        if (hasReplies && _isRepliesExpanded && !widget.isSubComment) ...[
          ...widget.comment.replies.map((reply) {
            return PlaybackCommentCard(
              key: ValueKey(reply.id),
              comment: reply,
              isSubComment: true,
              onLike: () {
                if (widget.onLikeReply != null) {
                  widget.onLikeReply!(reply.id);
                }
              },
            );
          }),
        ],
      ],
    );
  }
}

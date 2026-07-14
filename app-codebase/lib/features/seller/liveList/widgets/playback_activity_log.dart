import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/past_live_stream_model.dart';

/// A self-contained, scrollable chronological activity log of all recorded
/// comments on a past livestream. Tapping a comment tile seeks the video
/// timeline to that comment's original position in the stream.
class PlaybackActivityLog extends StatelessWidget {
  final PastLiveStreamModel pastLive;
  final Function(int timelineSeconds) onCommentTap;
  final bool isDark;
  final Color textColor;
  final Color textSecondaryColor;
  final Color borderColor;

  const PlaybackActivityLog({
    super.key,
    required this.pastLive,
    required this.onCommentTap,
    required this.isDark,
    required this.textColor,
    required this.textSecondaryColor,
    required this.borderColor,
  });

  /// Formats an integer second count into m:ss display.
  String _formatTime(int totalSecs) {
    final minutes = totalSecs ~/ 60;
    final seconds = totalSecs % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats a DateTime into an absolute readable calendar stamp.
  String _formatTimestamp(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day $month ${dt.year}, $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    final sortedComments = List<PlaybackCommentModel>.from(pastLive.comments)
      ..sort((a, b) => a.timelineSeconds.compareTo(b.timelineSeconds));

    return Column(
      children: [
        // ── Summary metric cards ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _MetricCard(
                icon: Icons.favorite_rounded,
                iconColor: Colors.pink,
                label: 'Total Likes',
                value: '${pastLive.totalLikes}',
                isDark: isDark,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
                borderColor: borderColor,
              ),
              const SizedBox(width: 12),
              _MetricCard(
                icon: Icons.forum_rounded,
                iconColor: Colors.teal,
                label: 'Total Chats',
                value: '${pastLive.comments.length}',
                isDark: isDark,
                textColor: textColor,
                textSecondaryColor: textSecondaryColor,
                borderColor: borderColor,
              ),
            ],
          ),
        ),

        // ── Section header ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.history_rounded, size: 14, color: textSecondaryColor),
              const SizedBox(width: 6),
              Text(
                'Chat Log  •  Tap to seek video',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Chronological comment list ────────────────────────────────────
        Expanded(
          child: sortedComments.isEmpty
              ? Center(
                  child: Text(
                    'No comments recorded on this stream.',
                    style: TextStyle(color: textSecondaryColor, fontSize: 13),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: sortedComments.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, thickness: 0.5, color: borderColor),
                  itemBuilder: (context, index) {
                    final item = sortedComments[index];
                    final c = item.comment;
                    return InkWell(
                      onTap: () => onCommentTap(item.timelineSeconds),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.15),
                              child: Text(
                                c.userName.isNotEmpty
                                    ? c.userName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        c.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5,
                                          color: textColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_rounded,
                                              size: 10,
                                              color: textSecondaryColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatTime(item.timelineSeconds),
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    c.message,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: textColor.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Timestamp + like count
                                  Row(
                                    children: [
                                      Text(
                                        _formatTimestamp(c.timestamp),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: textSecondaryColor
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                      if (c.likeCount > 0) ...[
                                        const SizedBox(width: 12),
                                        const Icon(Icons.favorite_rounded,
                                            color: Colors.pink, size: 10),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${c.likeCount}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: textSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Private helper widget ─────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDark;
  final Color textColor;
  final Color textSecondaryColor;
  final Color borderColor;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDark,
    required this.textColor,
    required this.textSecondaryColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

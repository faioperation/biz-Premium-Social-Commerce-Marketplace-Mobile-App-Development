import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../live/models/live_session_data.dart';
import '../models/past_live_stream_model.dart';

/// A premium, interactive card component displaying info for a past livestream.
class PastLiveStreamCard extends StatelessWidget {
  final PastLiveStreamModel stream;
  final VoidCallback? onDelete;

  const PastLiveStreamCard({
    super.key,
    required this.stream,
    this.onDelete,
  });

  /// Simple, zero-dependency date and time formatter to keep code clean and portable.
  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays == 0) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    }
  }

  /// Formats the duration (e.g., "1h 24m" or "45m 12s").
  String _formatDuration(Duration dur) {
    final hours = dur.inHours;
    final minutes = dur.inMinutes.remainder(60);
    final seconds = dur.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color cardBgColor = isDark ? AppColors.darkCard : Colors.white;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push(AppRoutes.sellerPastLivePlayback, extra: stream);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Thumbnail Header Section
                Stack(
                  children: [
                    // Mock cover image or custom color gradient backdrop
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF2E1A47),
                                  const Color(0xFF1A1A24),
                                ]
                              : [
                                  const Color(0xFFECE6F5),
                                  const Color(0xFFF3F4F6),
                                ],
                        ),
                      ),
                      child: stream.coverImagePath != null
                          ? Image.network(
                              stream.coverImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.videocam,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : Center(
                              child: Icon(
                                Icons.videocam,
                                size: 48,
                                color: isDark ? Colors.white30 : Colors.black26,
                              ),
                            ),
                    ),
                    
                    // Shadow overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Duration Badge
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(stream.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Live Type Indicator Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stream.liveType == LiveType.bidding
                              ? Colors.amber.shade700
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stream.liveType.icon,
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              stream.liveType.label.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Three-dot Options Overlay Button
                    if (onDelete != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {}, // Absorb gesture taps so card navigation is not triggered
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 100,
                            ),
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white30, width: 0.5),
                              ),
                              child: const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                onDelete?.call();
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Play Icon Overlay Center
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 2. Info Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stream Date & Title
                      Text(
                        _formatDate(stream.date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stream.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Metrics Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniMetric(
                            icon: Icons.visibility_rounded,
                            label: '${stream.totalViewers} reach',
                            isDark: isDark,
                          ),
                          _buildMiniMetric(
                            icon: Icons.favorite_rounded,
                            label: '${stream.totalLikes} likes',
                            isDark: isDark,
                            iconColor: Colors.pink,
                          ),
                          _buildMiniMetric(
                            icon: Icons.shopping_bag_rounded,
                            label: '${stream.products.length} products',
                            isDark: isDark,
                            iconColor: Colors.teal,
                          ),
                        ],
                      ),
                      

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniMetric({
    required IconData icon,
    required String label,
    required bool isDark,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: iconColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

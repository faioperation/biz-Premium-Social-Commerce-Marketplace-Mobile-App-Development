import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/seller_live_list_controller.dart';
import '../models/past_live_stream_model.dart';
import '../widgets/past_live_stream_card.dart';

/// Screen presenting the seller's catalog of recorded/past livestream broadcasts.
class SellerLiveListScreen extends StatefulWidget {
  const SellerLiveListScreen({super.key});

  @override
  State<SellerLiveListScreen> createState() => _SellerLiveListScreenState();
}

class _SellerLiveListScreenState extends State<SellerLiveListScreen> {
  final SellerLiveListController _controller = Get.put(SellerLiveListController());

  @override
  void dispose() {
    Get.delete<SellerLiveListController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color textSecondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recorded Live Streams',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.fetchPastLives,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Core analytics summaries dashboard card
                  _buildDashboardAnalytics(isDark, cardColor, borderColor, textColor, textSecondaryColor),
                  const SizedBox(height: 24),
                  
                  // 2. Section header & Search bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Past Broadcasts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${_controller.filteredLives.length} streams',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Premium search field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      onChanged: (val) => _controller.searchQuery.value = val,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by title or stream type...',
                        hintStyle: TextStyle(
                          color: textSecondaryColor.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: textSecondaryColor,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Conditional lists rendering
                  if (_controller.filteredLives.isEmpty)
                    _buildEmptyState(textColor, textSecondaryColor)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.filteredLives.length,
                      itemBuilder: (context, index) {
                        final stream = _controller.filteredLives[index];
                        return PastLiveStreamCard(
                          stream: stream,
                          onDelete: () => _showDeleteConfirmation(context, stream),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Premium Analytics summary panel.
  Widget _buildDashboardAnalytics(
    bool isDark,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color textSecondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Channel Performance Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Streams',
                  value: '${_controller.totalStreams}',
                  icon: Icons.video_library_rounded,
                  color: AppColors.primary,
                  textSecondaryColor: textSecondaryColor,
                ),
              ),
              Container(width: 1, height: 40, color: borderColor),
              Expanded(
                child: _buildMetricTile(
                  title: 'Total Reach',
                  value: _formatNumber(_controller.totalReach),
                  icon: Icons.visibility_rounded,
                  color: Colors.blue,
                  textSecondaryColor: textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Interactive modal dialog requesting the seller to confirm livestream deletion.
  void _showDeleteConfirmation(BuildContext context, PastLiveStreamModel stream) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final dialogBgColor = isDark ? AppColors.darkCard : Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Past Broadcast?',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${stream.title}"? This action cannot be undone.',
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.deletePastLive(stream.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${stream.title}" has been deleted.'),
                    backgroundColor: Colors.red.shade400,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color textSecondaryColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Compact high-end empty state widget
  Widget _buildEmptyState(Color textColor, Color textSecondaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.video_camera_back_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Streams Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try refining your query or run your first live stream!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to convert e.g. 1500 to "1.5K"
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return '$number';
  }
}

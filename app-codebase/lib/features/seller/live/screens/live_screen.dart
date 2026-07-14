import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class SellerLivestreamScreen extends StatelessWidget {
  const SellerLivestreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium dark/neon theme for streaming center
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color bgColor = isDark ? AppColors.sellerBackground : const Color(0xFFF3F4F6);
    final Color cardColor = isDark ? AppColors.sellerGradStart : Colors.white;
    final Color textPrimary = isDark ? Colors.white : Colors.black87;
    final Color textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        title: Text(
          'Live Streaming Center',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: textSecondary),
            onPressed: () {
              // Help dialogue/info
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: cardColor,
                  title: Text('Live Help', style: TextStyle(color: textPrimary)),
                  content: Text(
                    'Welcome to your Live Streaming Center! From here you can check your stream analytics, see your scheduled events, or hit the Floating Action Button below to setup a new live event and sell products directly to your audience.',
                    style: TextStyle(color: textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.sellerSetupLivestream),
        backgroundColor: AppColors.liveBadge,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.videocam, size: 24),
        label: const Text(
          'Go Live Now',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analytics Header
            Text(
              'Performance Overview',
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Performance Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  'Total Streams',
                  '18',
                  Icons.play_circle_outline,
                  const Color(0xFF6C4DFF),
                  cardColor,
                  textPrimary,
                  textSecondary,
                ),
                _buildStatCard(
                  'Total Views',
                  '2.4K',
                  Icons.remove_red_eye_outlined,
                  const Color(0xFFFF4FD8),
                  cardColor,
                  textPrimary,
                  textSecondary,
                ),
                _buildStatCard(
                  'Live Hours',
                  '24.5 hrs',
                  Icons.timer_outlined,
                  const Color(0xFF22C55E),
                  cardColor,
                  textPrimary,
                  textSecondary,
                ),
                _buildStatCard(
                  'Products Sold',
                  '126 items',
                  Icons.shopping_bag_outlined,
                  const Color(0xFFF59E0B),
                  cardColor,
                  textPrimary,
                  textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Banner or Live Setup Quick Trigger Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C4DFF),
                    Color(0xFFFF4FD8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C4DFF).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flash_on, color: Colors.yellow, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'PRO TIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Engage More Customers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Feature your top items and give exclusive live coupons during the stream. Keep broadcasts interactive and professional!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push(AppRoutes.sellerSetupLivestream),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6C4DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Launch Live Room',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Past Broadcast History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Broadcasts',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final titles = [
                  'Summer Collection Flash Sale! ☀️',
                  'New Electronics Launch and Review 📱',
                  'Exclusive Weekend Discount & Q&A 🎁'
                ];
                final viewers = ['240', '189', '325'];
                final dates = ['2 days ago', '1 week ago', '2 weeks ago'];
                final durations = ['1h 15m', '45m', '2h 10m'];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.video_library_outlined,
                            color: isDark ? AppColors.darkIcon : AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titles[index],
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined, color: textSecondary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${viewers[index]} views',
                                  style: TextStyle(color: textSecondary, fontSize: 12),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.schedule, color: textSecondary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  durations[index],
                                  style: TextStyle(color: textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dates[index],
                              style: TextStyle(color: textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40), // Spacing from FAB/Bottom
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color accentColor,
    Color cardColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

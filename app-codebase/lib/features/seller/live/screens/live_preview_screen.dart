import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/live_preview_controller.dart';
import '../models/live_session_data.dart';
import '../widgets/preview_cover_section.dart';
import '../widgets/preview_product_list.dart';
import '../widgets/live_type_selector.dart';

class LivePreviewScreen extends StatelessWidget {
  final LiveSessionData sessionData;

  const LivePreviewScreen({super.key, required this.sessionData});

  @override
  Widget build(BuildContext context) {
    // Initialize controller and pass the session data
    final controller = Get.put(LivePreviewController());
    controller.init(sessionData);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black87,
            size: 28,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Cover & Title Preview
                    PreviewCoverSection(
                      title: controller.streamTitle,
                      coverImagePath: controller.coverImagePath,
                    ),
                    const SizedBox(height: 16),

                    // 2. Selected Products Preview
                    PreviewProductList(products: controller.featuredProducts),
                    const SizedBox(height: 16),

                    // 3. Live Type Selection (Sell vs Bidding)
                    Obx(() => LiveTypeSelector(
                          selectedType: controller.selectedLiveType.value,
                          onTypeSelected: controller.selectLiveType,
                        )),

                    // Note: Stream settings options are intentionally omitted per requirements.
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2D) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 16,
                  )
                ],
              ),
              child: Column(
                children: [
                  // All Set Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C4DFF).withValues(alpha: 0.1),
                          const Color(0xFFFF4D94).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6C4DFF).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "You're all set!",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Go Live Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(AppRoutes.sellerLiveBroadcast, extra: sessionData);
                      },
                      icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                      label: const Text(
                        'Go Live Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2D), // Dark match the mockup
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Back to Edit Button
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      'Back to Edit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

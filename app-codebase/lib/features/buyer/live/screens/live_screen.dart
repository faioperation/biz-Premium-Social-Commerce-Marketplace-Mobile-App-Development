import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/live_list_controller.dart';
import '../../home/widgets/live_stream_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class BuyerLiveScreen extends StatelessWidget {
  const BuyerLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveListController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Live Streams',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Obx(
              () => Text(
                '${controller.liveStreams.length} live channels now',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.liveBadge.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.liveBadge.withValues(alpha: 0.5),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: AppColors.liveBadge),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppColors.liveBadge,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.liveStreams.isEmpty) {
          return const Center(
            child: Text(
              'No live streams available right now.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadMockData(),
          child: ListView.builder(
            padding: AppSpacing.edgeInsetsAllLg,
            itemCount: controller.liveStreams.length,
            itemBuilder: (context, index) {
              return LiveStreamCard(stream: controller.liveStreams[index]);
            },
          ),
        );
      }),
    );
  }
}

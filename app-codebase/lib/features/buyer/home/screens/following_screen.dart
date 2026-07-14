import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/following_controller.dart';
import '../widgets/following_card.dart';
import '../../../../core/theme/app_spacing.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FollowingController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Following',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: AppSpacing.edgeInsetsAllLg,
          itemCount: controller.followingContent.length,
          itemBuilder: (context, index) {
            return FollowingCard(item: controller.followingContent[index]);
          },
        );
      }),
    );
  }
}

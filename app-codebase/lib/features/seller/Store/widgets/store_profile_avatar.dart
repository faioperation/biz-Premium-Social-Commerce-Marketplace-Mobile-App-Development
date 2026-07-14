import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/seller_story_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class StoreProfileAvatarWidget extends StatelessWidget {
  final String initials;
  final bool isDark;

  const StoreProfileAvatarWidget({
    super.key,
    required this.initials,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Lazy load the controller
    final storyController = Get.put(SellerStoryController());

    return Obx(() {
      final hasStory = storyController.myStory.value != null;

      return GestureDetector(
        onTap: () {
          if (hasStory) {
            context.push(AppRoutes.sellerViewStory);
          } else {
            context.push(AppRoutes.sellerCreateStory);
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar Container wrapped with gradient ring if story exists
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasStory
                    ? const LinearGradient(
                        colors: [AppColors.accentPink, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              padding: EdgeInsets.all(hasStory ? 3.0 : 0.0), // The ring thickness
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    if (!hasStory) // shadow only when no story ring
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            // Plus Badge if no story
            if (!hasStory)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

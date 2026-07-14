import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/discover_controller.dart';
import '../widgets/discover_search_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/recent_search_tile.dart';
import '../../../../core/theme/app_spacing.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscoverController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoverSearchBar(
                controller: controller.searchController,
                onSubmitted: (val) => controller.performSearch(val),
              ),
              const SizedBox(height: 24),

              Text(
                'Categories',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  return CategoryCard(
                    category: cat,
                    onTap: () {
                      context.push('/buyer/discover/products', extra: cat);
                    },
                  );
                },
              ),
              const SizedBox(height: 28),

              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.recentSearches.isEmpty) {
                  return const Text(
                    'No recent searches.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  );
                }
                return Column(
                  children: controller.recentSearches.map((search) {
                    return RecentSearchTile(
                      text: search,
                      onTap: () {
                        controller.searchController.text = search;
                        controller.performSearch(search);
                      },
                      onDelete: () => controller.removeRecentSearch(search),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 24),

              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF7C3AED),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trending Searches',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: controller.trendingSearches.map((chipText) {
                  return InkWell(
                    onTap: () {
                      controller.searchController.text = chipText;
                      controller.performSearch(chipText);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chipText,
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

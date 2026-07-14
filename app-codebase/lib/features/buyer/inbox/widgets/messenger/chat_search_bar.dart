import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/inbox_controller.dart';

class ChatSearchBar extends StatefulWidget {
  const ChatSearchBar({super.key});

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final _searchController = TextEditingController();
  final ctrl = Get.find<InboxController>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ctrl.searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontFamily: 'Inter',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Search chats...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              fontFamily: 'Inter',
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 20,
            ),
            suffixIcon: Obx(() {
              if (ctrl.searchQuery.value.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                    size: 18,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ShopLiveTab extends StatelessWidget {
  final bool isLive;
  final bool isDark;

  const ShopLiveTab({super.key, required this.isLive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (!isLive) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_outlined,
              size: 64,
              color: isDark ? Colors.grey[800] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No active live streams',
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        'Live Stream is currently active!',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}

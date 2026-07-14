import 'package:flutter/material.dart';

class ShopSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  ShopSliverAppBarDelegate(this.tabBar, this.isDark);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDark ? const Color(0xFF1A1625) : Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(ShopSliverAppBarDelegate oldDelegate) {
    return false;
  }
}

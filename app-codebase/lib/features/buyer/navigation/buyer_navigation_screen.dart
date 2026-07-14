import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/animated_nav_item.dart';

class BuyerNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BuyerNavigationScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If not on Home, navigate to Home first
        navigationShell.goBranch(0);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isSelected: navigationShell.currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  AnimatedNavItem(
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search,
                    label: 'Discover',
                    isSelected: navigationShell.currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  AnimatedNavItem(
                    icon: Icons.add,
                    label: '',
                    isSelected: navigationShell.currentIndex == 2,
                    isLiveButton: true,
                    onTap: () => _onTap(2),
                  ),
                  AnimatedNavItem(
                    icon: Icons.inbox_outlined,
                    activeIcon: Icons.inbox,
                    label: 'Inbox',
                    isSelected: navigationShell.currentIndex == 3,
                    onTap: () => _onTap(3),
                  ),
                  AnimatedNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isSelected: navigationShell.currentIndex == 4,
                    onTap: () => _onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

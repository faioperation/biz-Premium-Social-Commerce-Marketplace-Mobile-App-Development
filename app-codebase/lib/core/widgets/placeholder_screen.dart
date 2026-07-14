import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final Color color;
  final bool showRoleToggle;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.color,
    this.showRoleToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withValues(alpha: 0.2),
        elevation: 0,
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 20),
            if (showRoleToggle) ...[
              const Text("Switch Role to test Dynamic Navigation:"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final auth = Get.find<AuthController>();
                  if (auth.userRole.value == UserRole.buyer) {
                    auth.switchRole(UserRole.seller, context);
                  } else {
                    auth.switchRole(UserRole.buyer, context);
                  }
                },
                child: Obx(() {
                  final role = Get.find<AuthController>().userRole.value;
                  return Text(
                    "Current Role: ${role.name.toUpperCase()} (Tap to switch)",
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.find<AuthController>().logout(context);
                },
                child: const Text("Log Out"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

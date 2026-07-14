import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'adaptive_layout.dart';
import 'layout_controller.dart';
import 'admin_sidebar.dart';
import 'admin_header.dart';
import 'admin_content.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  AdminLayout({super.key, required this.child}) {
    // Register the controller if not already present
    if (!Get.isRegistered<LayoutController>()) {
      Get.put(LayoutController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.find<LayoutController>();

    return AdaptiveLayout(
      desktop: Scaffold(
        body: Row(
          children: [
            const AdminSidebar(),
            Expanded(
              child: Column(
                children: [
                  const AdminHeader(),
                  Expanded(child: AdminContent(child: child)),
                ],
              ),
            )
          ],
        ),
      ),
      mobile: Scaffold(
        key: controller.scaffoldKey,
        drawer: const Drawer(child: AdminSidebar()),
        body: Column(
          children: [
            const AdminHeader(),
            Expanded(child: AdminContent(child: child)),
          ],
        ),
      ),
    );
  }
}

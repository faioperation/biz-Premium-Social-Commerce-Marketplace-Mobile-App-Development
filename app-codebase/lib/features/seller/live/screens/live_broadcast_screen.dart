import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../models/live_session_data.dart';
import '../controllers/live_broadcast_controller.dart';
import '../widgets/live_camera_view.dart';
import '../widgets/live_top_bar.dart';
import '../widgets/live_chat_list.dart';
import '../widgets/live_pinned_products.dart';
import '../widgets/live_chat_input.dart';

class LiveBroadcastScreen extends StatefulWidget {
  final LiveSessionData sessionData;

  const LiveBroadcastScreen({super.key, required this.sessionData});

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends State<LiveBroadcastScreen> {
  late final LiveBroadcastController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LiveBroadcastController());
    controller.init(widget.sessionData);
  }

  @override
  void dispose() {
    Get.delete<LiveBroadcastController>();
    super.dispose();
  }

  void _confirmEndLive(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E24),
        title: const Text('End Live Stream?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to end this live broadcast?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.pop(); // Pop back to dashboard or previous screen
            },
            child: const Text('End Live', style: TextStyle(color: Color(0xFFFF4D4D))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for live stream
      resizeToAvoidBottomInset: true, // Allow chat input to push up
      body: Stack(
        children: [
          // 1. Camera View Layer (Background)
          Positioned.fill(
            child: LiveCameraView(controller: controller),
          ),
          
          // 2. UI Overlay Layer
          SafeArea(
            child: Column(
              children: [
                // Top Bar (Live Status, Viewer Count, Close)
                Obx(() => LiveTopBar(
                  viewerCount: controller.viewerCount.value,
                  liveDuration: controller.liveDuration.value,
                  onClose: () => _confirmEndLive(context),
                )),
                
                // Spacer pushes chat and products to bottom
                const Spacer(),
                
                // Chat List
                LiveChatList(controller: controller),
                
                // Pinned Products (Horizontal List)
                LivePinnedProducts(products: controller.sessionData.selectedProducts),
                
                // Chat Input Field
                LiveChatInput(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

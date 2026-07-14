import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_broadcast_controller.dart';

class LiveCameraView extends StatelessWidget {
  final LiveBroadcastController controller;

  const LiveCameraView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasCameraPermission.value) {
        return const Center(
          child: Text(
            'Camera permission required to broadcast live.',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      if (!controller.isCameraInitialized.value || controller.cameraController == null) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      // Display the actual camera feed stretched to cover the screen
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.cameraController!.value.previewSize?.height ?? 1,
            height: controller.cameraController!.value.previewSize?.width ?? 1,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      );
    });
  }
}

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/live_session_data.dart';
import '../models/live_comment_model.dart';

/// Controller for the actual Live Broadcast screen.
/// Handles Camera initialization, stream statistics, and chat logic.
class LiveBroadcastController extends GetxController {
  late LiveSessionData sessionData;

  // Camera State
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool hasCameraPermission = false.obs;

  // Chat State
  final RxList<LiveCommentModel> comments = <LiveCommentModel>[].obs;
  final TextEditingController chatInputController = TextEditingController();
  final Rx<LiveCommentModel?> replyingToComment = Rx<LiveCommentModel?>(null);

  // Stream Stats
  final RxString viewerCount = '1.2K'.obs;
  
  // Timer State
  Timer? _liveTimer;
  final RxInt liveSeconds = 0.obs;
  final RxString liveDuration = '00:00'.obs;

  void init(LiveSessionData data) {
    sessionData = data;
    _initializeCamera();
    _loadMockComments();
    _startLiveTimer();
  }

  @override
  void onClose() {
    _liveTimer?.cancel();
    cameraController?.dispose();
    chatInputController.dispose();
    super.onClose();
  }

  void _startLiveTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      liveSeconds.value++;
      final minutes = (liveSeconds.value ~/ 60).toString().padLeft(2, '0');
      final seconds = (liveSeconds.value % 60).toString().padLeft(2, '0');
      
      // If live for more than an hour, show HH:MM:SS
      if (liveSeconds.value >= 3600) {
        final hours = (liveSeconds.value ~/ 3600).toString().padLeft(2, '0');
        liveDuration.value = '$hours:$minutes:$seconds';
      } else {
        liveDuration.value = '$minutes:$seconds';
      }
    });
  }

  Future<void> _initializeCamera() async {
    // Request permissions first
    final status = await Permission.camera.request();
    if (status.isGranted) {
      hasCameraPermission.value = true;
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // Default to front camera for live streaming
          final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

          cameraController = CameraController(
            frontCamera,
            ResolutionPreset.high,
            enableAudio: true, // Will also request mic permission automatically on start
          );

          await cameraController!.initialize();
          isCameraInitialized.value = true;
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    } else {
      hasCameraPermission.value = false;
      debugPrint('Camera permission denied.');
    }
  }

  void _loadMockComments() {
    comments.assignAll([
      LiveCommentModel(
        id: '1',
        userName: 'John Smith',
        message: 'How much is the watch?',
        timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
        likeCount: 2,
        replies: [
          LiveCommentModel(
            id: '1_1',
            userName: 'Seller (You)',
            message: 'It is \$120. Free shipping is active today!',
            timestamp: DateTime.now().subtract(const Duration(seconds: 25)),
            parentId: '1',
            likeCount: 1,
          ),
        ],
      ),
      LiveCommentModel(
        id: '2',
        userName: 'Emma Watson',
        message: 'Do you ship to Chittagong?',
        timestamp: DateTime.now().subtract(const Duration(seconds: 15)),
      ),
    ]);
  }

  void setReplyTo(LiveCommentModel comment) {
    replyingToComment.value = comment;
  }

  void cancelReply() {
    replyingToComment.value = null;
  }

  void toggleLike(String commentId, {String? parentId}) {
    if (parentId != null) {
      final parentIndex = comments.indexWhere((c) => c.id == parentId);
      if (parentIndex != -1) {
        final parent = comments[parentIndex];
        final replyIndex = parent.replies.indexWhere((r) => r.id == commentId);
        if (replyIndex != -1) {
          final reply = parent.replies[replyIndex];
          final updatedIsLiked = !reply.isLiked;
          final updatedLikeCount = updatedIsLiked ? reply.likeCount + 1 : reply.likeCount - 1;
          
          final updatedReplies = List<LiveCommentModel>.from(parent.replies);
          updatedReplies[replyIndex] = reply.copyWith(
            isLiked: updatedIsLiked,
            likeCount: updatedLikeCount < 0 ? 0 : updatedLikeCount,
          );
          
          comments[parentIndex] = parent.copyWith(replies: updatedReplies);
        }
      }
    } else {
      final commentIndex = comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = comments[commentIndex];
        final updatedIsLiked = !comment.isLiked;
        final updatedLikeCount = updatedIsLiked ? comment.likeCount + 1 : comment.likeCount - 1;
        
        comments[commentIndex] = comment.copyWith(
          isLiked: updatedIsLiked,
          likeCount: updatedLikeCount < 0 ? 0 : updatedLikeCount,
        );
      }
    }
  }

  void sendMessage() {
    final text = chatInputController.text.trim();
    if (text.isNotEmpty) {
      final now = DateTime.now();
      final parentComment = replyingToComment.value;

      if (parentComment != null) {
        // If the targeted comment is a reply, we link it under the main parent
        final parentId = parentComment.parentId ?? parentComment.id;
        final parentIndex = comments.indexWhere((c) => c.id == parentId);
        
        if (parentIndex != -1) {
          final parent = comments[parentIndex];
          final newReply = LiveCommentModel(
            id: now.millisecondsSinceEpoch.toString(),
            userName: 'Seller (You)',
            message: text,
            timestamp: now,
            parentId: parentId,
          );
          
          comments[parentIndex] = parent.copyWith(
            replies: [...parent.replies, newReply],
          );
        }
      } else {
        // Add as a normal parent comment
        comments.add(LiveCommentModel(
          id: now.millisecondsSinceEpoch.toString(),
          userName: 'Seller (You)',
          message: text,
          timestamp: now,
        ));
      }
      
      chatInputController.clear();
      replyingToComment.value = null;
      // Future API integration: Send this message to WebSocket server
    }
  }
}

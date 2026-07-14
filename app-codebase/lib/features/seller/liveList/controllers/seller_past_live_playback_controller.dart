import 'dart:async';
import 'package:get/get.dart';
import '../models/past_live_stream_model.dart';
import '../../live/models/live_comment_model.dart';

/// A controller managing the interactive playback of a single past livestream session.
class SellerPastLivePlaybackController extends GetxController {
  final PastLiveStreamModel stream;
  
  SellerPastLivePlaybackController(this.stream);

  Timer? _playbackTimer;
  final RxInt playbackSeconds = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxList<LiveCommentModel> activeComments = <LiveCommentModel>[].obs;
  final Rx<LiveCommentModel?> replyingToComment = Rx<LiveCommentModel?>(null);
  
  // Track heart animations
  final RxList<int> floatingHearts = <int>[].obs;
  int _heartCounter = 0;

  // Active product featured (updates based on playback time)
  final Rxn<String> activeProductId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // Default the active product to the first product featured
    if (stream.products.isNotEmpty) {
      activeProductId.value = stream.products.first.id;
    }
    // Start initial setup
    resetPlayback();
  }

  @override
  void onClose() {
    _playbackTimer?.cancel();
    super.onClose();
  }

  /// Toggles between Play and Pause.
  void togglePlayPause() {
    if (isPlaying.value) {
      pausePlayback();
    } else {
      startPlayback();
    }
  }

  /// Starts or resumes the timeline ticks.
  void startPlayback() {
    if (playbackSeconds.value >= stream.duration.inSeconds) {
      // Replay from beginning if it reached the end
      resetPlayback();
    }
    
    isPlaying.value = true;
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (playbackSeconds.value < stream.duration.inSeconds) {
        playbackSeconds.value++;
        _syncCommentsForTimeline();
        _updateActiveProductByTimeline();
      } else {
        pausePlayback();
      }
    });
  }

  /// Pauses the timeline ticks.
  void pausePlayback() {
    isPlaying.value = false;
    _playbackTimer?.cancel();
  }

  /// Resets the stream back to the beginning.
  void resetPlayback() {
    pausePlayback();
    playbackSeconds.value = 0;
    activeComments.clear();
    replyingToComment.value = null;
    floatingHearts.clear();
    if (stream.products.isNotEmpty) {
      activeProductId.value = stream.products.first.id;
    }
    _syncCommentsForTimeline();
  }

  /// Jumps the playhead to a specific second on the timeline.
  void seekTo(double seconds) {
    final int sec = seconds.toInt();
    if (sec < 0 || sec > stream.duration.inSeconds) return;
    
    playbackSeconds.value = sec;
    
    // Clear and rebuild comment state to match the new playhead position
    activeComments.clear();
    for (final pc in stream.comments) {
      if (pc.timelineSeconds <= sec) {
        activeComments.add(pc.comment);
      }
    }
    
    _updateActiveProductByTimeline();
  }

  /// Dynamically populates comments that were created at/before the current second.
  void _syncCommentsForTimeline() {
    final currentSec = playbackSeconds.value;
    for (final pc in stream.comments) {
      // If the comment is scheduled at this exact second or earlier, and is not already in the active list
      final isAlreadyShown = activeComments.any((c) => c.id == pc.comment.id);
      if (pc.timelineSeconds <= currentSec && !isAlreadyShown) {
        activeComments.add(pc.comment);
      }
    }
  }

  /// Rotates or updates featured products to simulate high-fidelity interactive promotions.
  void _updateActiveProductByTimeline() {
    if (stream.products.isEmpty) return;
    
    // Example logic: Rotate featured product every 45 seconds during playback
    final productIndex = (playbackSeconds.value ~/ 45) % stream.products.length;
    activeProductId.value = stream.products[productIndex].id;
  }

  /// Interactively likes a historical comment.
  void toggleLikeComment(String commentId, {String? parentId}) {
    if (parentId == null) {
      // Root level comment
      final index = activeComments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = activeComments[index];
        final newIsLiked = !comment.isLiked;
        final newCount = newIsLiked ? comment.likeCount + 1 : comment.likeCount - 1;
        activeComments[index] = comment.copyWith(
          isLiked: newIsLiked,
          likeCount: newCount,
        );
      }
    } else {
      // Subcomment reply
      final parentIndex = activeComments.indexWhere((c) => c.id == parentId);
      if (parentIndex != -1) {
        final parent = activeComments[parentIndex];
        final replyIndex = parent.replies.indexWhere((r) => r.id == commentId);
        if (replyIndex != -1) {
          final reply = parent.replies[replyIndex];
          final newIsLiked = !reply.isLiked;
          final newCount = newIsLiked ? reply.likeCount + 1 : reply.likeCount - 1;
          
          final updatedReplies = List<LiveCommentModel>.from(parent.replies);
          updatedReplies[replyIndex] = reply.copyWith(
            isLiked: newIsLiked,
            likeCount: newCount,
          );
          
          activeComments[parentIndex] = parent.copyWith(replies: updatedReplies);
        }
      }
    }
  }

  /// Saves a simulated live comment response or reply in real-time.
  void sendPlaybackComment(String message) {
    if (message.trim().isEmpty) return;

    final now = DateTime.now();
    final newComment = LiveCommentModel(
      id: 'c_playback_user_${now.millisecondsSinceEpoch}',
      userName: 'You (Seller)',
      message: message,
      timestamp: now,
    );

    if (replyingToComment.value != null) {
      final parent = replyingToComment.value!;
      final parentIndex = activeComments.indexWhere((c) => c.id == parent.id);
      
      if (parentIndex != -1) {
        final updatedReplies = List<LiveCommentModel>.from(parent.replies)
          ..add(newComment.copyWith(parentId: parent.id));
        
        activeComments[parentIndex] = parent.copyWith(replies: updatedReplies);
      }
      replyingToComment.value = null; // Clear reply scope
    } else {
      activeComments.add(newComment);
    }
  }

  /// Spawns a floating heart bubble trigger.
  void triggerHeart() {
    floatingHearts.add(_heartCounter++);
    // Keep list clean, remove older triggers after they drift away
    if (floatingHearts.length > 25) {
      floatingHearts.removeAt(0);
    }
  }
}

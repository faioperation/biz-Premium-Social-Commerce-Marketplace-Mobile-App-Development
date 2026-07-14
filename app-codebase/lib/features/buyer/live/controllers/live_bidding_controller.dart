import 'dart:async';
import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live_activity_model.dart';

class LiveBiddingController extends GetxController {
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  Timer? _auctionTimer;
  final secondsRemaining = 35.obs;
  final isAuctionEnded = false.obs;
  final showEndBanner = false.obs;

  final currentBid = 420.0.obs;
  final highestBidder = 'John Smith'.obs;
  final totalBids = 23.obs;

  final isLiked = false.obs;
  final isFollowing = false.obs;

  void toggleFollow() {
    isFollowing.toggle();
    Get.snackbar(
      isFollowing.value ? 'Following' : 'Unfollowed',
      isFollowing.value
          ? 'You are now following this seller!'
          : 'You unfollowed this seller.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFollowing.value
          ? Colors.green.withValues(alpha: 0.9)
          : Colors.black87.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  final activities = <LiveActivityModel>[
    LiveActivityModel(username: 'John Smith', text: 'How much? 🤔', isBid: false),
    LiveActivityModel(username: 'John Smith', text: 'Start auction 🔥', isBid: false),
    LiveActivityModel(
      username: 'John Smith',
      text: 'placed ${AppConstants.currencySymbol}400',
      isBid: true,
    ),
    LiveActivityModel(
      username: 'John Smith',
      text: 'This is amazing!',
      isBid: false,
    ),
    LiveActivityModel(
      username: 'John Smith',
      text: 'placed ${AppConstants.currencySymbol}420',
      isBid: true,
    ),
  ].obs;

  Function? onAuctionWonCallback;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _auctionTimer?.cancel();
    commentController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void startTimer() {
    _auctionTimer?.cancel();
    _auctionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _auctionTimer?.cancel();
        _endAuction();
      }
    });
  }

  void resetAuction() {
    secondsRemaining.value = 35;
    isAuctionEnded.value = false;
    showEndBanner.value = false;
    currentBid.value = 420.0;
    highestBidder.value = 'John Smith';
    totalBids.value = 23;

    activities.removeWhere((act) => act.username == 'You');

    startTimer();

    Get.snackbar(
      'Auction Reset',
      'The live auction has restarted! Place your bid to test the winning flow.',
      backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _endAuction() {
    isAuctionEnded.value = true;
    if (highestBidder.value == 'You') {
      if (onAuctionWonCallback != null) {
        onAuctionWonCallback!();
      }
    } else {
      showEndBanner.value = true;
    }
  }

  void placeBid(double amount) {
    currentBid.value = amount;
    highestBidder.value = 'You';
    totalBids.value++;

    activities.add(
      LiveActivityModel(
        username: 'You',
        text:
            'placed ${AppConstants.currencySymbol}${amount.toStringAsFixed(0)}',
        isBid: true,
      ),
    );

    Get.snackbar(
      'Bid Placed!',
      'You are now the highest bidder at ${AppConstants.currencySymbol}${amount.toStringAsFixed(0)}!',
      backgroundColor: Colors.pinkAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    _scrollFeedToBottom();
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    bool isBid =
        text.toLowerCase().contains('placed') ||
        text.toLowerCase().contains(AppConstants.currencySymbol) ||
        RegExp(r'\d+').hasMatch(text);

    activities.add(
      LiveActivityModel(
        username: 'You',
        text: isBid ? 'placed $text' : text,
        isBid: isBid,
      ),
    );
    commentController.clear();

    _scrollFeedToBottom();
  }

  void _scrollFeedToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleLike() {
    isLiked.toggle();
    Get.snackbar(
      isLiked.value ? 'Loved!' : 'Unloved',
      isLiked.value ? 'You liked the live stream!' : 'You removed your like.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isLiked.value
          ? Colors.pink.withValues(alpha: 0.8)
          : Colors.black87.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
}

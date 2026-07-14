import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Central share utility for the entire app.
/// All share calls go through this class so API integration
/// only needs one change point in the future.
class AppShareService {
  AppShareService._();

  // ─── App Deep-Link Base ───────────────────────────────────────────────────
  // Replace this with your real domain once you have one.
  static const String _baseUrl = 'https://smartwatch.app';

  // ─── Share Methods ────────────────────────────────────────────────────────

  /// Share a product (from Discover or any product card)
  static Future<void> shareProduct({
    required String productId,
    required String productName,
    required double price,
    String? sellerName,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/product/$productId';
    final seller = sellerName != null ? ' by $sellerName' : '';
    final message =
        '🛍️ Check out "$productName"$seller – only \$${price.toStringAsFixed(0)}!\n\n'
        'Shop now 👉 $link\n\n'
        '#Bizsolutio #Shopping #Deals';
    await _share(message, subject: 'Check out this product!', context: context);
  }

  /// Share a live sell stream
  static Future<void> shareLiveStream({
    required String streamId,
    required String title,
    required String sellerName,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/live/$streamId';
    final message =
        '🔴 LIVE NOW: "$title" by $sellerName!\n\n'
        'Watch & shop live 👉 $link\n\n'
        '#Bizsolutio #LiveShopping #LiveSale';
    await _share(message, subject: 'Watch this live stream!', context: context);
  }

  /// Share a live auction/bidding stream
  static Future<void> shareLiveAuction({
    required String streamId,
    required String title,
    required String sellerName,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/auction/$streamId';
    final message =
        '🔨 LIVE AUCTION: "$title" by $sellerName!\n\n'
        'Join the bidding now 👉 $link\n\n'
        '#Bizsolutio #LiveAuction #Bidding';
    await _share(message, subject: 'Join this live auction!', context: context);
  }

  /// Share a seller shop / store profile
  static Future<void> shareShop({
    required String shopId,
    required String shopName,
    String? tagline,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/shop/$shopId';
    final extra = tagline != null ? '\n$tagline' : '';
    final message =
        '🏪 Discover "$shopName"!$extra\n\n'
        'Visit the shop 👉 $link\n\n'
        '#Bizsolutio #Shop #Fashion';
    await _share(message, subject: 'Check out this shop!', context: context);
  }

  /// Share a buyer profile
  static Future<void> shareBuyerProfile({
    required String profileId,
    required String userName,
    String? bio,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/user/$profileId';
    final extra = (bio != null && bio.isNotEmpty) ? '\n$bio' : '';
    final message =
        '👤 Check out $userName\'s profile!$extra\n\n'
        'View profile 👉 $link\n\n'
        '#Bizsolutio #Profile';
    await _share(message, subject: 'Check out this profile!', context: context);
  }

  /// Share a feed post (home screen day/post)
  static Future<void> shareFeedPost({
    required String postId,
    String? caption,
    String? sellerName,
    BuildContext? context,
  }) async {
    final link = '$_baseUrl/post/$postId';
    final name = sellerName != null ? ' by $sellerName' : '';
    final cap = (caption != null && caption.isNotEmpty) ? '\n"$caption"' : '';
    final message =
        '✨ Check this out$name!$cap\n\n'
        'See the post 👉 $link\n\n'
        '#Bizsolutio #Fashion #Style';
    await _share(message, subject: 'Look at this post!', context: context);
  }

  // ─── Internal Helper ──────────────────────────────────────────────────────

  static Future<void> _share(
    String text, {
    String? subject,
    BuildContext? context,
  }) async {
    // 0. Extract sharePositionOrigin safely before any async gap without crashing on slivers
    Rect? sharePositionOrigin;
    if (context != null && context.mounted) {
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        sharePositionOrigin = Rect.fromLTWH(
          position.dx,
          position.dy,
          renderObject.size.width,
          renderObject.size.height,
        );
      }
    }

    // 1. Copy to clipboard automatically as a fail-proof backup
    try {
      await Clipboard.setData(ClipboardData(text: text));
      
      // 2. Show a premium, modern floating notification using standard ScaffoldMessenger
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Link copied! Opening sharing options...',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF13101E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Clipboard copy failed: $e');
    }

    // 3. Trigger native share sheets (using context-based share origin for iPad / macOS compatibility)
    try {
      await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Native share failed: $e');
    }
  }
}

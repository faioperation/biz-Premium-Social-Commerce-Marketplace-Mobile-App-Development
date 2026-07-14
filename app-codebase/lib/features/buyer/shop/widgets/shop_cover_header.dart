import 'package:flutter/material.dart';
import '../../../../core/services/app_share_service.dart';

class ShopCoverHeader extends StatelessWidget {
  final String coverImageUrl;
  final bool isDark;
  final String shopId;
  final String shopName;

  const ShopCoverHeader({
    super.key,
    required this.coverImageUrl,
    required this.isDark,
    this.shopId = 'shop',
    this.shopName = 'Shop',
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      pinned: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => AppShareService.shareShop(
              shopId: shopId,
              shopName: shopName,
              context: context,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          coverImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
        ),
      ),
    );
  }
}

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';

  static const String registerBuyer = '/register/buyer';
  static const String registerSeller = '/register/seller';
  static const String sellerRegStep1 = '/register/seller/step1';
  static const String sellerRegStep2 = '/register/seller/step2';
  static const String sellerRegStep3 = '/register/seller/step3';
  static const String sellerRegStep4 = '/register/seller/step4';
  static const String sellerRegStep5 = '/register/seller/step5';

  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String passwordSuccess = '/password-success';

  static const String buyerHome = '/buyer/home';
  static const String buyerDiscover = '/buyer/discover';
  static const String discoverProducts = '/buyer/discover/products';
  static const String discoverProductDetails = '/buyer/discover/details';
  static const String buyerLive = '/buyer/live';
  static const String buyerLiveSell = '/buyer/live/sell';
  static const String buyerLiveBidding = '/buyer/live/bidding';
  static const String buyerInbox = '/buyer/inbox';
  static const String buyerProfile = '/buyer/profile';

  static const String sellerDashboard = '/seller/dashboard';
  static const String sellerRevenueAnalytics = '/seller/dashboard/revenue-analytics';
  static const String sellerProducts = '/seller/products';
  static const String sellerAddProduct = '/seller/products/add';
  static const String sellerCreateStory = '/seller/story/create';
  static const String sellerViewStory = '/seller/story/view';
  static const String sellerLive = '/seller/live';
  static const String sellerOrders = '/seller/orders';
  static const String sellerOrderDetail = '/seller/orders/detail';
  static const String sellerProfile = '/seller/profile';
  static const String sellerStore = '/seller/store';
  static const String sellerStoreSettings = '/seller/store/settings';
  static const String sellerSetupLivestream = '/seller/live/setup';
  static const String sellerLivePreview = '/seller/live-preview';
  static const String sellerLiveBroadcast = '/seller/live-broadcast';
  static const String sellerPastLivesList = '/seller/live/past-lives';
  static const String sellerPastLivePlayback = '/seller/live/past-lives/playback';
  static const String sellerSettings = '/seller/settings';
  static const String sellerMessages = '/seller/messages';
  static const String trending = '/buyer/home/trending';
  static const String flashSale = '/buyer/home/flash-sale';
  static const String following = '/buyer/home/following';
  static const String liveNow = '/buyer/home/live-now';
  static const String notifications = '/buyer/home/notifications';

  // Checkout flow (uses MaterialPageRoute, registered for named route access)
  static const String checkout = '/checkout';
  static const String checkoutAddress = '/checkout/address';
  static const String checkoutPayment = '/checkout/payment';
  static const String checkoutSuccess = '/checkout/success';

  // Profile Sub-screens
  static const String profileOrders = '/buyer/profile/orders';
  static const String profileWishlist = '/buyer/profile/wishlist';
  static const String profileCart = '/buyer/profile/cart';
  static const String profileSettings = '/buyer/profile/settings';
  static const String profileEdit = '/buyer/profile/edit';
  static const String profileChangePassword = '/buyer/profile/change-password';
  static const String privacyPolicy = '/buyer/profile/privacy-policy';
  static const String privacySecurity = '/buyer/profile/privacy-security';
  static const String termsOfService = '/buyer/profile/terms-of-service';

  // ── Shop Profile ────────────────────────────────────────────────────────
  static const String shopProfile = '/buyer/shop/profile';

  // ── Inbox / Messaging ────────────────────────────────────────────────────
  // Neutral path — accessible by both buyer and seller
  static const String chatScreen = '/chat';
}

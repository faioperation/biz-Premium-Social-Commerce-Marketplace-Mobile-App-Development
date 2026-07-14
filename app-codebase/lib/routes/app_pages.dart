import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/buyer/navigation/buyer_navigation_screen.dart';
import '../features/seller/navigation/screens/seller_navigation_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/splash_screen.dart';
import '../features/auth/views/role_selection_screen.dart';
import '../features/auth/views/register/buyer_register_screen.dart';
import '../features/auth/views/register/seller_register_screen.dart';
import '../features/auth/views/forgot_password/forgot_password_screen.dart';
import '../features/auth/views/forgot_password/otp_verification_screen.dart';
import '../features/auth/views/forgot_password/reset_password_screen.dart';
import '../features/auth/views/forgot_password/success_screen.dart';
import '../features/auth/views/seller_registration/seller_registration_screen1.dart';
import '../features/auth/views/seller_registration/seller_registration_screen2.dart';
import '../features/auth/views/seller_registration/seller_registration_screen3.dart';
import '../features/auth/views/seller_registration/seller_registration_screen4.dart';
import '../features/auth/views/seller_registration/seller_registration_screen5.dart';
import '../features/auth/controllers/seller_registration_controller.dart';
import '../features/buyer/home/screens/home_screen.dart';
import '../features/buyer/home/screens/trending_screen.dart';
import '../features/buyer/home/screens/flash_sale_screen.dart';
import '../features/buyer/home/screens/following_screen.dart';
import '../features/buyer/home/models/live_model.dart';
import '../features/buyer/home/screens/live_list_screen.dart';
import '../features/buyer/home/screens/notification_screen.dart';
import '../features/buyer/discover/screens/discover_screen.dart';
import '../features/buyer/discover/screens/discover_product_list_screen.dart';
import '../features/buyer/discover/screens/discover_product_details_screen.dart';
import '../features/buyer/discover/models/category_model.dart';
import '../features/buyer/discover/models/discover_product_model.dart';
import '../features/buyer/live/screens/live_screen.dart';
import '../features/buyer/live/screens/live_sell_screen.dart';
import '../features/buyer/live/screens/live_bidding_screen.dart';
import '../features/buyer/inbox/screens/inbox_list_screen.dart';
import '../features/buyer/inbox/screens/chat_screen.dart';
import '../features/buyer/inbox/controllers/inbox_controller.dart';
import '../features/buyer/profile/screens/profile_screen.dart';
import '../features/buyer/checkout/screens/checkout_screen.dart';
import '../features/buyer/checkout/screens/select_address_screen.dart';
import '../features/buyer/checkout/screens/payment_method_screen.dart';
import '../features/buyer/checkout/screens/order_success_screen.dart';
import '../features/buyer/profile/screens/my_orders_screen.dart';
import '../features/buyer/profile/screens/wishlist_screen.dart';
import '../features/buyer/profile/screens/cart_screen.dart';
import '../features/buyer/profile/screens/settings_screen.dart';
import '../features/buyer/profile/screens/edit_profile_screen.dart';
import '../features/buyer/profile/screens/change_password_screen.dart';
import '../features/buyer/profile/screens/privacy_policy_screen.dart';
import '../features/buyer/profile/screens/privacy_security_screen.dart';
import '../features/buyer/profile/screens/terms_of_service_screen.dart';
import '../features/buyer/shop/screens/shop_profile_screen.dart';
import '../features/seller/dashboard/screens/dashboard_screen.dart';
import '../features/seller/dashboard/screens/revenue_analytics_screen.dart';
import '../features/seller/products/screens/add_product_screen.dart';
import '../features/seller/products/models/product_model.dart';
import '../features/seller/orders/models/order_model.dart';
import '../features/seller/orders/screens/orders_screen.dart';
import '../features/seller/orders/screens/order_detail_screen.dart';
import '../features/seller/profile/screens/profile_screen.dart';
import '../features/seller/inbox/screens/inbox_screen.dart';
import '../features/seller/Store/screens/store_profile_screen.dart';
import '../features/seller/Store/screens/store_settings_screen.dart';
import '../features/seller/Store/screens/create_story_screen.dart';
import '../features/seller/Store/screens/seller_story_viewer_screen.dart';
import '../features/seller/live/screens/setup_livestream_screen.dart';
import '../features/seller/live/screens/live_preview_screen.dart';
import '../features/seller/live/screens/live_broadcast_screen.dart';
import '../features/seller/live/models/live_session_data.dart';
import '../features/seller/settings/screens/seller_settings_screen.dart';
import '../features/seller/liveList/models/past_live_stream_model.dart';
import '../features/seller/liveList/screens/seller_live_list_screen.dart';
import '../features/seller/liveList/screens/seller_past_live_playback_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppPages {
  AppPages._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      StreamGroup.merge([
        Get.find<AuthController>().isAuthenticated.stream,
        Get.find<AuthController>().userRole.stream,
      ]),
    ),
    redirect: (context, state) {
      final authController = Get.find<AuthController>();
      final isAuth = authController.isAuthenticated.value;
      final role = authController.userRole.value;

      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isRoleSelection = state.matchedLocation == AppRoutes.roleSelection;
      final isLogin = state.matchedLocation == AppRoutes.login;
      final isRegister = state.matchedLocation.startsWith('/register');
      final isForgotPassword =
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.otpVerification ||
          state.matchedLocation == AppRoutes.resetPassword ||
          state.matchedLocation == AppRoutes.passwordSuccess;

      final isAuthRoute =
          isSplash ||
          isRoleSelection ||
          isLogin ||
          isRegister ||
          isForgotPassword;

      if (!isAuth) {
        return isAuthRoute ? null : AppRoutes.splash;
      }

      if (isAuthRoute) {
        if (role == UserRole.buyer) {
          return AppRoutes.buyerHome;
        } else if (role == UserRole.seller) {
          return AppRoutes.sellerDashboard;
        }
      }

      final isBuyerRoute = state.matchedLocation.startsWith('/buyer');
      final isSellerRoute = state.matchedLocation.startsWith('/seller');
      // /chat is a shared route — accessible by both buyer and seller
      final isChatRoute = state.matchedLocation.startsWith('/chat');

      if (role == UserRole.buyer && isSellerRoute) return AppRoutes.buyerHome;
      if (role == UserRole.seller && isBuyerRoute && !isChatRoute) {
        return AppRoutes.sellerDashboard;
      }

      if (state.matchedLocation == '/') {
        return (role == UserRole.seller)
            ? AppRoutes.sellerDashboard
            : AppRoutes.buyerHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.buyer;
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.registerBuyer,
        builder: (context, state) => const BuyerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerSeller,
        builder: (context, state) => const SellerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerRegStep1,
        builder: (context, state) {
          Get.lazyPut(() => SellerRegistrationController());
          return const SellerRegistrationScreen1();
        },
      ),
      GoRoute(
        path: AppRoutes.sellerRegStep2,
        builder: (context, state) => const SellerRegistrationScreen2(),
      ),
      GoRoute(
        path: AppRoutes.sellerRegStep3,
        builder: (context, state) => const SellerRegistrationScreen3(),
      ),
      GoRoute(
        path: AppRoutes.sellerRegStep4,
        builder: (context, state) => const SellerRegistrationScreen4(),
      ),
      GoRoute(
        path: AppRoutes.sellerRegStep5,
        builder: (context, state) => const SellerRegistrationScreen5(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.passwordSuccess,
        builder: (context, state) => const PasswordSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) {
          final item = state.extra as dynamic;
          // To avoid circular dependency or import issues, we can just cast it or use it if we import the model
          // I will import OrderItemModel at the top. But since it's dynamic right now, I'll let it be passed.
          return CheckoutScreen(buyNowItem: item);
        },
      ),
      GoRoute(
        path: AppRoutes.checkoutAddress,
        builder: (context, state) => const SelectAddressScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkoutPayment,
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkoutSuccess,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileOrders,
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileWishlist,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileCart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileChangePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacySecurity,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.termsOfService,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.shopProfile,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return ShopProfileScreen(
            sellerName: args['sellerName'] ?? 'Unknown Shop',
            profileImageUrl:
                args['profileImageUrl'] ??
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.discoverProductDetails,
        builder: (context, state) {
          final prod = state.extra as DiscoverProductModel?;
          return DiscoverProductDetailsScreen(product: prod);
        },
      ),
      GoRoute(
        path: AppRoutes.chatScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return ChatScreen(
            chatId: args['chatId'] ?? '',
            shopName: args['shopName'] ?? 'Chat',
            profileImage: args['profileImage'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.buyerLiveSell,
        builder: (context, state) {
          final stream = state.extra as LiveStreamModel;
          return LiveSellScreen(stream: stream);
        },
      ),
      GoRoute(
        path: AppRoutes.buyerLiveBidding,
        builder: (context, state) {
          final stream = state.extra as LiveStreamModel;
          return LiveBiddingScreen(stream: stream);
        },
      ),
      GoRoute(
        path: AppRoutes.sellerRevenueAnalytics,
        builder: (context, state) => const SellerRevenueAnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerAddProduct,
        builder: (context, state) {
          final prod = state.extra as SellerProductModel?;
          return SellerAddProductScreen(editProduct: prod);
        },
      ),
      GoRoute(
        path: AppRoutes.sellerCreateStory,
        builder: (context, state) => const CreateStoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerViewStory,
        builder: (context, state) => const SellerStoryViewerScreen(),
      ),

      GoRoute(
        path: AppRoutes.sellerOrderDetail,
        builder: (context, state) {
          final order = state.extra as SellerOrderModel;
          return SellerOrderDetailScreen(order: order);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BuyerNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerHome,
                builder: (context, state) => const BuyerHomeScreen(),
              ),
              GoRoute(
                path: AppRoutes.trending,
                builder: (context, state) => const TrendingScreen(),
              ),
              GoRoute(
                path: AppRoutes.flashSale,
                builder: (context, state) => const FlashSaleScreen(),
              ),
              GoRoute(
                path: AppRoutes.following,
                builder: (context, state) => const FollowingScreen(),
              ),
              GoRoute(
                path: AppRoutes.liveNow,
                builder: (context, state) => const LiveListScreen(),
              ),
              GoRoute(
                path: AppRoutes.notifications,
                builder: (context, state) => const NotificationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerDiscover,
                builder: (context, state) => const DiscoverScreen(),
                routes: [
                  GoRoute(
                    path: 'products',
                    builder: (context, state) {
                      final cat = state.extra as CategoryModel?;
                      return DiscoverProductListScreen(category: cat);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerLive,
                builder: (context, state) => const BuyerLiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerInbox,
                builder: (context, state) {
                  if (!Get.isRegistered<InboxController>()) {
                    Get.put(InboxController(), permanent: true);
                  }
                  return const InboxListScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerProfile,
                builder: (context, state) => const BuyerProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Seller standalone routes (not in nav bar)
      GoRoute(
        path: AppRoutes.sellerProfile,
        builder: (context, state) => const SellerProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerStoreSettings,
        builder: (context, state) => const StoreSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerSettings,
        builder: (context, state) => const SellerSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerSetupLivestream,
        builder: (context, state) => const SetupLivestreamScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerLivePreview,
        builder: (context, state) {
          final sessionData = state.extra as LiveSessionData;
          return LivePreviewScreen(sessionData: sessionData);
        },
      ),
      GoRoute(
        path: AppRoutes.sellerLiveBroadcast,
        builder: (context, state) {
          final sessionData = state.extra as LiveSessionData;
          return LiveBroadcastScreen(sessionData: sessionData);
        },
      ),
      GoRoute(
        path: AppRoutes.sellerPastLivesList,
        builder: (context, state) => const SellerLiveListScreen(),
      ),
      GoRoute(
        path: AppRoutes.sellerPastLivePlayback,
        builder: (context, state) {
          final pastLive = state.extra as PastLiveStreamModel;
          return SellerPastLivePlaybackScreen(pastLive: pastLive);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SellerNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Index 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerDashboard,
                builder: (context, state) => const SellerDashboardScreen(),
              ),
            ],
          ),
          // Index 1: Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerOrders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          // Index 2: Go Live
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerLive,
                builder: (context, state) => const SetupLivestreamScreen(),
              ),
            ],
          ),
          // Index 3: Messages
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerMessages,
                builder: (context, state) => const SellerInboxScreen(),
              ),
            ],
          ),
          // Index 4: Store
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerStore,
                builder: (context, state) => const StoreProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class StreamGroup {
  static Stream<T> merge<T>(Iterable<Stream<T>> streams) {
    final controller = StreamController<T>();
    final subscriptions = <StreamSubscription<T>>[];

    void onDone(StreamSubscription<T> sub) {
      subscriptions.remove(sub);
      if (subscriptions.isEmpty) {
        controller.close();
      }
    }

    for (var stream in streams) {
      late StreamSubscription<T> sub;
      sub = stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: () => onDone(sub),
      );
      subscriptions.add(sub);
    }

    return controller.stream;
  }
}

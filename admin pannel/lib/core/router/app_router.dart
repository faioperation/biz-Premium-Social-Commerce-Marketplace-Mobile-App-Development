import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'auth_guard.dart';
import '../layout/admin_layout.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../../features/users/presentation/pages/user_details_page.dart';
import '../../features/sellers/presentation/pages/sellers_page.dart';
import '../../features/sellers/presentation/pages/seller_details_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reports/presentation/pages/report_details_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/notifications/presentation/pages/notification_form_page.dart';
import '../../features/support/presentation/pages/support_tickets_page.dart';
import '../../features/support/presentation/pages/ticket_details_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/wallets/presentation/pages/wallets_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auctions/presentation/pages/auctions_page.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

// A simple placeholder widget generator to quickly wire up architecture
Widget _placeholderPage(String title) {
  return Scaffold(
    body: Center(
      child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ),
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: AuthGuard.redirect,
  routes: [
    // Login route outside of the ShellRoute so it DOES NOT have the sidebar
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset-password',
      name: RouteNames.resetPassword,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return ResetPasswordPage(email: email);
      },
    ),
    
    // The ShellRoute provides the persistent Sidebar and Header for internal pages
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/users',
          name: RouteNames.users,
          builder: (context, state) => const UsersPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: RouteNames.userDetails,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return UserDetailsPage(userId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/sellers',
          name: RouteNames.sellers,
          builder: (context, state) => const SellersPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: RouteNames.sellerDetails,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return SellerDetailsPage(sellerId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/products',
          name: RouteNames.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: RouteNames.productDetails,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ProductDetailsPage(productId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/livestreams',
          name: RouteNames.livestreams,
          builder: (context, state) => _placeholderPage('Livestreams Management'),
        ),
        GoRoute(
          path: '/auctions',
          name: RouteNames.auctions,
          builder: (context, state) => const AuctionsPage(),
        ),
        GoRoute(
          path: '/orders',
          name: RouteNames.orders,
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/wallets',
          name: RouteNames.wallets,
          builder: (context, state) => const WalletsPage(),
        ),
        GoRoute(
          path: '/reports',
          name: RouteNames.reports,
          builder: (context, state) => const ReportsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: RouteNames.reportDetails,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ReportDetailsPage(reportId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          name: RouteNames.notifications,
          builder: (context, state) => const NotificationsPage(),
          routes: [
            GoRoute(
              path: 'form',
              name: RouteNames.notificationForm,
              builder: (context, state) {
                final id = state.uri.queryParameters['id'];
                return NotificationFormPage(notificationId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/analytics',
          name: RouteNames.analytics,
          builder: (context, state) => const AnalyticsPage(),
        ),
        GoRoute(
          path: '/cms',
          name: RouteNames.cms,
          builder: (context, state) => _placeholderPage('Content Management (CMS)'),
        ),
        GoRoute(
          path: '/support-tickets',
          name: RouteNames.supportTickets,
          builder: (context, state) => const SupportTicketsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: RouteNames.supportTicketDetails,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return TicketDetailsPage(ticketId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          name: RouteNames.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/roles-permissions',
          name: RouteNames.rolesPermissions,
          builder: (context, state) => _placeholderPage('Roles & Permissions'),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);

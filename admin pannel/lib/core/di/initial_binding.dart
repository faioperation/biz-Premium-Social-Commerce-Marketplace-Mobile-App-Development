import 'package:get/get.dart';
import '../network/http_client.dart';
import '../network/network_service.dart';
import '../theme/theme_controller.dart';
import '../controllers/currency_controller.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../../features/users/presentation/controllers/user_details_controller.dart';
import '../../features/sellers/data/repositories/seller_repository_impl.dart';
import '../../features/sellers/domain/repositories/seller_repository.dart';
import '../../features/sellers/presentation/controllers/sellers_controller.dart';
import '../../features/sellers/presentation/controllers/seller_details_controller.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/presentation/controllers/products_controller.dart';
import '../../features/products/presentation/controllers/product_details_controller.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/presentation/controllers/reports_controller.dart';
import '../../features/reports/presentation/controllers/report_details_controller.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/notifications/presentation/controllers/notification_form_controller.dart';
import '../../features/support/data/repositories/support_ticket_repository_impl.dart';
import '../../features/support/domain/repositories/support_ticket_repository.dart';
import '../../features/support/presentation/controllers/support_tickets_controller.dart';
import '../../features/support/presentation/controllers/ticket_details_controller.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Currency (Initialize before other core services that might need formatting)
    Get.put<CurrencyController>(CurrencyController(), permanent: true);

    // Theme (must be first so app.dart can access it during build)
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Core Services
    final httpClient = HttpClient();
    Get.put<HttpClient>(httpClient, permanent: true);
    final networkService = NetworkService(httpClient.instance);
    Get.put<NetworkService>(networkService, permanent: true);

    // Auth
    final authRepository = AuthRepositoryImpl(networkService);
    Get.put<AuthRepository>(authRepository, permanent: true);
    Get.put<AuthController>(AuthController(authRepository), permanent: true);

    // Dashboard
    final dashboardRepository = DashboardRepositoryImpl(networkService);
    Get.put<DashboardRepository>(dashboardRepository, permanent: true);
    Get.put<DashboardController>(DashboardController(dashboardRepository), permanent: true);

    // Users
    final userRepository = UserRepositoryImpl(networkService);
    Get.put<UserRepository>(userRepository, permanent: true);
    Get.put<UsersController>(UsersController(userRepository), permanent: true);
    Get.put<UserDetailsController>(UserDetailsController(userRepository), permanent: true);

    // Sellers
    final sellerRepository = SellerRepositoryImpl(networkService);
    Get.put<SellerRepository>(sellerRepository, permanent: true);
    Get.put<SellersController>(SellersController(sellerRepository), permanent: true);
    Get.put<SellerDetailsController>(SellerDetailsController(sellerRepository), permanent: true);

    // Products
    final productRepository = ProductRepositoryImpl(networkService);
    Get.put<ProductRepository>(productRepository, permanent: true);
    Get.put<ProductsController>(ProductsController(productRepository), permanent: true);
    Get.put<ProductDetailsController>(ProductDetailsController(productRepository), permanent: true);

    // Reports
    final reportRepository = ReportRepositoryImpl(networkService);
    Get.put<ReportRepository>(reportRepository, permanent: true);
    Get.put<ReportsController>(ReportsController(reportRepository), permanent: true);
    Get.put<ReportDetailsController>(ReportDetailsController(reportRepository), permanent: true);

    // Notifications
    final notificationRepository = NotificationRepositoryImpl(networkService);
    Get.put<NotificationRepository>(notificationRepository, permanent: true);
    Get.put<NotificationsController>(NotificationsController(notificationRepository), permanent: true);
    Get.put<NotificationFormController>(NotificationFormController(notificationRepository), permanent: true);

    // Support Tickets
    final supportTicketRepository = SupportTicketRepositoryImpl(networkService);
    Get.put<SupportTicketRepository>(supportTicketRepository, permanent: true);
    Get.put<SupportTicketsController>(SupportTicketsController(supportTicketRepository), permanent: true);
    Get.put<TicketDetailsController>(TicketDetailsController(supportTicketRepository), permanent: true);

    // Settings
    final settingsRepository = SettingsRepositoryImpl(networkService);
    Get.put<SettingsRepository>(settingsRepository, permanent: true);
    Get.put<SettingsController>(SettingsController(settingsRepository), permanent: true);
  }
}

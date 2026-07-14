import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/di/initial_binding.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class VangoLiveAdminApp extends StatelessWidget {
  const VangoLiveAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Vango Live Admin',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/config/environment.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  // 1. Ensure bindings are initialized for async setup
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize environment configuration (set to dev by default)
  EnvironmentConfig.init(env: Environment.dev);

  // 3. Initialize any other pre-run dependencies here (e.g., Firebase, Hive)
  await GetStorage.init();

  // 4. Set path URL strategy (Removes the # from web URLs)
  usePathUrlStrategy();

  // 5. Run the application
  runApp(const VangoLiveAdminApp());
}

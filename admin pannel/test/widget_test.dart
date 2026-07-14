import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_admin_bizsolutio/app.dart';
import 'package:ecommerce_admin_bizsolutio/core/config/environment.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('App boots up smoke test', (WidgetTester tester) async {
    Get.deleteAll(force: true);
    EnvironmentConfig.init(env: Environment.dev);
    await tester.pumpWidget(const VangoLiveAdminApp());
    expect(find.text('Vango Live Admin Panel - Dashboard (Placeholder)'), findsOneWidget);
  });
}

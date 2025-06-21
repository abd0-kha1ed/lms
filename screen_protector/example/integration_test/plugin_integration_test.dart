import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:screen_protector/screen_protector.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('enableScreenProtection test', (WidgetTester tester) async {
    final bool isProtected = await ScreenProtector.enableScreenProtection();
    expect(isProtected, true);
  });
}

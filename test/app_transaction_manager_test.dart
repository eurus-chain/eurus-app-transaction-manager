import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_transaction_manager/app_transaction_manager.dart';

void main() {
  const MethodChannel channel = MethodChannel('app_transaction_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AppTransactionManager.platformVersion, '42');
  });
}

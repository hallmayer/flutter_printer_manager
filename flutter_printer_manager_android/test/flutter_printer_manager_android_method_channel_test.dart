import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android_method_channel.dart.bak';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterPrinterManagerAndroid platform = MethodChannelFlutterPrinterManagerAndroid();
  const MethodChannel channel = MethodChannel('flutter_printer_manager_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

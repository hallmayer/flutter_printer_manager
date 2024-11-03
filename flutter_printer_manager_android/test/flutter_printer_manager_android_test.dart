import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android.dart';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android_platform_interface.dart.bak';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android_method_channel.dart.bak';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPrinterManagerAndroidPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPrinterManagerAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPrinterManagerAndroidPlatform initialPlatform = FlutterPrinterManagerAndroidPlatform.instance;

  test('$MethodChannelFlutterPrinterManagerAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPrinterManagerAndroid>());
  });


}

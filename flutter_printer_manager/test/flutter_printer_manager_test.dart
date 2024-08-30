import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager/flutter_printer_manager_platform_interface.dart';
import 'package:flutter_printer_manager/flutter_printer_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPrinterManagerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPrinterManagerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPrinterManagerPlatform initialPlatform = FlutterPrinterManagerPlatform.instance;

  test('$MethodChannelFlutterPrinterManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPrinterManager>());
  });

  test('getPlatformVersion', () async {
    FlutterPrinterManager flutterPrinterManagerPlugin = FlutterPrinterManager();
    MockFlutterPrinterManagerPlatform fakePlatform = MockFlutterPrinterManagerPlatform();
    FlutterPrinterManagerPlatform.instance = fakePlatform;

    expect(await flutterPrinterManagerPlugin.getPlatformVersion(), '42');
  });
}

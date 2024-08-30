import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_printer_manager_method_channel.dart';

abstract class FlutterPrinterManagerPlatform extends PlatformInterface {
  /// Constructs a FlutterPrinterManagerPlatform.
  FlutterPrinterManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPrinterManagerPlatform _instance = MethodChannelFlutterPrinterManager();

  /// The default instance of [FlutterPrinterManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPrinterManager].
  static FlutterPrinterManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPrinterManagerPlatform] when
  /// they register themselves.
  static set instance(FlutterPrinterManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

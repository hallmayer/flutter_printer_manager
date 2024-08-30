import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_printer_manager_platform_interface.dart';

/// An implementation of [FlutterPrinterManagerPlatform] that uses method channels.
class MethodChannelFlutterPrinterManager extends FlutterPrinterManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_printer_manager');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

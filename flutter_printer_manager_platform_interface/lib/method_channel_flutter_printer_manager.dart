import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_printer_manager_platform_interface/src/flutter_printer_manager_platform.dart';
import 'package:flutter_printer_manager_platform_interface/src/printer.dart';

class MethodChannelFlutterPrinterManager extends FlutterPrinterManagerPlatform {

  @visibleForTesting
  final methodChannel = const MethodChannel('plugins.diformatics.de/flutter_printer_manager');

  @override
  Future<bool> closeUSBConnection() {
    // TODO: implement closeUSBConnection
    throw UnimplementedError();
  }

  @override
  Future<USBPrinterState> getCurrentPrinterState() {
    // TODO: implement getCurrentPrinterState
    throw UnimplementedError();
  }

  @override
  Future<List<USBPrinter>> getUSBDevices() {
    return methodChannel.invokeListMethod<USBPrinter>("getUSBDevices") as Future<List<USBPrinter>>;
  }

  @override
  Future<bool> openUSBConnection(int? vendorId, int? productId) {
    // TODO: implement openUSBConnection
    throw UnimplementedError();
  }

  @override
  Future<bool> printBytes(List<int> bytes) {
    // TODO: implement printBytes
    throw UnimplementedError();
  }

  @override
  Future<bool> selectUSBDevice(int vendorId, int productId) {
    // TODO: implement selectUSBDevice
    throw UnimplementedError();
  }


}

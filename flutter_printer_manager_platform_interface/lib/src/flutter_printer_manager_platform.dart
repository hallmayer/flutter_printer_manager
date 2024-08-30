library flutter_printer_manager_platform_interface;

import 'package:flutter_printer_manager_platform_interface/method_channel_flutter_printer_manager.dart';
import 'package:flutter_printer_manager_platform_interface/src/printer.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterPrinterManagerPlatform extends PlatformInterface {
  
  FlutterPrinterManagerPlatform() : super(token: _token);
static final Object _token = Object();

  static FlutterPrinterManagerPlatform _instance = MethodChannelFlutterPrinterManager();

  static FlutterPrinterManagerPlatform get instance => _instance;

  static set instance(FlutterPrinterManagerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }


  Future<List<USBPrinter>> getUSBDevices();
  Future<bool> selectUSBDevice(int vendorId, int productId);

  Future<bool> openUSBConnection(int? vendorId, int? productId);

  Future<bool> closeUSBConnection();

  Future<USBPrinterState> getCurrentPrinterState();

  Future<bool> printBytes(List<int> bytes);




}
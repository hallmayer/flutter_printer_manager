import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class FlutterPrinterController {
  static Future<List<USBPrinter>> discoverUSBPrinters() {
    return FlutterPrinterManagerPlatform.instance.getUSBDevices(); 
  }
}
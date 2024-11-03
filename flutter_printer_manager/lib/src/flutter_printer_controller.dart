import 'dart:async';
import 'dart:io';

import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager/src/models/usb_printer_connector.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';



enum PrinterType {
  network, usb
}
class FlutterPrinterController {


  FlutterPrinterController._();

  static final FlutterPrinterController _instance = FlutterPrinterController._();

  static FlutterPrinterController get instance => _instance;

  final tcpPrinterConnector = TcpPrinterConnector();
  final usbPrinterConnector = UsbPrinterConnector();


  Future<List<PrinterModel>> discovery({required PrinterType printerType}) {
    if(printerType == PrinterType.network) {
      return tcpPrinterConnector.discovery();
    } else if(printerType == PrinterType.usb && (Platform.isAndroid)) {
      return usbPrinterConnector.discovery();
    }
    throw UnimplementedError();
  }





  static Future<List<USBPrinter>> discoverUSBPrinters() {
    return FlutterPrinterManagerPlatform.instance.getUSBDevices();
  }


}


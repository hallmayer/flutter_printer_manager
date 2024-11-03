import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class UsbPrinterConnector extends PrinterConnector<USBPrinter> {

  static final UsbPrinterConnector _instance = UsbPrinterConnector._internal();

  factory UsbPrinterConnector() {
    return _instance;
  }
  UsbPrinterConnector._internal() {
    isConnectedStream.add(false);
  }

  @override
  Future<bool> connect(USBPrinter model) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<bool> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<USBPrinter>> discovery() {
      return FlutterPrinterManagerPlatform.instance.getUSBDevices();
  }

  @override
  Future<bool> send(List<int> bytes) {
    // TODO: implement send
    throw UnimplementedError();
  }

}
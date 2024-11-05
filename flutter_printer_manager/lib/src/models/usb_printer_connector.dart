import 'package:flutter_printer_manager/src/utils/logger.dart';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class UsbPrinterConnector extends PrinterConnector<USBPrinter> {
  static final UsbPrinterConnector _instance = UsbPrinterConnector._internal();

  Stream<dynamic>? stateStream;

  factory UsbPrinterConnector() {
    return _instance;
  }
  UsbPrinterConnector._internal() {
    isConnectedStream.add(PrinterState.none);
  }

  @override
  Future<bool> connect(USBPrinter model) async {
    bool result = await FlutterPrinterManagerPlatform.instance.openUSBConnection(model.vendorId, model.productId);
    if (result) {
      isConnected = true;
      isConnectedStream.add(PrinterState.connected);
      stateStream = USBStatusEventChannel.eventChannel.receiveBroadcastStream(); 
      logger.d("Start subscribing to USB Event channel");
      stateStream?.listen((event){
        logger.d("Recieved event from USB Stream $event");
        if(event == 2) {  
          isConnectedStream.add(PrinterState.disconnected);
        } else if(event == 1) {
          isConnectedStream.add(PrinterState.connected);
        } else {
          isConnectedStream.add(PrinterState.none);
        }
        
      });
    } else {
      isConnected = false;
      isConnectedStream.add(PrinterState.disconnected);
    }
    return result;
  }

  @override
  Future<bool> disconnect() async {
    await FlutterPrinterManagerPlatform.instance.closeUSBConnection();
    isConnected = false;
    isConnectedStream.add(PrinterState.disconnected);
    stateStream = null;
    return false;
  }

  @override
  Future<List<USBPrinter>> discovery() {
    return FlutterPrinterManagerPlatform.instance.getUSBDevices();
  }

  @override
  Future<bool> send(List<int> bytes) async {
     bool result = await FlutterPrinterManagerPlatform.instance.printBytes(bytes);
     return result;
  }

  Future<bool> hasPermissionsForDevice(USBPrinter model) async {
    return FlutterPrinterManagerPlatform.instance.hasUSBPermissions(model.vendorId, model.productId, requestPermissions: true);
  }
  Future<bool> selectDevice(USBPrinter model) async {
    return FlutterPrinterManagerPlatform.instance.selectUSBDevice(model.vendorId, model.productId);
  }
}

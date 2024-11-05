import 'package:flutter/widgets.dart';
import 'package:flutter_printer_manager_android/src/flutter_printer_manager_api.g.dart' as pigeon;
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';


class FlutterPrinterManagerAndroid extends FlutterPrinterManagerPlatform {
  FlutterPrinterManagerAndroid({
    @visibleForTesting pigeon.FlutterPrinterManagerApi? api,
  }) : _hostApi = api ?? pigeon.FlutterPrinterManagerApi();

  final pigeon.FlutterPrinterManagerApi _hostApi;

  static void registerWith() {
    FlutterPrinterManagerPlatform.instance = FlutterPrinterManagerAndroid();
  }


  @override
  Future<List<USBPrinter>> getUSBDevices() async {
    final devices = await _hostApi.getPrinters();
    List<USBPrinter> printers = [];
    for(var device in devices) {
      if(device != null) {
        printers.add(USBPrinter(productId: device.productId, vendorId: device.vendorId, manufacturerName: device.manufacturerName, productName: device.productName));
      }
    }
    return printers;
  }


  @override
  Future<bool> selectUSBDevice(int vendorId, int productId) async {
    return await _hostApi.selectUSBDevice(vendorId, productId);
  }

  @override
  Future<bool> openUSBConnection(int? vendorId, int? productId) async {
    return await _hostApi.openUSBConnection(vendorId, productId);
  }

  @override
  Future<bool> closeUSBConnection() async {
    return await _hostApi.closeUSBConnection();
  }

  @override
  Future<bool> printBytes(List<int> bytes) async {
    return await _hostApi.printBytes(bytes);
  }

  @override
  Future<PrinterState> getCurrentPrinterState() async {
    var state =  await _hostApi.getCurrentPrinterState();
    switch(state) {
      
      case pigeon.USBPrinterState.none:
        return PrinterState.none; 
      case pigeon.USBPrinterState.connected: 
        return PrinterState.connected; 
      case pigeon.USBPrinterState.disconnected: 
        return PrinterState.disconnected;
    }
  }
  
  @override
  Future<bool> hasUSBPermissions(int vendorId, int productId, {bool requestPermissions = false}) {
    return _hostApi.hasUSBPermissions(vendorId, productId);
  }






}


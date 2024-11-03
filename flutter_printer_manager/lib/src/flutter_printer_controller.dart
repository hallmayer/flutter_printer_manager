import 'dart:async';
import 'dart:io';

import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager/src/utils/network_analyzer.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';
import 'package:network_info_plus/network_info_plus.dart';

class FlutterPrinterController {
  static Future<List<USBPrinter>> discoverUSBPrinters() {
    return FlutterPrinterManagerPlatform.instance.getUSBDevices();
  }

  static Future<List<TcpPrinterModel>> discoverNetworkPrinters(
      {int port = 9100, int startIp = 2, int endIp = 255}) async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiGatewayIP();
    final wifiSubnet = await info.getWifiSubmask();
    if (wifiIP == null || wifiSubnet == null) {
      throw NotConnectedException();
    }
    String netIp = wifiIP.substring(0, wifiIP.length - 2);   
    return (await NetworkAnalyzer.discoverByPortAndSubnetFuture(subnet: netIp,port:  port, timeout: const Duration(milliseconds: 500))).map((address) => TcpPrinterModel(host: address.address, port: port, hostname: address.host)).toList();
    
  }
  
}


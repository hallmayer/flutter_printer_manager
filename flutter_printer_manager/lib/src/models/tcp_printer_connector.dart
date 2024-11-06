import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_printer_manager/src/utils/logger.dart';
import 'package:flutter_printer_manager/src/utils/network_analyzer.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';
import 'package:network_info_plus/network_info_plus.dart';

class TcpPrinterConnector extends PrinterConnector<TcpPrinter> {
  TcpPrinter? printer;
  Socket? _socket;

  static final TcpPrinterConnector _instance = TcpPrinterConnector._internal();

  factory TcpPrinterConnector() {
    return _instance;
  }

  TcpPrinterConnector._internal() {
    isConnectedStream.add(PrinterState.none);
  }

  @override
  Future<bool> connect(model) async {
    if (_socket != null) {
      _socket?.destroy();
    }
    try {
      var socket = await Socket.connect(model.host, model.port, timeout: const Duration(milliseconds: 500)).then((socket) {
        return socket;
      });

      printer = model;
      _socket = socket;
      isConnected = true;
      isConnectedStream.add(PrinterState.connected);
      return true;
    } catch (e) {
      disconnect();
      isConnectedStream.add(PrinterState.disconnected);
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> disconnect() async {
    isConnected = false;
   //isConnectedStream.add(PrinterState.disconnected);
    _socket?.destroy();
    _socket = null;
    return true;
  }

  @override
  Future<bool> send(List<int> bytes) async {
    if (printer == null) {
      throw Exception("No Printer");
    }
    if (printer != null && (_socket == null || isConnected == false)) {
      var result = await connect(printer!);
      if (!result) return result;
    }

    try {
      _socket?.add(Uint8List.fromList(bytes));
      IOSink result = await _socket?.flush();
      return true;
      //logger.d(res2);
    } catch (e) {
       isConnectedStream.add(PrinterState.disconnected);
      return false;
    } finally {
      disconnect();
    }

    //  _socket?.destroy();
    // _socket = null;
  }

  @override
  Future<List<TcpPrinter>> discovery() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiGatewayIP();
    final wifiSubnet = await info.getWifiSubmask();
    if (wifiIP == null || wifiSubnet == null) {
      throw NotConnectedException();
    }
    String netIp = wifiIP.substring(0, wifiIP.length - 2);
    return (await NetworkAnalyzer.discoverByPortAndSubnetFuture(subnet: netIp, port: 9100, timeout: const Duration(milliseconds: 500)))
        .map((address) => TcpPrinter(host: address.address, port: 9100, hostname: address.host))
        .toList();
  }
}

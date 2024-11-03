import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager/src/models/printer_connector.dart';
import 'package:flutter_printer_manager/src/models/printer_models.dart';

class TcpPrinterConnector implements PrinterConnector<TcpPrinterModel> {
  @override
  bool isConnected = false;
  TcpPrinterModel? printer;
  Socket? _socket;
  StreamController<bool> isConnectedStream = StreamController<bool>();

  static final TcpPrinterConnector _instance = TcpPrinterConnector._internal();

  factory TcpPrinterConnector() {
    return _instance;
  }

  TcpPrinterConnector._internal() {
    isConnectedStream.add(false);
  }

  @override
  Future<bool> connect(model) async {
    if(_socket != null) {
      _socket?.destroy();
    }
    try {
      var socket = await Socket.connect(model.host, model.port, timeout: const Duration(milliseconds: 500)).then((socket) {
        return socket;
      });
    
      
      printer = model;
      _socket = socket;
      _socket?.handleError((data) {
        print(data);
      });

      _socket?.drain().then((_) {
        disconnect();
      });
      isConnected = true;
      isConnectedStream.add(true);
      return true;
    } catch (e) {
      disconnect();
      return false;
    }
  }

  @override
  Future<bool> disconnect() async {
    isConnected = false;
    isConnectedStream.add(false);
    _socket?.destroy();
    _socket = null;
    return true;
  }

  @override
  Future<bool> send(List<int> bytes) async {
    if (printer == null) {
      throw Exception("No Printer");
    }
    if(printer != null && (_socket == null || isConnected == false)) {
      await connect(printer!);
    }
    
     _socket?.add(Uint8List.fromList(bytes));
     _socket?.flush();
    
    //  _socket?.destroy();
    // _socket = null;

    return true;
  }
}

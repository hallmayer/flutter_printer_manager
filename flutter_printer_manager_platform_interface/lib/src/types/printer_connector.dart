import 'dart:async';

import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

abstract class PrinterConnector<T> {

  bool isConnected = false;
  StreamController<PrinterState> isConnectedStream = StreamController<PrinterState>.broadcast();


  Future<bool> send(List<int> bytes); 
  Future<bool> connect(T model); 
  Future<bool> disconnect();
  Future<List<T>> discovery();
}


import 'package:flutter_printer_manager_platform_interface/src/types/printer_connector.dart';

class TCPPrinterConnector implements PrinterConnector {
  @override
  Future<bool> connect(model) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<bool> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<bool> send(List<int> bytes) {
    // TODO: implement send
    throw UnimplementedError();
  }

}
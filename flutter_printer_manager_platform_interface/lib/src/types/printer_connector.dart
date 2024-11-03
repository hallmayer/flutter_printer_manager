import 'dart:async';

abstract class PrinterConnector<T> {

  bool isConnected = false;
  StreamController<bool> isConnectedStream = StreamController<bool>();


  Future<bool> send(List<int> bytes); 
  Future<bool> connect(T model); 
  Future<bool> disconnect();
  Future<List<T>> discovery();
}
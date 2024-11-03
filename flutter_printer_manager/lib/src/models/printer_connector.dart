abstract class PrinterConnector<T> {

  abstract bool isConnected;

  Future<bool> send(List<int> bytes); 
  Future<bool> connect(T model); 
  Future<bool> disconnect();
}
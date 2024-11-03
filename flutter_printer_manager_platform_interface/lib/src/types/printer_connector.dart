abstract class PrinterConnector<T> {
  Future<bool> send(List<int> bytes); 
  Future<bool> connect(T model); 
  Future<bool> disconnect();
}

abstract class PrinterModel {
    bool isConnected; 

    PrinterModel({this.isConnected = false}) ;
}



class TcpPrinterModel extends PrinterModel {
  String host;
  int port; 
  String hostname;
 
  TcpPrinterModel({super.isConnected, required this.host, required this.port, required this.hostname});

}
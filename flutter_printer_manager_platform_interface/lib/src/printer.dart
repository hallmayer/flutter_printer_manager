

enum PrinterState {
  none, 
  connected,
  disconnected
}


class PrinterManagerException{
  final String errorMessage; 
  PrinterManagerException(this.errorMessage);
}




abstract class PrinterModel {
    bool isConnected; 

    PrinterModel({this.isConnected = false}) ;
}



class TcpPrinter extends PrinterModel {
  String host;
  int port; 
  String hostname;
 
  TcpPrinter({super.isConnected, required this.host, required this.port, required this.hostname});

}

class USBPrinter extends PrinterModel  {
  final int productId; 
  final int vendorId; 
  final String? manufacturerName; 
  final String? productName; 
  USBPrinter({super.isConnected,required this.vendorId, required this.productId, this.manufacturerName, this.productName});
}



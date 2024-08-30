class USBPrinter  {
  final int productId; 
  final int vendorId; 
  final String? manufacturerName; 
  final String? productName; 
  USBPrinter({required this.vendorId, required this.productId, this.manufacturerName, this.productName});
}


class PrinterManagerException{
  final String errorMessage; 
  PrinterManagerException(this.errorMessage);
}


enum USBPrinterState {
  none,
  connected,
  disconnected
}
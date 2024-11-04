import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/flutter_printer_manager_api.g.dart',
  kotlinOut: 'android/src/main/kotlin/de/diformatics/flutter_printer_manager_android/FlutterPrinterManagerApi.kt',
  kotlinOptions: KotlinOptions(package: "de.diformatics.flutter_printer_manager_android")
))

class USBPrinter {
  final int productId; 
  final int vendorId; 
  final String? manufacturerName; 
  final String? productName; 
  USBPrinter({required this.vendorId, required this.productId, this.manufacturerName, this.productName});
}

enum USBPrinterState {
  none, 
  connected,
  disconnected
}



@HostApi()
abstract class FlutterPrinterManagerApi {
  List<USBPrinter> getPrinters();

  bool selectUSBDevice(int vendorId, int productId);

  bool openUSBConnection(int? vendorId, int? productId); 
  bool hasUSBPermissions(int vendorId, int productId);
  bool closeUSBConnection(); 

  USBPrinterState getCurrentPrinterState();


  bool printBytes(List<int> bytes);

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager_example/src/logger.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class UsbPrinterTab extends StatefulWidget {
  const UsbPrinterTab({super.key});

  @override
  State<UsbPrinterTab> createState() => _UsbPrinterTabState();
}

class _UsbPrinterTabState extends State<UsbPrinterTab> {
  List<USBPrinter> printers = [];


  PrinterModel? selectedPrinter;

  @override
  void initState() {
    super.initState();
    FlutterPrinterController.instance.usbPrinterConnector.isConnectedStream.stream.listen((data) {
      logger.d("Retrieved printer status $data");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              List<USBPrinter> devices =
                  await FlutterPrinterController.instance.discovery(printerType: PrinterType.usb) as List<USBPrinter>;
              setState(() {
                printers = devices;
              });
            },
            child: const Text("Scan for USB Devices"), 
          ),
          DropdownButton(
            autofocus: false,
             value: selectedPrinter,
              items: printers.map((printer) => DropdownMenuItem(child: Text(printer.productName ?? ""), value: printer,)).toList(),
              onChanged: (printer) async {
                if(printer != null) {
                  
                selectedPrinter = printer;
                var hasPermissions = await FlutterPrinterController.instance.usbPrinterConnector.hasPermissionsForDevice(printer as USBPrinter); 
                logger.d("Has Permission for device: $hasPermissions");
                
                }
              })
        ],
      );
    }

    return const Center(child: Text("Platform not supported"));
  }
}

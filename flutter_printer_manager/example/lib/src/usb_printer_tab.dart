import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager_example/src/consts.dart';
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

  PrinterState state = PrinterState.none;

  @override
  void initState() {
    super.initState();
    FlutterPrinterController.instance.usbPrinterConnector.isConnectedStream.stream.listen((data) {
      logger.d("Retrieved printer status $data");
      setState(() {
        state = data;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Column(
        children: [
          PrinterStateIndicator(printerState: state),
          const SizedBox(height: 10,),

          PrinterStateStreamIndicator(stream: FlutterPrinterController.instance.usbPrinterConnector.isConnectedStream.stream,),
          const SizedBox(height: 10,),

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
                  
                setState(() {
                  selectedPrinter = printer;
                });
                var hasPermissions = await FlutterPrinterController.instance.usbPrinterConnector.hasPermissionsForDevice(printer as USBPrinter);                 
                logger.d("Has Permission for device: $hasPermissions");
                var result = await FlutterPrinterController.instance.usbPrinterConnector.selectDevice(printer);
                logger.d("Connected with result $result");
                
                }
              }),

          ElevatedButton(onPressed: () async{
            var result = await FlutterPrinterController.instance.connect(printer: selectedPrinter!, printerType: PrinterType.usb);
          }, child: Text("Connect")),
          ElevatedButton(onPressed: () async{
            var bytes = await Helper.testTicket();
            var result = await FlutterPrinterController.instance.send(printer: selectedPrinter!, bytes:bytes);
            logger.d("Printed with result $result");
          }, child: Text("Print"))
        ],
      );
    }

    return const Center(child: Text("Platform not supported"));
  }
}

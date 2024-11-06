import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager_example/src/consts.dart';
import 'package:flutter_printer_manager_example/src/logger.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class TCPPrinterTab extends StatefulWidget {
  const TCPPrinterTab({super.key});

  @override
  State<TCPPrinterTab> createState() => _TCPPrinterTabState();
}

class _TCPPrinterTabState extends State<TCPPrinterTab> {
  List<TcpPrinter> printers = [];

  PrinterModel? selectedPrinter;

  PrinterState state = PrinterState.none;

  @override
  void initState() {
    super.initState();
    FlutterPrinterController.instance.tcpPrinterConnector.isConnectedStream.stream.listen((data) {
      logger.d("Retrieved printer status $data");
      setState(() {
        state = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrinterStateIndicator(printerState: state),
        const SizedBox(
          height: 10,
        ),
        PrinterStateStreamIndicator(
          stream: FlutterPrinterController.instance.tcpPrinterConnector.isConnectedStream.stream,
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            List<TcpPrinter> devices = await FlutterPrinterController.instance.discovery(printerType: PrinterType.network) as List<TcpPrinter>;
            setState(() {
              printers = devices;
            });
          },
          child: const Text("Scan for TCP Devices"),
        ),
        DropdownButton(
            autofocus: false,
            value: selectedPrinter,
            items: printers
                .map((printer) => DropdownMenuItem(
                      child: Text(printer.hostname ?? ""),
                      value: printer,
                    ))
                .toList(),
            onChanged: (printer) async {
              if (printer != null) {
                setState(() {
                  selectedPrinter = printer;
                });
              }
            }),
        ElevatedButton(
            onPressed: () async {
              var result = await FlutterPrinterController.instance.connect(printer: selectedPrinter!, printerType: PrinterType.network);
            },
            child: Text("Connect")),
        ElevatedButton(
            onPressed: () async {
              var bytes = await Helper.testTicket();
              var result = await FlutterPrinterController.instance.send(printer: selectedPrinter!, bytes: bytes);
              logger.d("Printed with result $result");
            },
            child: Text("Print"))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_printer_manager_android/flutter_printer_manager_android.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<USBPrinter> printers = [];
  USBPrinter? _selectedPrinter;

  @override
  void initState() {
    super.initState();
    initPrinters();

    var eventChannel = USBStatusEventChannel.eventChannel.receiveBroadcastStream(); 
    eventChannel.listen((event){
    
    });
  }

  

  Future<void> initPrinters() async {
     final printers = await FlutterPrinterManagerAndroid().getUSBDevices(); 
     if(printers.isNotEmpty) {
        setState(() {
          this.printers = printers;
        });
     }

  } 

  Future<bool> selectPrinter(USBPrinter printer) async {
    var res = await FlutterPrinterManagerAndroid().selectUSBDevice(printer.vendorId, printer.productId); 
    if(res) {
      setState(() {
        _selectedPrinter = printer;
      });
    }
  return res;
  }

  Future<bool> conntectToPrinter() async {
    var res = await FlutterPrinterManagerAndroid().openUSBConnection(_selectedPrinter!.vendorId, _selectedPrinter!.productId);
    return res;
  }

  Future<List<int>> testTicket() async {
  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];

  bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ'); 

  bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
  bytes += generator.text('Reverse text', styles: const PosStyles(reverse: true));
  bytes += generator.text('Underlined text',
      styles: const PosStyles(underline: true), linesAfter: 1);
  bytes += generator.text('Align left', styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('Align center', styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Align right',
      styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

  bytes += generator.text('Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("dasdsa"),
              if(printers.isNotEmpty) ...[
                 DropdownButton(items: printers.map((printer) => DropdownMenuItem(value: printer,child: Text(printer.productName ?? ""),)).toList(), onChanged: (printer) async {
                  if(printer == null) return;
                  await selectPrinter(printer);
                 
                 }, value: _selectedPrinter,)
              ],

             
                 ElevatedButton(child: const Text("Connect"), onPressed: () => conntectToPrinter(),),

                 ElevatedButton(onPressed: () async {
                    var ticket = await testTicket(); 
                    await FlutterPrinterManagerAndroid().printBytes(ticket);
                   
                 }, child: const Text("Sent"))
              

              
             
            
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
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
  String _platformVersion = 'Unknown';

  List<USBPrinter> printers = [];
  USBPrinter? _selectedPrinter;

  @override
  void initState() {
    super.initState();
    initPrinters();

    // var eventChannel = USBStatusEventChannel.eventChannel.receiveBroadcastStream(); 
    // eventChannel.listen((event){
    //   print(event);
    // });
  }

  

  Future<void> initPrinters() async {
     final printers = await FlutterPrinterController.discoverUSBPrinters(); 
     print(printers.length);
     if(printers.isNotEmpty) {
        setState(() {
          this.printers = printers;
        });
     }

  } 

  // Future<bool> selectPrinter(USBPrinter printer) async {
  //   var res = await FlutterPrinterManagerAndroid().selectUSBDevice(printer.vendorId, printer.productId); 
  //   if(res) {
  //     setState(() {
  //       _selectedPrinter = printer;
  //     });
  //   }
  // return res;
  // }

  // Future<bool> conntectToPrinter() async {
  //   var res = await FlutterPrinterManagerAndroid().openUSBConnection(_selectedPrinter!.vendorId, _selectedPrinter!.productId);
  //   return res;
  // }

//   Future<List<int>> testTicket() async {
//   // Using default profile
//   final profile = await CapabilityProfile.load();
//   final generator = Generator(PaperSize.mm80, profile);
//   List<int> bytes = [];

//   bytes += generator.text(
//       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ'); 

//   bytes += generator.text('Bold text', styles: PosStyles(bold: true));
//   bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
//   bytes += generator.text('Underlined text',
//       styles: PosStyles(underline: true), linesAfter: 1);
//   bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
//   bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
//   bytes += generator.text('Align right',
//       styles: PosStyles(align: PosAlign.right), linesAfter: 1);

//   bytes += generator.text('Text size 200%',
//       styles: PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ));

//   bytes += generator.feed(2);
//   bytes += generator.cut();
//   return bytes;
// }

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
              Text("dasdsa"),
              if(printers.isNotEmpty) ...[
                 DropdownButton(items: printers.map((printer) => DropdownMenuItem(child: Text(printer.productName ?? ""), value: printer,)).toList(), onChanged: (printer) async {
                  if(printer == null) return;
                 // var res = await selectPrinter(printer);
                //  print(res);
                 }, value: _selectedPrinter,)
              ],

             
                //  ElevatedButton(child: Text("Connect"), onPressed: () => conntectToPrinter(),),

                //  ElevatedButton(onPressed: () async {
                //     var ticket = await testTicket(); 
                //     var res = await FlutterPrinterManager().printBytes(ticket);
                //     print(res);
                //  }, child: Text("Sent"))
              

              
             
            
            ],
          ),
        ),
      ),
    );
  }
}

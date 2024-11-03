import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_printer_manager/flutter_printer_manager.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';
import 'package:yjy_fiscal_printer/common/epson_model.dart';
import 'package:yjy_fiscal_printer/fiscal_printer.dart';


void main() async {
      WidgetsFlutterBinding.ensureInitialized();
  
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

  bool isConnected = false; 

  @override
  void initState() {
    super.initState();
    TcpPrinterConnector().isConnectedStream.stream.listen((data) {
      setState(() {
        isConnected = data;
      });
    });
   // initPrinters();

    // var eventChannel = USBStatusEventChannel.eventChannel.receiveBroadcastStream(); 
    // eventChannel.listen((event){
    //   print(event);
    // });
  }

  

  // Future<void> initPrinters() async {
  //    final printers = await FlutterPrinterController.discoverUSBPrinters(); 
  //    print(printers.length);
  //    if(printers.isNotEmpty) {
  //       setState(() {
  //         this.printers = printers;
  //       });
  //    }

  // } 

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
              if(printers.isNotEmpty) ...[
                 DropdownButton(items: printers.map((printer) => DropdownMenuItem(value: printer,child: Text(printer.productName ?? ""),)).toList(), onChanged: (printer) async {
                  if(printer == null) return;
                 // var res = await selectPrinter(printer);
                //  print(res);
                 }, value: _selectedPrinter,)
              ],
               ElevatedButton(onPressed: ()  async {
                //  final printers = await FlutterPrinterController().discovery(printerType: printerType);
                //  final printer = printers[0]; 
                //  var connector = await TcpPrinterConnector().connect(printer);
                //   // if(connector) {
                  //   var ticket = await this.testTicket();
                  //   TcpPrinterConnector().send(ticket);
                  // }
              }, child: const Text("Scan network printer2")),

               ElevatedButton(onPressed: ()  async {
             
                    var ticket = await testTicket();
                    TcpPrinterConnector().send(ticket);
                 
              }, child: const Text("Send network printer2")),

              Text(isConnected.toString()),
              ElevatedButton(onPressed: () => TcpPrinterConnector().disconnect(), child: const Text("Disconenct")),
              ElevatedButton(onPressed:() async {
                final fprinter = EpsonXmlHttpClient(Config(
                      host: '192.168.2.113',
                      deviceId: 'local_printer',
                      timeout: 10000
                  ));

                  // Fiscal receipt
                  await fprinter.printFiscalReceipt(Receipt(
                      sales: [
                          Sale(
                              type: ItemType.HOLD,
                              description: 'A',
                              quantity: 1,
                              unitPrice: 5
                              ),
                          Sale( 
                              type: ItemType.HOLD,
                              description: 'B',
                              quantity: 2,
                              unitPrice: 2.5
                              ),
                          Sale(
                              type: ItemType.HOLD,
                              description: 'C',
                              quantity: 3,
                              unitPrice: 3
                          ),
                      ],
                      payments: [

                        
                        Payment(
                              description: 'Payment in cash',
                              payment: 19
                        )
                      ]
                  ));

                  // Fiscal Report
                  // await fprinter.printFiscalReport(Report(
                  //     type: Fiscal.ReportType.DAILY_FISCAL_CLOUSE,
                  // ));
              }, child: const Text("dadsad"))

             
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

  Future<List<int>> testTicket() async {
  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];

  bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');


  // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  // bytes += generator.text('Underlined text',
  //     styles: PosStyles(underline: true), linesAfter: 1);
  // bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  // bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
  // bytes += generator.text('Align right',
  //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  // bytes += generator.text('Text size 200%',
  //     styles: PosStyles(
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //     ));

  bytes += generator.feed(2);
  bytes += generator.cut();
  bytes +=generator.beep();
  bytes +=generator.drawer();
  return bytes;
}


  
}

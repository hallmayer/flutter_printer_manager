import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_printer_manager_example/src/usb_printer_tab.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "USB",),
                Tab(text: "TCP"),
              ],
            ),
          ),
          body: const TabBarView(
          children: [
            UsbPrinterTab(),
            Icon(Icons.directions_transit),
          ],
          )
        ),
      ),
    );
  }

  Future<List<int>> testTicket() async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');

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
    bytes += generator.beep();
    bytes += generator.drawer();
    return bytes;
  }
}

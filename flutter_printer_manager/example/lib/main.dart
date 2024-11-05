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

  
}

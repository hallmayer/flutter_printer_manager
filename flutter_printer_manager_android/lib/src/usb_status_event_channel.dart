import 'package:flutter/services.dart';

class USBStatusEventChannel {
  static const EventChannel eventChannel = EventChannel("de.diformatics.flutter_printer_manager/usbstatus");

  void listenToNativeEvents() {
    eventChannel.receiveBroadcastStream().listen((event) {
      print('Received event from platform: $event');
    }, onError: (error) {
      print('Received error: ${error.message}');
    });
  }
}
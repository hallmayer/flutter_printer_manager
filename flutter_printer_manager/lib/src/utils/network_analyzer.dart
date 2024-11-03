import 'dart:async';
import 'dart:io';

import 'package:flutter_printer_manager/src/utils/logger.dart';
class NetworkAnalyzer {
  static Future<Socket> getPortFromPing(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static Future<bool> checkConnectionToIpOnPort(
      {required String host, required int port, Duration timeout = const Duration(seconds: 1)}) async {
        try {
           var stream = Socket.connect(host ,port, timeout: timeout).then((socket) {
      return socket;
    });
    var result = await stream;
    return true;
        } catch(e) {
          return false;
        }
   
  }

  static Stream<InternetAddress> discoverByPortAndSubnet(
    String subnet,
    int port, {
    required Duration timeout,
  }) {
    if (port < 1 || port > 65535) {
      throw 'Provide a valid port range between 0 to 65535';
    }
    final out = StreamController<InternetAddress>();
    final futures = <Future<Socket>>[];

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> socket = getPortFromPing(host, port, timeout);
      futures.add(socket);

      socket.then((Socket s) async {
        var address = await s.address.reverse();
        s.destroy();

        out.sink.add(address);
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }
      });
    }

    Future.wait<Socket>(futures).then<void>((sockets) => out.close()).catchError((dynamic e) => out.close());
    return out.stream;
  }

  static Future<List<InternetAddress>> discoverByPortAndSubnetFuture(
      {required String subnet, required int port, required Duration timeout}) async {
    List<InternetAddress> succesfullIps = [];
    var stream = NetworkAnalyzer.discoverByPortAndSubnet(subnet, port, timeout: const Duration(milliseconds: 500));
    await for (var address in stream) {
      succesfullIps.add(address);
      logger.i("Found printer with ip: ${address.address}");
    }
    logger.i("Found ${succesfullIps.length} Hosts");
    return succesfullIps;
  }
}

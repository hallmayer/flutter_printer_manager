import 'package:flutter/material.dart';
import 'package:flutter_printer_manager_platform_interface/flutter_printer_manager_platform_interface.dart';

class PrinterStateIndicator extends StatelessWidget {

  final PrinterState printerState;
  final Color connectedColor; 
  final Color disconnectedColor; 
  final Color? idleColor;
  final double radius;


  const PrinterStateIndicator({super.key, required this.printerState,  this.connectedColor = Colors.green, this.disconnectedColor = Colors.red,this.radius = 10, this.idleColor});

  Color _getColorBaseOnStats({required PrinterState state,  Color connectedColor = Colors.green, Color disconnectedColor = Colors.red, Color? idleColor}) {
    switch(state) {
      case PrinterState.connected: 
        return connectedColor;
      case PrinterState.disconnected:
        return disconnectedColor; 
      default: 
        return idleColor ?? Colors.grey; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return idleColor == null && printerState == PrinterState.none ? const SizedBox() : CircleAvatar(backgroundColor:  _getColorBaseOnStats(state: printerState), radius: radius,);
  }


  
}


class PrinterStateStreamIndicator extends StatefulWidget {

  final Stream<PrinterState> stream;
  final Color connectedColor; 
  final Color disconnectedColor; 
  final Color? idleColor;
  final double radius;

  const PrinterStateStreamIndicator({super.key, required this.stream, this.connectedColor = Colors.green, this.disconnectedColor = Colors.red,this.radius = 10, this.idleColor});

  @override
  State<PrinterStateStreamIndicator> createState() => _PrinterStateStreamIndicatorState();
}

class _PrinterStateStreamIndicatorState extends State<PrinterStateStreamIndicator> {



  PrinterState printerState = PrinterState.none;

  @override
  void initState() {
    widget.stream.listen((state) {
      setState(() {
        printerState = state;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PrinterStateIndicator(printerState: printerState, connectedColor: widget.connectedColor, disconnectedColor: widget.disconnectedColor, idleColor: widget.idleColor, radius: widget.radius,);
  }
}
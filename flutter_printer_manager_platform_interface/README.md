<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A common platform interface for the [`flutter_printer_manager`][1] plugin.
This interface allows platform-specific implementations of the `flutter_printer_manager`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.


## Usage

To implement a new platform-specific implementation of `flutter_printer_manager`, extend
[`FlutterPrinterManagerPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`FlutterPrinterManagerPlatform` by calling
`FlutterPrinterManagerPlatform.instance = MyFlutterPrinterManagerPlatform()`.

## Additional information

This is my first package and the first try with this kind of package implementation. 

[1]: ../
[2]: lib/src/flutter_printer_manager_platform.dart

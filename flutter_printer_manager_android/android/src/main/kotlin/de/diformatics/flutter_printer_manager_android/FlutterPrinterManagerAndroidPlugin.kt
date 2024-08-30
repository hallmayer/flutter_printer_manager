package de.diformatics.flutter_printer_manager_android

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


/** FlutterPrinterManagerAndroidPlugin */
class FlutterPrinterManagerAndroidPlugin: FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  val TAG: String = "FlutterPrinterManagerPlugin"

  private var flutterPrinterManager: FlutterPrinterManager? = null



  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterPrinterManager = FlutterPrinterManager(flutterPluginBinding);
    flutterPrinterManager?.init(flutterPluginBinding.applicationContext)
    FlutterPrinterManagerApi.setUp(flutterPluginBinding.binaryMessenger, flutterPrinterManager)

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
     if(flutterPrinterManager == null) {
       Log.wtf(TAG, "Already detached from Engine");
       return;
     }
    FlutterPrinterManagerApi.setUp(binding.binaryMessenger, null);
    flutterPrinterManager = null;
  }

}

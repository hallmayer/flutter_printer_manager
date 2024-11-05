package de.diformatics.flutter_printer_manager_android

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.os.Message
import androidx.annotation.VisibleForTesting
import de.diformatics.flutter_printer_manager_android.usb.UsbPrinterService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel


class FlutterPrinterManager constructor(binding: FlutterPlugin.FlutterPluginBinding) : FlutterPrinterManagerApi {


    private val usbHandler =
        object : Handler(Looper.getMainLooper()) {

            override fun handleMessage(msg: Message) {
                super.handleMessage(msg)
                when (msg.what) {
                    USBPrinterState.CONNECTED.raw -> {
                        eventUSBSink?.success(2)
                    }
                    USBPrinterState.NONE.raw -> {
                        eventUSBSink?.success(0)
                    }
                }
            }
        }

    private var printerService: UsbPrinterService = UsbPrinterService(binding.applicationContext, usbHandler);
    var eventUSBSink: EventChannel.EventSink? = null;


    private var eventChannel = EventChannel(binding.binaryMessenger, PluginConstants.USB_EVENT_CHANNEL).setStreamHandler(
        object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventUSBSink = events;
            }

            override fun onCancel(arguments: Any?) {
                eventUSBSink = null;
            }

        }
    );


    @VisibleForTesting
    constructor(binding: FlutterPlugin.FlutterPluginBinding, intentResolver: IntentResolver) : this(binding) {
        this.intentResolver = intentResolver
    }

    lateinit var intentResolver: IntentResolver



    @VisibleForTesting
    interface IntentResolver {
        fun getHandlerComponentName(intent: Intent): String?
    }

    val TAG: String = "FlutterPrinterManager"

    private var activity: Activity? = null


    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    fun init(context: Context) {
        printerService.init(context);
    }


    override fun getPrinters(): List<USBPrinter> {
        val retList: List<USBPrinter> = printerService.getPrinters();
        return retList;
    }

    override fun selectUSBDevice(vendorId: Long, productId: Long): Boolean {
       return printerService.selectDevice(vendorId = vendorId.toInt(), productId = productId.toInt());
    }

    override fun openUSBConnection(vendorId: Long?, productId: Long?): Boolean {
        return printerService.openUSBConnection(vendorId?.toInt(), productId?.toInt(), false);
    }

    override fun hasUSBPermissions(
        vendorId: Long,
        productId: Long,
        requestPermissions: Boolean
    ): Boolean {
        return printerService.hasUSBPermissions(vendorId.toInt(), productId.toInt(), requestPermissions);
    }


    override fun closeUSBConnection(): Boolean {
        return printerService.closeUSBConnection();
    }

    override fun getCurrentPrinterState(): USBPrinterState {
        return printerService.state;
    }

    override fun printBytes(bytes: List<Long>): Boolean {
       return printerService.printBytes(bytes)
    }
}
package de.diformatics.flutter_printer_manager_android.usb

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_NOT_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbInterface
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Handler
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import de.diformatics.flutter_printer_manager_android.PluginConstants
import de.diformatics.flutter_printer_manager_android.PrinterService
import de.diformatics.flutter_printer_manager_android.USBPrinter
import de.diformatics.flutter_printer_manager_android.USBPrinterState
import java.util.Arrays
import java.util.Vector

class UsbPrinterService(context: Context, handler: Handler) : PrinterService {

    private var messageHandler: Handler = handler;

    private var usbManager: UsbManager? = context.getSystemService(Context.USB_SERVICE) as UsbManager;


    private var permissionIntent: PendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        PendingIntent.getBroadcast(context, 0, Intent(PluginConstants.ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE)
    } else {
        PendingIntent.getBroadcast(context, 0, Intent(PluginConstants.ACTION_USB_PERMISSION), 0)
    };


    var state: USBPrinterState = USBPrinterState.NONE;



    private val applicationContext = context;

    private var selectedUSBDevice: UsbDevice? = null;
    private var selectedUsbEndpoint: UsbEndpoint? = null;
    private var selectedUsbDeviceConnection: UsbDeviceConnection? = null;
    private var selectedUsbInterface: UsbInterface? = null;

    private val usbListener = object : USBListener {
        override fun usbDeviceDetached() {

            Log.e(LOG_TAG, "USB Device deteached")
            if (selectedUSBDevice != null) {
                Toast.makeText(context, "Selected USB Device detached", Toast.LENGTH_LONG).show()
                closeUSBConnection()
                state = USBPrinterState.NONE
                messageHandler.obtainMessage(state.raw).sendToTarget();
            }
        }

        override fun usbDeviceAttached(usbDevice: UsbDevice?) {
            (usbDevice)?.let {
                Log.e(LOG_TAG, "USB Device attached")



            }
        }

        override fun usbPermission(usbDevice: UsbDevice?, intent: Intent) {
            (usbDevice)?.let {
                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                    Log.i(
                        LOG_TAG,
                        "Success get permission for device ${usbDevice?.deviceId}, vendor_id: ${usbDevice?.vendorId} product_id: ${usbDevice?.productId}"
                    )
                    selectedUSBDevice = usbDevice
                    state = USBPrinterState.CONNECTED
                   // mHandler?.obtainMessage(STATE_USB_CONNECTED)?.sendToTarget()
                } else {
                    Toast.makeText(context, "Refuse Permission for" + ": ${usbDevice!!.deviceName}", Toast.LENGTH_LONG).show()
                    state = USBPrinterState.NONE
                   // mHandler?.obtainMessage(STATE_USB_NONE)?.sendToTarget()
                }
            }
        }
    }


    private val LOG_TAG = "FlutterPrinterManager"



//    private val usbDeviceReciever: BroadcastReceiver = object : BroadcastReceiver() {
//        override fun onReceive(context: Context, intent: Intent) {
//            val action = intent.action
//            if ((ACTION_USB_PERMISSION == action)) {
//                synchronized(this) {
//                    val usbDevice: UsbDevice? = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE)
//                    if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
//                        Log.i(
//                            LOG_TAG,
//                            "Success get permission for device ${usbDevice?.deviceId}, vendor_id: ${usbDevice?.vendorId} product_id: ${usbDevice?.productId}"
//                        )
//                        selectedUSBDevice = usbDevice
//                    } else {
//                        Toast.makeText(context, "Refused Permsision", Toast.LENGTH_LONG).show()
//
//                    }
//                }
//            } else if ((UsbManager.ACTION_USB_DEVICE_DETACHED == action)) {
//
//                if (selectedUSBDevice != null) {
//                    Toast.makeText(context, "USB Gerät getrennt", Toast.LENGTH_LONG).show()
//                    closeUSBConnection();
//                }
//
//            } else if ((UsbManager.ACTION_USB_DEVICE_ATTACHED == action)) {
////                if (mUsbDevice != null) {
////                    Toast.makeText(context, "USB device has been turned off", Toast.LENGTH_LONG).show()
////                    closeConnectionIfExists()
////                }
//            }
//        }
//    }


//    fun init() {
//        val filter = IntentFilter(ACTION_USB_PERMISSION)
//        filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
//        applicationContext.registerReceiver(usbDeviceReciever, filter)
//        Log.v(LOG_TAG, "ESC/POS Initialized")
//
//    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun init(context:Context) {
        Log.e(LOG_TAG, "Init Funktikon")
        val filter = IntentFilter(PluginConstants.ACTION_USB_PERMISSION)
        filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
        filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED)
        context.registerReceiver(UsbDevicesReceiver(usbListener), filter, RECEIVER_NOT_EXPORTED)

    }




    override fun getPrinters(): List<USBPrinter> {
        if(usbManager == null) return emptyList();
        val printerList: MutableList<USBPrinter> = mutableListOf()
        usbManager!!.deviceList.forEach{
            printerList.add(USBPrinter(productId = it.value.productId.toLong(), vendorId = it.value.vendorId.toLong(), manufacturerName = it.value.manufacturerName, productName = it.value.productName));
        }
        return printerList

    }

    override fun selectDevice(vendorId: Int, productId: Int): Boolean {

            for(usbDevice: UsbDevice in usbManager!!.deviceList.values) {
                if((usbDevice.vendorId == vendorId && usbDevice.productId == productId)) {
                    selectedUSBDevice = usbDevice;
                    val hasAlreadyPermission = usbManager!!.hasPermission(selectedUSBDevice)
                    if(!hasAlreadyPermission) {
                        usbManager!!.requestPermission(selectedUSBDevice, this.permissionIntent);
                    }

                }
            }

        return true;
    }

    override fun openUSBConnection(vendorId: Int?, productId: Int?, force: Boolean ): Boolean {
        if(usbManager == null) return false;
        if(vendorId != null && productId != null) {
            if(selectedUSBDevice?.vendorId != vendorId || selectedUSBDevice?.productId != productId) {
                val result = selectDevice(vendorId, productId);
                if(!result) {
                    Log.e(LOG_TAG, "Could not init USB Device");
                    return false;
                }
                return openUSBConnection(null, null);
            }
        }

        if(selectedUsbDeviceConnection != null && !force) {
            Log.i(LOG_TAG, "USB Connection already connected");
            return true;
        }


        if(selectedUSBDevice == null) {
            Toast.makeText(applicationContext, "Kein USB Device ausgewählt", Toast.LENGTH_LONG).show();
            return true;
        }
        // TODO Checks
        val usbInterface = selectedUSBDevice!!.getInterface(0);
        for (i in 0 until usbInterface.endpointCount) {
            val ep = usbInterface.getEndpoint(i)
            if (ep.direction == UsbConstants.USB_DIR_OUT) {
                val usbDeviceConnection = usbManager!!.openDevice(selectedUSBDevice)
                if(usbDeviceConnection == null) {
                    Log.e(LOG_TAG, "Failed to open USB Connection")
                    return false
                }
                Toast.makeText(applicationContext, "USB Verbindung erfolgreich", Toast.LENGTH_SHORT).show()
                return if (usbDeviceConnection.claimInterface(usbInterface, true)) {
                    selectedUsbEndpoint = ep
                    selectedUsbInterface = usbInterface
                    selectedUsbDeviceConnection = usbDeviceConnection
                    state = USBPrinterState.CONNECTED


                    true
                } else {
                    usbDeviceConnection.close()
                    Log.e(LOG_TAG, "Failed to retrieve usb connection")
                    state = USBPrinterState.DISCONNECTED
                    false
                }
            }
        }
        return false;
    }

    override fun closeUSBConnection(): Boolean {
        if (selectedUsbDeviceConnection != null) {
            selectedUsbDeviceConnection!!.releaseInterface(selectedUsbInterface)
            selectedUsbDeviceConnection!!.close()
            selectedUsbInterface = null
            selectedUsbEndpoint = null
          //  selectedUSBDevice = null
            selectedUsbDeviceConnection = null
            state = USBPrinterState.NONE
        }
        return true;
    }

    override fun printBytes(bytes: List<Long>): Boolean {
        Log.v(LOG_TAG, "Printing bytes")
        val isConnected = openUSBConnection(null, null, false);
        if(isConnected) {
            try {
                val chunkSize = selectedUsbEndpoint!!.maxPacketSize
                Log.v(LOG_TAG, "Max Packet Size: $chunkSize")
                Log.v(LOG_TAG, "Connected to device")
                val vectorData: Vector<Byte> = Vector()
                for (i in bytes.indices) {
                    val `val`: Long = bytes[i]
                    vectorData.add(`val`.toByte())
                }
                val temp: Array<Any> = vectorData.toTypedArray()
                val byteData = ByteArray(temp.size)
                for (i in temp.indices) {
                    byteData[i] = temp[i] as Byte
                }
                var b = 0
                if (selectedUsbDeviceConnection != null) {
                    if (byteData.size > chunkSize) {
                        var chunks: Int = byteData.size / chunkSize
                        if (byteData.size % chunkSize > 0) {
                            ++chunks
                        }
                        for (i in 0 until chunks) {
//                                val buffer: ByteArray = byteData.copyOfRange(i * chunkSize, chunkSize + i * chunkSize)
                            val buffer: ByteArray = Arrays.copyOfRange(byteData, i * chunkSize, chunkSize + i * chunkSize)
                            b = selectedUsbDeviceConnection!!.bulkTransfer(selectedUsbEndpoint, buffer, chunkSize, 100000)
                        }
                    } else {
                        b = selectedUsbDeviceConnection!!.bulkTransfer(selectedUsbEndpoint, byteData, byteData.size, 100000)
                    }
                    if(b == -1) {
                        //openUSBConnection(null, null, true);
                        return false;
                    }
                    Log.i(LOG_TAG, "Return code: $b")

                 }
                return true;

            } catch (e: Exception) {

                return false;
            }
        }
        return false;



    }





}
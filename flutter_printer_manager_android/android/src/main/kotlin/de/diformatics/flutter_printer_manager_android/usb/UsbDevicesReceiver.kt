package de.diformatics.flutter_printer_manager_android.usb

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Parcelable
import android.util.Log
import de.diformatics.flutter_printer_manager_android.PluginConstants


class UsbDevicesReceiver (val usbListener: USBListener) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (UsbManager.ACTION_USB_DEVICE_DETACHED == action) {
            usbListener.usbDeviceDetached()
        }
        if (UsbManager.ACTION_USB_DEVICE_ATTACHED == action) {
            val usbDevice =
                intent.getParcelableExtra<Parcelable>(UsbManager.EXTRA_DEVICE) as UsbDevice?

            val test = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false);
            usbListener.usbDeviceAttached(usbDevice)
        }
        if(PluginConstants.ACTION_USB_PERMISSION == action) {
            val usbDevice =
                intent.getParcelableExtra<Parcelable>(UsbManager.EXTRA_DEVICE) as UsbDevice?
           usbListener.usbPermission(usbDevice, intent);
        }
    }
}

interface USBListener {
    fun usbDeviceDetached()
    fun usbDeviceAttached(usbDevice: UsbDevice?)
    fun usbPermission(usbDevice: UsbDevice?, intent: Intent)
}
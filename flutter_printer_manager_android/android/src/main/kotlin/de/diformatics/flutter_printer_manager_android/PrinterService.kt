package de.diformatics.flutter_printer_manager_android

interface PrinterService {
    fun getPrinters(): List<USBPrinter>

    fun selectDevice(vendorId: Int, productId: Int): Boolean


    fun openUSBConnection(vendorId: Int?, productId: Int?, force: Boolean = false): Boolean

    fun closeUSBConnection(): Boolean

    fun printBytes(bytes: List<Long>): Boolean;


    fun hasUSBPermissions(vendorId: Int, productId: Int, requestPermission: Boolean = false): Boolean;
}
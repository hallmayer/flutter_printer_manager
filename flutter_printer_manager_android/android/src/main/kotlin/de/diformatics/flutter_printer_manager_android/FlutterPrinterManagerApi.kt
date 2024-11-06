// Autogenerated from Pigeon (v21.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

package de.diformatics.flutter_printer_manager_android

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class USBPrinterState(val raw: Int) {
  NONE(0),
  CONNECTED(1),
  DISCONNECTED(2);

  companion object {
    fun ofRaw(raw: Int): USBPrinterState? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class USBPrinter (
  val productId: Long,
  val vendorId: Long,
  val manufacturerName: String? = null,
  val productName: String? = null

) {
  companion object {
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): USBPrinter {
      val productId = __pigeon_list[0].let { num -> if (num is Int) num.toLong() else num as Long }
      val vendorId = __pigeon_list[1].let { num -> if (num is Int) num.toLong() else num as Long }
      val manufacturerName = __pigeon_list[2] as String?
      val productName = __pigeon_list[3] as String?
      return USBPrinter(productId, vendorId, manufacturerName, productName)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      productId,
      vendorId,
      manufacturerName,
      productName,
    )
  }
}
private object FlutterPrinterManagerApiPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          USBPrinter.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as Int?)?.let {
          USBPrinterState.ofRaw(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is USBPrinter -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is USBPrinterState -> {
        stream.write(130)
        writeValue(stream, value.raw)
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface FlutterPrinterManagerApi {
  fun getPrinters(): List<USBPrinter>
  fun selectUSBDevice(vendorId: Long, productId: Long): Boolean
  fun openUSBConnection(vendorId: Long?, productId: Long?): Boolean
  fun hasUSBPermissions(vendorId: Long, productId: Long, requestPermissions: Boolean): Boolean
  fun closeUSBConnection(): Boolean
  fun getCurrentPrinterState(): USBPrinterState
  fun printBytes(bytes: List<Long>): Boolean

  companion object {
    /** The codec used by FlutterPrinterManagerApi. */
    val codec: MessageCodec<Any?> by lazy {
      FlutterPrinterManagerApiPigeonCodec
    }
    /** Sets up an instance of `FlutterPrinterManagerApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: FlutterPrinterManagerApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.getPrinters$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getPrinters())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.selectUSBDevice$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val vendorIdArg = args[0].let { num -> if (num is Int) num.toLong() else num as Long }
            val productIdArg = args[1].let { num -> if (num is Int) num.toLong() else num as Long }
            val wrapped: List<Any?> = try {
              listOf(api.selectUSBDevice(vendorIdArg, productIdArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.openUSBConnection$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val vendorIdArg = args[0].let { num -> if (num is Int) num.toLong() else num as Long? }
            val productIdArg = args[1].let { num -> if (num is Int) num.toLong() else num as Long? }
            val wrapped: List<Any?> = try {
              listOf(api.openUSBConnection(vendorIdArg, productIdArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.hasUSBPermissions$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val vendorIdArg = args[0].let { num -> if (num is Int) num.toLong() else num as Long }
            val productIdArg = args[1].let { num -> if (num is Int) num.toLong() else num as Long }
            val requestPermissionsArg = args[2] as Boolean
            val wrapped: List<Any?> = try {
              listOf(api.hasUSBPermissions(vendorIdArg, productIdArg, requestPermissionsArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.closeUSBConnection$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.closeUSBConnection())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.getCurrentPrinterState$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.getCurrentPrinterState())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.flutter_printer_manager_android.FlutterPrinterManagerApi.printBytes$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val bytesArg = args[0] as List<Long>
            val wrapped: List<Any?> = try {
              listOf(api.printBytes(bytesArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}

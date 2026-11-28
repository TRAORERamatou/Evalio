package bf.evalio.evalio

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  companion object {
    private const val methodChannel = "bf.evalio/focus"
    private const val eventChannel = "bf.evalio/focus/events"
  }

  private var focusEventSink: EventChannel.EventSink? = null
  private var isInBackground = false

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // FLAG_SECURE : blocage des captures d'écran et de l'enregistrement d'écran
    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

    MethodChannel(flutterEngine.binaryMessenger, MainActivity.methodChannel).setMethodCallHandler { call, result ->
      when (call.method) {
        "isSecure" -> result.success(window.attributes.flags and WindowManager.LayoutParams.FLAG_SECURE != 0)
        else -> result.notImplemented()
      }
    }

    EventChannel(flutterEngine.binaryMessenger, MainActivity.eventChannel).setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          focusEventSink = events
        }

        override fun onCancel(arguments: Any?) {
          focusEventSink = null
        }
      },
    )
  }

  override fun onUserLeaveHint() {
    super.onUserLeaveHint()
    // L'utilisateur a quitté l'app (bouton home, appel, etc.)
    notifyFocusChanged(false)
  }

  override fun onPause() {
    super.onPause()
    notifyFocusChanged(false)
  }

  override fun onResume() {
    super.onResume()
    notifyFocusChanged(true)
  }

  private fun notifyFocusChanged(hasFocus: Boolean) {
    // Déduplication : on n'émet qu'à la vraie transition (évite le double
    // comptage quand onUserLeaveHint et onPause se déclenchent ensemble).
    if (hasFocus == !isInBackground) return
    isInBackground = !hasFocus
    focusEventSink?.success(mapOf("hasFocus" to hasFocus, "timestampMs" to System.currentTimeMillis()))
  }
}

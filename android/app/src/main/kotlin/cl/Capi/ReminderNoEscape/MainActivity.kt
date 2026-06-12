package cl.Capi.ReminderNoEscape

import android.app.KeyguardManager
import android.content.Context
import android.hardware.camera2.CameraManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterActivity() {

    private val TORCH_CHANNEL = "reminder_noescape/torch"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TORCH_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "setTorch") {
                    val on = call.argument<Boolean>("on") ?: false
                    setTorch(on)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun setTorch(on: Boolean) {
        try {
            val camManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
            val cameraId = camManager.cameraIdList[0]
            camManager.setTorchMode(cameraId, on)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleAlertIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        handleAlertIntent(intent)
    }

    private fun handleAlertIntent(intent: Intent?) {
        if (intent?.action == "SHOW_ALERT") {
            val payload = intent.getStringExtra("alert_payload") ?: return
            // Enviar a Flutter via MethodChannel
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, "reminder_noescape/alert")
                    .invokeMethod("showAlert", payload)
            }
            // Limpiar para no repetir
            intent.action = null
        }
    }
}
package cl.Capi.ReminderNoEscape

import android.app.AlarmManager
import android.app.KeyguardManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.camera2.CameraManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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

        // MethodChannel para cadena nativa de alarmas (AlarmReceiver)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "reminder_noescape/alarm")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAlarm" -> {
                        val taskId = call.argument<String>("taskId") ?: return@setMethodCallHandler result.error("INVALID", "taskId required", null)
                        val intervalSeconds = call.argument<Int>("intervalSeconds") ?: 60
                        val dueDateMillis = call.argument<Long>("dueDateMillis") ?: 0L
                        val anticipationTimeMillis = call.argument<Long>("anticipationTimeMillis") ?: 0L
                        val title = call.argument<String>("title") ?: "Recordatorio"

                        scheduleNativeAlarm(taskId, intervalSeconds, dueDateMillis, anticipationTimeMillis, title)
                        result.success(null)
                    }
                    "cancelAlarm" -> {
                        val taskId = call.argument<String>("taskId") ?: return@setMethodCallHandler result.error("INVALID", "taskId required", null)
                        AlarmReceiver.cancelAlarm(this, taskId)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun scheduleNativeAlarm(taskId: String, intervalSeconds: Int, dueDateMillis: Long, anticipationTimeMillis: Long, title: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(this, AlarmReceiver::class.java).apply {
            putExtra(AlarmReceiver.EXTRA_TASK_ID, taskId)
            putExtra(AlarmReceiver.EXTRA_INTERVAL_SECONDS, intervalSeconds)
            putExtra(AlarmReceiver.EXTRA_DUE_DATE, dueDateMillis)
            putExtra(AlarmReceiver.EXTRA_TITLE, title)
        }

        val requestCode = AlarmReceiver.ALARM_REQUEST_BASE + taskId.hashCode()
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Primera alarma en anticipationTime + interval (no en now + interval)
        // Esto asegura que "Realizando tarea" (30 min de pausa) funcione correctamente
        val triggerAtMillis = anticipationTimeMillis + (intervalSeconds * 1000L)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (alarmManager.canScheduleExactAlarms()) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
            } else {
                alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
            }
        } else {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
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
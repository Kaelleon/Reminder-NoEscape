package cl.Capi.ReminderNoEscape

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class AlarmReceiver : BroadcastReceiver() {

    companion object {
        const val EXTRA_TASK_ID = "task_id"
        const val EXTRA_INTERVAL_SECONDS = "interval_seconds"
        const val EXTRA_DUE_DATE = "due_date"
        const val EXTRA_TITLE = "title"
        const val EXTRA_NOTIFICATION_CHANNEL_ID = "reminder_channel_repeat"
        const val NOTIFICATION_ID_BASE = 2000000
        const val ALARM_REQUEST_BASE = 3000000

        fun cancelAlarm(context: Context, taskId: String) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, AlarmReceiver::class.java)
            val requestCode = ALARM_REQUEST_BASE + taskId.hashCode()
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmManager.cancel(pendingIntent)

            // Cancelar también la notificación nativa
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.cancel(NOTIFICATION_ID_BASE + taskId.hashCode())
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val taskId = intent.getStringExtra(EXTRA_TASK_ID) ?: return
        val intervalSeconds = intent.getIntExtra(EXTRA_INTERVAL_SECONDS, 60)
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "Recordatorio"
        val dueDateMillis = intent.getLongExtra(EXTRA_DUE_DATE, 0L)

        val now = System.currentTimeMillis()

        // Verificar que no hayamos pasado la fecha límite
        if (dueDateMillis > 0 && now >= dueDateMillis) return

        // 1. Mostrar notificación nativa
        showNotification(context, taskId, title)

        // 2. Agendar la siguiente alarma (cadena infinita)
        val nextAlarmTime = now + (intervalSeconds * 1000L)
        if (dueDateMillis <= 0 || nextAlarmTime < dueDateMillis) {
            scheduleNextAlarm(context, taskId, intervalSeconds, title, dueDateMillis, nextAlarmTime)
        }
    }

    private fun showNotification(context: Context, taskId: String, title: String) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Crear canal de notificación
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                EXTRA_NOTIFICATION_CHANNEL_ID,
                "Recordatorios insistentes",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Notificaciones de recordatorios que se repiten"
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 500, 200, 500)
            }
            nm.createNotificationChannel(channel)
        }

        // Intent para abrir MainActivity cuando se toca la notificación
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("alert_payload", taskId)
            action = "SHOW_ALERT"
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            taskId.hashCode(),
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, EXTRA_NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("🔁 $title")
            .setContentText("Sigue pendiente — toca para ver la tarea")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setAutoCancel(true)
            .setOngoing(false)
            .setFullScreenIntent(pendingIntent, true)
            .setContentIntent(pendingIntent)
            .build()

        nm.notify(NOTIFICATION_ID_BASE + taskId.hashCode(), notification)
    }

    private fun scheduleNextAlarm(
        context: Context,
        taskId: String,
        intervalSeconds: Int,
        title: String,
        dueDateMillis: Long,
        triggerAtMillis: Long
    ) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra(EXTRA_TASK_ID, taskId)
            putExtra(EXTRA_INTERVAL_SECONDS, intervalSeconds)
            putExtra(EXTRA_TITLE, title)
            putExtra(EXTRA_DUE_DATE, dueDateMillis)
        }

        val requestCode = ALARM_REQUEST_BASE + taskId.hashCode()
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (alarmManager.canScheduleExactAlarms()) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            }
        } else {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        }
    }
}
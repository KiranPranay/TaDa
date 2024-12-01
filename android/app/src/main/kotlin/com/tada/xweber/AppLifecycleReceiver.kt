package com.tada.xweber

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log

class AppLifecycleReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action == Intent.ACTION_USER_PRESENT || action == Intent.ACTION_BOOT_COMPLETED) {
            // Update the widget when the user unlocks the phone or after a reboot
            Log.d("AppLifecycleReceiver", "Received $action, updating widget")

            // Retrieve data from SharedPreferences
            val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val completed = prefs.getInt("flutter.completedTodos", 0)
            val total = prefs.getInt("flutter.totalTodos", 0)
            val completedText = "$completed/$total Completed"
            val progress = if (total == 0) "0%" else "${((completed.toDouble() / total.toDouble()) * 100).toInt()}%"
            val currentDate = ToDo.getCurrentDate()

            // Update the widget with the retrieved data
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, ToDo::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (appWidgetId in appWidgetIds) {
                ToDo.updateAppWidget(context, appWidgetManager, appWidgetId, "Todos Completed", completedText, progress, currentDate)
            }
        }
    }
}

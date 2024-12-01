package com.tada.xweber

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class ToDo : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        Log.d("ToDo", "onUpdate called")
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Called when the first widget is created
        Log.d("ToDo", "onEnabled called, requesting initial widget update")

        // Trigger an update using stored data in SharedPreferences
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Retrieve stored data (using the default values in case nothing is stored yet)
        val completed = prefs.getInt("flutter.completedTodos", 0)
        val total = prefs.getInt("flutter.totalTodos", 0)
        val completedText = "$completed/$total Completed"
        val progress = if (total == 0) "0%" else "${((completed.toDouble() / total.toDouble()) * 100).toInt()}%"

        // Get the current date
        val currentDate = getCurrentDate()

        // Update the widget with the retrieved data
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val thisWidget = ComponentName(context, ToDo::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, "Todos Completed", completedText, progress, currentDate)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val title = intent.getStringExtra("title") ?: "Todos Completed"
            val completed = intent.getStringExtra("completed") ?: "0/0 Completed"
            val progress = intent.getStringExtra("progress") ?: "0%"
            val date = getCurrentDate()  // Update the date dynamically

            Log.d("ToDo", "onReceive: Update called with title: $title")

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, ToDo::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId, title, completed, progress, date)
            }
        }
    }

    companion object {
        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            title: String = "Todos Completed",
            completed: String = "0/0 Completed",
            progress: String = "0%",
            date: String = "Loading..."
        ) {
            Log.d("ToDo", "updateAppWidget called with title: $title")

            val views = RemoteViews(context.packageName, R.layout.to_do)

            // Set dynamic values to the widget views
            views.setTextViewText(R.id.todos_completed, title)
            views.setTextViewText(R.id.completed_count, completed)
            views.setTextViewText(R.id.progress_percentage, progress)
            views.setTextViewText(R.id.date, date)

            // Modify the intent to always open the main activity and clear any existing task
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.progress_circular, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // Function to get the current date formatted as "Day, Month Date"
        private fun getCurrentDate(): String {
            val dateFormat = SimpleDateFormat("EEEE, MMMM d", Locale.getDefault())
            return dateFormat.format(Date())
        }
    }
}

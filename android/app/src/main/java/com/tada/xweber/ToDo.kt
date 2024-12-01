package com.tada.xweber

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews

class ToDo : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        Log.d("ToDo", "onUpdate called")
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val title = intent.getStringExtra("title") ?: "Todos Completed"
            val completed = intent.getStringExtra("completed") ?: "0/0 Completed"
            val progress = intent.getStringExtra("progress") ?: "0%"
            Log.d("ToDo", "onReceive: Update called with title: $title")

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, ToDo::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId, title, completed, progress)
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
            progress: String = "0%"
        ) {
            Log.d("ToDo", "updateAppWidget called with title: $title")

            val views = RemoteViews(context.packageName, R.layout.to_do)

            views.setTextViewText(R.id.todos_completed, title)
            views.setTextViewText(R.id.completed_count, completed)
            views.setTextViewText(R.id.progress_percentage, progress)

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.progress_circular, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

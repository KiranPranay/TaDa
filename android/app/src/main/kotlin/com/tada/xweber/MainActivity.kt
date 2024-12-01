package com.tada.xweber

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.tada.xweber/widget_update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                val title = call.argument<String>("title") ?: "Todos Completed"
                val completed = call.argument<String>("completed") ?: "0/0 Completed"
                val progress = call.argument<String>("progress") ?: "0%"

                // Update the widget by sending broadcast intent
                Log.d("MainActivity", "Sending updateWidget broadcast with title: $title")
                updateWidget(title, completed, progress)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget(title: String, completed: String, progress: String) {
        val context: Context = applicationContext
        val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE).apply {
            component = ComponentName(context, ToDo::class.java)
            putExtra("title", title)
            putExtra("completed", completed)
            putExtra("progress", progress)
        }

        context.sendBroadcast(intent)
    }
}

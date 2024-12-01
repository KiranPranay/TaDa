package com.tada.xweber

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), LifecycleObserver {

    private val CHANNEL = "com.tada.xweber/widget_update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                val title = call.argument<String>("title") ?: "Todos Completed"
                val completed = call.argument<String>("completed") ?: "0/0 Completed"
                val progress = call.argument<String>("progress") ?: "0%"

                updateWidget(title, completed, progress)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onAppBackgrounded() {
        Log.d("MainActivity", "App moved to background")
        // Trigger widget update to persist data when app is in background
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val completed = prefs.getInt("flutter.completedTodos", 0)
        val total = prefs.getInt("flutter.totalTodos", 0)
        val completedText = "$completed/$total Completed"
        val progress = if (total == 0) "0%" else "${((completed.toDouble() / total.toDouble()) * 100).toInt()}%"
        updateWidget("Todos Completed", completedText, progress)
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

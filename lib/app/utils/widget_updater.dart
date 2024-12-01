import 'package:flutter/services.dart';

class WidgetUpdater {
  static const MethodChannel _channel =
      MethodChannel('com.tada.xweber/widget_update');

  static Future<void> updateWidget(
      String title, String completed, String progress) async {
    try {
      await _channel.invokeMethod('updateWidget', {
        'title': title,
        'completed': completed,
        'progress': progress,
      });
    } catch (e) {
      print("Failed to update widget: $e");
    }
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_config.dart';

const channelId = 'app_toro';
const channelName = 'Where is my toro?';
const channelDescription = 'Channel for app_toro notifications';

Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(channelId, channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics);
}

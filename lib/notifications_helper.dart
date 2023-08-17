import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  Future<bool> checkForPermissions() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var allowed = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    return (allowed ?? false);
  }


}

import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings  settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
      badge: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granterd Permissions');
    }  else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User Granterd Provisional Permissions');

    } else{
      print('User Denied Permissions');

    }

  }
}

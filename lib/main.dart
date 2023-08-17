import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
import 'package:mondaytest/Views/screens/stream%20builder/stream_single_user.dart';
import 'package:mondaytest/homepagestf.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase_options.dart';
import 'helper/constants.dart';

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    checkNotificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: currentUser != null ? HomePage() : ScreenLogIn(),


          // FirebaseAuth.instance.currentUser == null
          //     ? ScreenLogIn()
          //     : StreamSingleUser(),
        );
      },
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await
    FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }
  void _handleMessage(RemoteMessage message) {
    print("message: $message");
    if (message.data['type'] == 'chat') {}
  }
  void setupNotificationChannel() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
        final settingsIOS =
        DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body,
        payload) => null /*onSelectNotification(payload)*/);
    await flutterLocalNotificationsPlugin.initialize(InitializationSettings(android:
    settingsAndroid, iOS: settingsIOS));
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? iOS = message.notification?.apple;
    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
    android: AndroidNotificationDetails(channel.id, channel.name,
    channelDescription: channel.description,
    icon: android.smallIcon,
    enableVibration: true,
    // importance: Importance.max,
    priority: Priority.max,
    // ongoing: false,
    // autoCancel: true,
    // visibility: NotificationVisibility.public,
    enableLights: true
    // other properties...
    ),
    iOS: DarwinNotificationDetails(
    sound: iOS?.sound?.name,
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    )));
    // showOngoingNotification(flutterLocalNotificationsPlugin, title:
    notification.title ?? "This is notification"; body: notification.body ?? "Hello notification";

    }
    });
  }
  void initNotificationChannel() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
    DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS:
    initializationSettingsIOS, macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }



  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  void checkNotificationPermission() async {
    var settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized){
      setupInteractedMessage();
      initNotificationChannel();
      setupNotificationChannel();
    }
  }
}
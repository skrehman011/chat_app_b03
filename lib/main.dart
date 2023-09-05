import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/Views/screens/screen_group_chat.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
import 'package:mondaytest/controller/home_controller.dart';
import 'package:mondaytest/homepagestf.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase_options.dart';
import 'helper/constants.dart';

Future<void> main() async {
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
    initDynamicLinks();
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

  Future<void> initDynamicLinks() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      processData(deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        // Set up the `onLink` event listener next as it may be received here
        final Uri deepLink = pendingDynamicLinkData.link;
        // Example of using the dynamic link to push the user to a different screen
        processData(deepLink.path);
      },
    );
  }

  void processData(String path) async {
    var groupId = path.replaceAll("/", "");

    print('Group: $groupId');

    if (currentUser == null) {
      Get.to(ScreenLogIn());
      return;
    }

    try {
      Get.bottomSheet(
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: chatsRef.child(groupId.trim()).get(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Row(
                            children: [
                              Text("Checking group link"),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      if (snapshot.data == null) {
                        return Text("Invalid Data");
                      }

                      var data = RoomInfo.fromMap(Map<String, dynamic>.from(
                          snapshot.data!.value as Map));

                      return Column(
                        children: [
                          ListTile(
                            title: Text(data.name),
                            subtitle: Text(data.roomType),
                            trailing: Text(
                                "${data.participants.length} participants"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(data.participants.contains(currentUser!.uid)
                              ? "You are already a member of this group"
                              : "Click join to enter the group"),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Dismiss"),
                                ),
                              ),
                              if (!data.participants.contains(currentUser!.uid))
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    chatsRef.child(data.id).update({
                                      "participants": [
                                        ...data.participants,
                                        currentUser!.uid
                                      ]
                                    }).then((value) {

                                      Get.back();
                                      Get.put(HomeController()).setSelectedId(data.id);
                                      Get.to(ScreenGroupChat());
                                    });
                                  },
                                  child: Text("Join"),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
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
    const settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            null /*onSelectNotification(payload)*/);
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
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
        notification.title ?? "This is notification";
        body:
        notification.body ?? "Hello notification";
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
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );

  void checkNotificationPermission() async {
    var settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setupInteractedMessage();
      initNotificationChannel();
      setupNotificationChannel();
    }
  }
}

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/Views/screens/screen_group_chat.dart';
import 'package:mondaytest/Views/screens/screen_home.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
import 'package:mondaytest/controller/dependancy_injection.dart';
import 'package:mondaytest/controller/home_controller.dart';
import 'package:mondaytest/helper/constants.dart';
import 'package:mondaytest/homepagestf.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
  DependencyInjection.init();
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
    // initDynamicLinks();
    initAppLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: currentUser != null ? ScreenHome() : ScreenLogIn(),

          // FirebaseAuth.instance.currentUser == null
          //     ? ScreenLogIn()
          //     : StreamSingleUser(),
        );
      },
    );
  }

  // Future<void> initDynamicLinks() async {
  //   // Check if you received the link via `getInitialLink` first
  //   final PendingDynamicLinkData? initialLink =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //
  //   if (initialLink != null) {
  //     final Uri deepLink = initialLink.link;
  //     // Example of using the dynamic link to push the user to a different screen
  //     processData(deepLink.path);
  //   }
  //
  //   FirebaseDynamicLinks.instance.onLink.listen(
  //     (pendingDynamicLinkData) {
  //       // Set up the `onLink` event listener next as it may be received here
  //       final Uri deepLink = pendingDynamicLinkData.link;
  //       // Example of using the dynamic link to push the user to a different screen
  //       processData(deepLink.path);
  //     },
  //   );
  // }

  void initAppLinks() {
    final _appLinks = AppLinks();

// Subscribe to all events when app is started.
// (Use allStringLinkStream to get it as [String])

    _appLinks.getInitialAppLink().then((uri) async {
      if (uri != null) {
        processData(uri);
      }
    });
    _appLinks.allUriLinkStream.listen((uri) async {

      processData(uri);

    });
  }

  Future<DataSnapshot?> processUrlAndGetGroupData(Uri uri) async {
    if (currentUser == null) {
      Get.to(ScreenLogIn());
      return null;
    }
    var firebaseLinkData =
        await FirebaseDynamicLinks.instance.getDynamicLink(uri);
    var path = uri.path;

    print("Data: ${firebaseLinkData}");

    if (firebaseLinkData != null) {
      var originalUri = firebaseLinkData.link;
      print("Original Link: ${originalUri}");
      print("Original Path: ${originalUri.path}");
      path = originalUri.path;
    }
    var groupId = path.replaceAll("/", "");

    var data = await chatsRef.child(groupId.trim()).get();
    return data;
  }

  void processData(Uri uri) async {
    var groupId = uri.path;
    print('Group: $groupId');

    if (currentUser == null) {
      Get.to(ScreenLogIn());
      return;
    }

    try {
      Get.bottomSheet(
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20)
                ),
                child: FutureBuilder(
                    future: processUrlAndGetGroupData(uri),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Checking group link"),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      if (snapshot.data?.value == null) {
                        return Text(
                            "Invalid Data (No group found for $groupId)");
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
                                        Get.put(HomeController())
                                            .setSelectedId(data.id);
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
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
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

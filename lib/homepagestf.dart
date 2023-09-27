import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/Models/message_model.dart';
import 'package:mondaytest/Views/screens/screen_all_users.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_group_chat.dart';
import 'package:mondaytest/controller/home_controller.dart';
import 'package:mondaytest/helper/Fcm.dart';
import 'package:mondaytest/helper/cached_data.dart';
import 'package:mondaytest/helper/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Models/Student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    updateMyToken();
    startLastSeenUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    homeController.startChatStream();

    return Scaffold(
      body: Obx(() {
        return homeController.chatsList.isEmpty
            ? Center(
                child: Text("No chats available"),
              )
            : ListView.builder(
                itemCount: homeController.chatsList.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = homeController.chatsList[index];
                  return item.roomType == 'group'
                      ? getGroupItem(item as RoomInfo, onClick: () {
                          homeController.setSelectedId(item.id);
                        })
                      : getUserItem(item as RoomInfo, onClick: () {
                          homeController.setSelectedId(item.id);
                        });
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ScreenAllUsers());
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  Widget getUserItem(RoomInfo item, {required VoidCallback onClick}) {
    var users = item.participants;
    users.removeWhere((element) => element == currentUser!.uid);
    var receiver = users.first;

    return FutureBuilder<Student>(
        future: CachedData.getStudentById(receiver),
        builder: (_, userSnapshot) {
          var name = '';

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }

          var user = userSnapshot.data;

          if (user == null) {
            name = "Unknown User";
          }

          name = userSnapshot.data?.name ?? "";

          return ListTile(
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: item.lastMessage == null
                ? null
                : Text(
                    item.lastMessage!.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            onTap: () {
              onClick();
              Get.to(
                ScreenChat(
                  receiver: userSnapshot.data!,
                ),
              );
            },
            leading: Container(
              height: 40,
              width: 40,
              child: Center(
                  child: Text(
                name[0].toUpperCase(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
            ),
          );
        });
  }

  Widget getGroupItem(RoomInfo item, {required VoidCallback onClick}) {
    return ListTile(
      title: Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: item.lastMessage == null
          ? null
          : Text(
              item.lastMessage!.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      onTap: () {
        onClick();
        Get.to(
          ScreenGroupChat(),
        );
      },
      leading: Container(
        height: 40,
        width: 40,
        child: Center(
            child: Text(
          item.name[0].toUpperCase(),
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
      ),
    );
  }

  void updateMyToken() async {
    var token = await FCM.generateToken();
    usersRef.doc(currentUser!.uid).update({"token": token});
  }

  void startLastSeenUpdates() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      usersRef
          .doc(currentUser!.uid)
          .update({'lastSeen': DateTime.now().millisecondsSinceEpoch});
    });
  }
}

class ItemInbox extends StatelessWidget {
  const ItemInbox({
    super.key,
    required this.user,
    required this.message,
    required this.sentByMe,
  });

  final Student user;
  final MessageModel message;
  final bool sentByMe;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
        alignment: Alignment.center,
        child: Text(
          user.name[0].toUpperCase(),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      subtitle: Row(
        children: [
          if (message.message_type == 'image')
            Icon(
              Icons.image,
              size: 15.sp,
            ),
          Text(
            "${sentByMe ? "You: " : ""}${message.message_type == 'text' ? message.text : message.message_type}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      onTap: () {
        Get.to(ScreenChat(receiver: user));
      },
    );
  }
}

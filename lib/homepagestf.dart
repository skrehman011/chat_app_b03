import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/Models/message_model.dart';
import 'package:mondaytest/Models/user_model.dart';
import 'package:mondaytest/Views/screens/screen_all_users.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_group_chat.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('home page'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Get.offAll(ScreenLogIn()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: chatsRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.snapshot == null ||
              !snapshot.data!.snapshot.exists) {
            return Center(
              child: Text("No groups"),
            );
          }

          var chats = snapshot.data!.snapshot.children
              .map((e) =>
                  RoomInfo.fromMap(Map<String, dynamic>.from(e.value as Map)))
              .toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              var item = chats[index];

              return item.roomType == 'group'
                  ? getGroupItem(item)
                  : getUserItem(item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ScreenAllUsers());
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  Widget getUserItem(RoomInfo item) {
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
            title: Text(name),
            subtitle:
                item.lastMessage == null ? null : Text(item.lastMessage!.text),
            onTap: () {
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

  Widget getGroupItem(RoomInfo item) {
    return ListTile(
      title: Text(item.name),
      subtitle: item.lastMessage == null ? null : Text(item.lastMessage!.text),
      onTap: () {
        Get.to(
          ScreenGroupChat(
            roomInfo: item,
          ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/user_model.dart';
import 'package:mondaytest/Views/screens/screen_all_users.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
import 'package:mondaytest/helper/constants.dart';

import 'Models/Student.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home page'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => Get.offAll(ScreenLogIn()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs.map((e) => Student.fromMap(e.data() as Map<String, dynamic>)).toList();

          users.removeWhere((element) => element.id == currentUser!.uid);

          return users.isNotEmpty
              ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      onTap: () {
                        Get.to(ScreenChat(receiver: user));
                      },
                    );
                  },
                )
              : Center(
                  child: Text("No users found"),
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
}

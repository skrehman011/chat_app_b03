import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/user_model.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/helper/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs
              .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
              .toList();

          users.removeWhere((element) => element.id == currentUser!.uid);

          return users.isNotEmpty
              ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = users[index];
                    return ListTile(
                      title: Text(user.id),
                      onTap: (){
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/Student.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/helper/constants.dart';

class ScreenAllUsers extends StatelessWidget {
  const ScreenAllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a user to chat"),
      ),
      body: FutureBuilder(
        future: usersRef.get(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs
              .map((e) => Student.fromMap(e.data() as Map<String, dynamic>))
              .where((element) => element.id != currentUser!.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              var student = users[index];

              return ListTile(
                title: Text(student.name),
                onTap: (){
                  Get.to(ScreenChat(receiver: student));
                },
              );
            },
          );
        },
      ),
    );
  }
}

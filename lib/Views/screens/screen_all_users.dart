import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/Student.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_new_group.dart';
import 'package:mondaytest/helper/constants.dart';

class ScreenAllUsers extends StatelessWidget {
  const ScreenAllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a user to chat"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("New group"),
              onTap: () {
                Get.to(ScreenNewGroup());
              },
              leading: Container(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              ),
            ),
            FutureBuilder(
              future: usersRef.get(),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error.toString()}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text("No user data available."),
                  );
                }

                var users = snapshot.data!.docs
                    .map((e) =>
                        Student.fromMap(e.data() as Map<String, dynamic>))
                    .where((element) => element.id != currentUser!.uid)
                    .toList();

                if (users.isEmpty) {
                  return Center(
                    child: Text("No users to display."),
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var student = users[index];

                    return ListTile(
                      title: Text(student.name),
                      leading: Container(
                        height: 40,
                        width: 40,
                        child: Center(
                            child: Text(
                          student.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.pink),
                      ),
                      onTap: () {
                        Get.to(ScreenChat(receiver: student));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

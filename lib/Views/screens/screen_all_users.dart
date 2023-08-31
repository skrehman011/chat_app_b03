import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/Student.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_select_participants.dart';
import 'package:mondaytest/helper/constants.dart';

import '../../controller/new_group_controller.dart';
import '../../homepagestf.dart';

class ScreenAllUsers extends StatelessWidget {
  const ScreenAllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newGroupController = Get.put(NewGroupController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Select a user"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("New group"),
              onTap: () async {
                var selectedStudents = await Get.to<List<Student>>(ScreenSelectParticipants(
                  title: "New Group",
                  subtitle: "Add Participants",
                ));
                if (selectedStudents != null) {
                  var nameController = TextEditingController();

                  Get.bottomSheet(
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(() {
                            return newGroupController.createGroupLoading.isTrue
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Create new group",
                                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Group name",
                                        ),
                                        controller: nameController,
                                      ),
                                      SizedBox(
                                        height: Get.height * .1,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                            onPressed: () {
                                              newGroupController.createGroup(nameController.text, selectedStudents).then((value) {
                                                Get.offAll(HomePage());
                                              });
                                            },
                                            child: Text("Create")),
                                      )
                                    ],
                                  );
                          }),
                        ),
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));
                }
              },
              leading: Container(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
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
                    .map((e) => Student.fromMap(e.data() as Map<String, dynamic>))
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
                  physics: NeverScrollableScrollPhysics(),
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
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
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

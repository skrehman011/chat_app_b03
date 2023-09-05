import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Models/Student.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:mondaytest/Views/screens/screen_select_participants.dart';
import 'package:mondaytest/controller/home_controller.dart';
import 'package:mondaytest/helper/cached_data.dart';
import 'package:mondaytest/helper/constants.dart';
import 'package:share_plus/share_plus.dart';

class ScreenGroupInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: Get.height * .1,
                  width: Get.height * .1,
                  child: Center(child: Obx(() {
                    return Text(
                      homeController.selectedRoomInfo.value!.name[0]
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: Get.height * .04,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  })),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Text(
                    homeController.selectedRoomInfo.value!.name,
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  );
                }),
                SizedBox(
                  height: 5,
                ),
                Obx(() {
                  return Text(
                      "Group | ${homeController.selectedRoomInfo.value!.participants.length} participants");
                }),
                Divider(
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  onTap: () async {
                    var selected = await Get.to<List<Student>>(
                      ScreenSelectParticipants(
                        title: homeController.selectedRoomInfo.value!.name,
                        subtitle: "Update Participants",
                        alreadySelected:
                            homeController.selectedRoomInfo.value!.participants,
                      ),
                    );

                    if (selected != null && selected.isNotEmpty) {
                      var selectedStringList =
                          selected.map((e) => e.id).toList();

                      if (!selectedStringList.contains(currentUser!.uid)) {
                        selectedStringList.add(currentUser!.uid);
                      }

                      chatsRef
                          .child("${homeController.selectedRoomInfo.value!.id}")
                          .update({"participants": selectedStringList});
                    }
                  },
                  leading: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                        child: Icon(
                      Icons.group,
                      color: Colors.white,
                    )),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.pink),
                  ),
                  title: Text(
                    "Add participant",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    print('creating');
                    var url = await buildDynamicLinks(
                        homeController.selectedRoomInfo.value!.name,
                        'Group Description sample',
                        '',
                        homeController.selectedRoomInfo.value!.id,
                        true);
                    Share.share('Click here to join my WhatsApp Group:\n$url',
                        subject: "Group invite link");
                  },
                  leading: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                        child: Icon(
                      Icons.share,
                      color: Colors.white,
                    )),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.pink),
                  ),
                  title: Text(
                    "Invite Participants",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    print('creating');
                    var url = await buildDynamicLinks(
                        homeController.selectedRoomInfo.value!.name,
                        'Group Description sample',
                        '',
                        homeController.selectedRoomInfo.value!.id,
                        true);
                    Clipboard.setData(ClipboardData(
                            text:
                                'Click here to join my WhatsApp Group:\n$url'))
                        .then((value) {
                      Get.snackbar("Success", "Invite copied to clipboard");
                    });
                  },
                  leading: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                        child: Icon(
                      Icons.copy,
                      color: Colors.white,
                    )),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.pink),
                  ),
                  title: Text(
                    "Copy to clipboard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Obx(() {
                  var myId = currentUser!.uid;
                  var adminId =
                      homeController.selectedRoomInfo.value!.groupAdmin;

                  homeController.selectedRoomInfo.value!.participants
                      .remove(myId);
                  homeController.selectedRoomInfo.value!.participants
                      .remove(adminId);

                  homeController.selectedRoomInfo.value!.participants
                      .insert(0, myId);
                  if (adminId != myId) {
                    homeController.selectedRoomInfo.value!.participants
                        .insert(1, adminId);
                  }

                  return ListView.builder(
                    itemCount: homeController
                        .selectedRoomInfo.value!.participants.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var id = homeController
                          .selectedRoomInfo.value!.participants[index];

                      return FutureBuilder(
                        future: CachedData.getStudentById(id),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
                          }

                          var student = snapshot.data!;

                          return ListTile(
                            title: Text(
                                "${student.name}${student.id == myId ? " (You)" : ""}"),
                            leading: Container(
                              height: 40,
                              width: 40,
                              child: Center(
                                  child: Text(
                                student.name[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.pink),
                            ),
                            trailing: homeController
                                        .selectedRoomInfo.value!.groupAdmin ==
                                    id
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Group Admin",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              Get.to(ScreenChat(receiver: student));
                            },
                          );
                        },
                      );
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

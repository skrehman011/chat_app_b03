import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/controller/new_group_controller.dart';

import '../../Models/Student.dart';
import '../../helper/constants.dart';
import '../../homepagestf.dart';

class ScreenNewGroup extends StatelessWidget {
  const ScreenNewGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newGroupController = Get.put(NewGroupController());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Group",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Obx(() {
              return Text(
                newGroupController.selectedStudents.isEmpty
                    ? "Add participants"
                    : "${newGroupController.selectedStudents.length} of ${newGroupController.studentsList.length} selected",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              );
            }),
          ],
        ),
        actions: [
          Icon(Icons.search),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: newGroupController.selectedStudents
                    .map((element) => ItemSelectedUser(
                          onTap: () {
                            newGroupController.removeSelected(element);
                          },
                          name: element.name,
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newGroupController.studentsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var student = newGroupController.studentsList[index];

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
                      newGroupController.addToSelected(student);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        return newGroupController.selectedStudents.isEmpty
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Create new group",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
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
                                              newGroupController
                                                  .createGroup(
                                                      nameController.text)
                                                  .then((value) {
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)));
                },
                child: Icon(Icons.arrow_forward),
              );
      }),
    );
  }
}

class ItemSelectedUser extends StatelessWidget {
  VoidCallback onTap;
  String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          Container(
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
          Positioned(
            child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                )),
            right: 0,
          )
        ],
      ),
    );
  }

  ItemSelectedUser({
    required this.onTap,
    required this.name,
  });
}

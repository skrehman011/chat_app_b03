import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/controller/new_group_controller.dart';
import 'package:mondaytest/controller/participants_controller.dart';

import '../../Models/Student.dart';
import '../../helper/constants.dart';
import '../../homepagestf.dart';

class ScreenSelectParticipants extends StatelessWidget {
  String title;
  String subtitle;
  List<String> alreadySelected;

  @override
  Widget build(BuildContext context) {
    var participantsController = Get.put(ParticipantsController(alreadySelected: alreadySelected));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Obx(() {
              return Text(
                participantsController.selectedStudents.isEmpty
                    ? subtitle
                    : "${participantsController.selectedStudents.length} of ${participantsController.studentsList.length} selected",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              );
            }),
          ],
        ),
        centerTitle: false,
        actions: [
          Icon(Icons.search),
        ],
      ),
      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: participantsController.selectedStudents
                      .map((element) => ItemSelectedUser(
                            onTap: () {
                              participantsController.removeSelected(element);
                            },
                            name: element.name,
                          ))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: participantsController.studentsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var student = participantsController.studentsList[index];

                  return ListTile(
                    title: Text(student.name),
                    trailing: participantsController.selectedStudents.contains(student) ? Icon(Icons.check) : null,
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
                      participantsController.addToSelected(student);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        return participantsController.selectedStudents.isEmpty
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  Get.back(result: participantsController.selectedStudents);
                },
                child: Icon(Icons.check),
              );
      }),
    );
  }

  ScreenSelectParticipants({
    required this.title,
    required this.subtitle,
    this.alreadySelected = const [],
  });
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
            height: 50,
            width: 50,
            child: Center(
                child: Text(
              name[0].toUpperCase(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';

import 'package:mondaytest/controller/chat_controller.dart';

import '../../Models/Student.dart';


class ScreenVideoPerview extends StatelessWidget {

Student receiver;

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController(receiver_id: receiver.id,));


    return Scaffold(
      body: Stack(
        children: [
          Container(
          width: Get.width,
          color: Colors.black,
          height: Get.height * 5,
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Stack(
            children: [

              Container(
                padding: EdgeInsets.only(top: 30),
                width: Get.width,
                child: Obx(() {
                  return Image(
                      image: (chatController.videoPath.value.isEmpty)
                          ? AssetImage("assets/images/multan.jpg")
                          : FileImage(
                          File(chatController.videoPath.value.toString()))
                      as ImageProvider);
                }),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                leading: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.add, color: Colors.white,),
                ),
                trailing: Container(
                  width: Get.width * 0.67,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.hd, color: Colors.white,),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.sticky_note_2_rounded, color: Colors.white,),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.text_fields_sharp, color: Colors.white,),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.edit, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 55,),
                ),
              ),
              Positioned(
                bottom: 65,
                left: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5,),
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightGreen.shade500,
                    ),
                    // child: ListTile(
                    //   leading: IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.add_photo_alternate_rounded,
                    //         size: 25,
                    //         color: Colors.white,
                    //       )),
                    //   title: TextField(
                    //     maxLines: null,
                    //     decoration: InputDecoration(
                    //         border: InputBorder.none,
                    //         hintText: 'Add a caption...',
                    //         hintStyle: TextStyle(
                    //           color: Colors.white,
                    //
                    //         )
                    //     ),
                    //   ),
                    //   trailing: IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.repeat_one_rounded,
                    //         size: 25,
                    //         color: Colors.white,
                    //       )),
                    // )
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 25,
                            color: Colors.white,
                          )),
                      Container(
                        width: Get.width* 0.65,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add a caption...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.repeat_one_rounded,
                            size: 25,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
          Positioned(
              right: 16,
              bottom: 10,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueGrey,
                      ),
                      child: Text(
                        'Receiver name',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                  FloatingActionButton(
                    onPressed: () {
                      chatController.sendMessage(chatController.textEditingController.value.text);
                      Get.to(ScreenChat(receiver: receiver));
                    },
                    backgroundColor: Color(0xFF075e55),
                    child: Icon(
                      Icons.send,
                    ),
                  ),
                ],
              )),
        ]
      ),

    );
  }

ScreenVideoPerview({
  required this.receiver
});
}
